-- =====================================================================
-- Схема БД — приложение для изучения японского
-- Диалект: SQLite (локальное хранилище через Drift на клиенте).
-- При переносе слоя синхронизации на Supabase (Postgres) отличия:
--   INTEGER PRIMARY KEY -> BIGINT GENERATED ALWAYS AS IDENTITY,
--   TEXT (даты)         -> TIMESTAMPTZ,
--   TEXT CHECK (...)    -> либо тот же CHECK, либо нативный ENUM,
--   JSON в TEXT-колонках -> JSONB.
-- Синхронизируется по-настоящему только вторая часть файла (USER DATA),
-- и то не вся — см. docs/database-design.md, раздел "Синхронизация".
-- =====================================================================


-- =====================================================================
-- ЧАСТЬ 1. CONTENT — общий контент, одинаковый у всех пользователей.
-- Поставляется вместе с приложением как отдельный бандл (content.db),
-- не требует аккаунта и не синхронизируется как пользовательские данные
-- (обновляется только через обновление контент-пака).
-- =====================================================================

-- Единая "супертаблица" для всего, что можно повторять/изучать.
-- Каждая единица словаря/кандзи/частицы/грамматики имеет ровно одну
-- запись здесь — это даёт единый внешний ключ для SRS, юнитов,
-- личного словаря и т.д. вместо полиморфных ссылок без целостности.
CREATE TABLE content_items (
  id            INTEGER PRIMARY KEY,
  kind          TEXT NOT NULL CHECK (kind IN ('kana','kanji','word','particle','grammar_point')),
  jlpt_level    TEXT CHECK (jlpt_level IN ('N5','N4','N3','N2','N1')),
  frequency_rank INTEGER,
  created_at    TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX idx_content_items_kind_level ON content_items(kind, jlpt_level);


-- ---- Кана -------------------------------------------------------------
CREATE TABLE kana (
  content_item_id INTEGER PRIMARY KEY REFERENCES content_items(id),
  script       TEXT NOT NULL CHECK (script IN ('hiragana','katakana')),
  char         TEXT NOT NULL,
  romaji       TEXT NOT NULL,
  gojuon_row   TEXT,                 -- группа годзюон, напр. 'a','ka','sa'...
  variant      TEXT CHECK (variant IN ('base','dakuten','handakuten','youon')),
  audio_url    TEXT,
  stroke_data  TEXT,                 -- JSON с порядком черт — под будущую прорисовку
  sort_order   INTEGER
);


-- ---- Кандзи и радикалы --------------------------------------------------
CREATE TABLE radicals (
  id           INTEGER PRIMARY KEY,
  char         TEXT NOT NULL,
  meaning_ru   TEXT NOT NULL,
  stroke_count INTEGER,
  mnemonic     TEXT,
  stroke_data  TEXT
);

CREATE TABLE kanji (
  content_item_id INTEGER PRIMARY KEY REFERENCES content_items(id),
  char         TEXT NOT NULL UNIQUE,
  meanings_ru  TEXT NOT NULL,        -- JSON-массив значений
  on_yomi      TEXT,                 -- JSON-массив чтений каной
  kun_yomi     TEXT,                 -- JSON-массив, окуригана через точку: "た.べる"
  joyo_grade   INTEGER,
  stroke_count INTEGER,
  mnemonic     TEXT,
  stroke_data  TEXT
);

-- Разбор кандзи на радикалы (для мнемоник в духе WaniKani)
CREATE TABLE kanji_radicals (
  content_item_id INTEGER NOT NULL REFERENCES kanji(content_item_id),
  radical_id      INTEGER NOT NULL REFERENCES radicals(id),
  position        TEXT,              -- 'left','top','enclosure' и т.п., опционально
  PRIMARY KEY (content_item_id, radical_id)
);


-- ---- Слова / дзюкуго ----------------------------------------------------
CREATE TABLE words (
  content_item_id INTEGER PRIMARY KEY REFERENCES content_items(id),
  surface_form TEXT NOT NULL,        -- напр. "電話"
  reading      TEXT NOT NULL,        -- напр. "でんわ"
  meanings_ru  TEXT NOT NULL,        -- JSON-массив
  part_of_speech TEXT,
  is_kana_only INTEGER NOT NULL DEFAULT 0,
  pitch_accent INTEGER,              -- номер моры ударения, опционально
  audio_url    TEXT
);

-- Из каких кандзи состоит слово — именно эта связь и реализует
-- "кандзи учится в паре со словом", а не изолированно.
CREATE TABLE word_kanji (
  word_content_item_id  INTEGER NOT NULL REFERENCES words(content_item_id),
  kanji_content_item_id INTEGER NOT NULL REFERENCES kanji(content_item_id),
  position               INTEGER NOT NULL,
  PRIMARY KEY (word_content_item_id, kanji_content_item_id)
);


-- ---- Частицы --------------------------------------------------------
CREATE TABLE particles (
  content_item_id INTEGER PRIMARY KEY REFERENCES content_items(id),
  particle          TEXT NOT NULL,     -- напр. "は"
  category          TEXT,              -- падежная / связочная / конечная ...
  short_description TEXT,
  long_theory       TEXT,              -- полная теория, markdown
  confusable_with   TEXT               -- JSON-массив content_item_id (は vs が и т.п.)
);


-- ---- Грамматика -------------------------------------------------------
CREATE TABLE grammar_points (
  content_item_id INTEGER PRIMARY KEY REFERENCES content_items(id),
  title       TEXT NOT NULL,          -- напр. "〜てもいい"
  pattern     TEXT NOT NULL,
  explanation TEXT NOT NULL,          -- markdown
  register    TEXT CHECK (register IN ('casual','polite','formal')),
  related_grammar_ids TEXT            -- JSON-массив content_item_id
);


-- ---- Примеры-предложения ------------------------------------------------
CREATE TABLE sentences (
  id                  INTEGER PRIMARY KEY,
  text_jp             TEXT NOT NULL,
  text_furigana       TEXT,           -- разметка фуриганы (JSON/ruby)
  text_translation_ru TEXT NOT NULL,
  audio_url           TEXT,
  jlpt_level          TEXT CHECK (jlpt_level IN ('N5','N4','N3','N2','N1'))
);

-- Какие элементы (слова/частицы/грамматика) встречаются в предложении —
-- нужно и для подсветки при чтении, и чтобы у каждой частицы/грамматики
-- были живые примеры, а не голое правило.
CREATE TABLE sentence_content_items (
  sentence_id     INTEGER NOT NULL REFERENCES sentences(id),
  content_item_id INTEGER NOT NULL REFERENCES content_items(id),
  usage_note      TEXT,
  PRIMARY KEY (sentence_id, content_item_id)
);


-- ---- Типы упражнений --------------------------------------------------
-- Отдельная таблица, а не enum в коде — чтобы добавлять новые типы
-- (например stroke_write для Android) без миграции srs_cards.
CREATE TABLE exercise_types (
  code     TEXT PRIMARY KEY,          -- 'recognize_meaning','recall_reading','listening_choice',
                                       -- 'typing_input','shadow_speak','stroke_write','fill_blank', ...
  pillar   TEXT NOT NULL CHECK (pillar IN ('reading','listening','speaking','writing')),
  label_ru TEXT NOT NULL
);


-- ---- Дорожная карта (юниты) --------------------------------------------
CREATE TABLE units (
  id          INTEGER PRIMARY KEY,
  title       TEXT NOT NULL,
  subtitle    TEXT,
  kind        TEXT NOT NULL CHECK (kind IN
                ('kana','kanji_vocab','particle','grammar','listening','reading','milestone','mixed')),
  jlpt_level  TEXT CHECK (jlpt_level IN ('N5','N4','N3','N2','N1')),
  sort_order  INTEGER NOT NULL,
  description TEXT
);

-- Не просто цепочка, а DAG: у юнита может быть несколько предпосылок
-- (например у вехи "N5 пройден" — сразу все юниты уровня N5).
CREATE TABLE unit_prerequisites (
  unit_id          INTEGER NOT NULL REFERENCES units(id),
  requires_unit_id INTEGER NOT NULL REFERENCES units(id),
  PRIMARY KEY (unit_id, requires_unit_id)
);

CREATE TABLE unit_items (
  unit_id         INTEGER NOT NULL REFERENCES units(id),
  content_item_id INTEGER NOT NULL REFERENCES content_items(id),
  role            TEXT NOT NULL CHECK (role IN ('new','reinforcement')) DEFAULT 'new',
  PRIMARY KEY (unit_id, content_item_id)
);


-- =====================================================================
-- ЧАСТЬ 2. USER DATA — приватные данные пользователя.
-- Локально хранятся всегда; при появлении аккаунта — синхронизируются
-- с Supabase. review_log — источник истины и синкается как append-only
-- журнал событий (без конфликтов); srs_cards — производный кэш,
-- который в теории можно полностью пересчитать из review_log.
-- =====================================================================

CREATE TABLE users (
  id           TEXT PRIMARY KEY,      -- UUID = Supabase auth.users.id (в т.ч. anonymous-сессия)
  display_name TEXT,
  created_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Результат онбординга: веса 4 столпов, темп, личная цель.
CREATE TABLE user_profile (
  user_id                 TEXT PRIMARY KEY REFERENCES users(id),
  weight_listening        INTEGER NOT NULL DEFAULT 25,
  weight_speaking         INTEGER NOT NULL DEFAULT 25,
  weight_reading          INTEGER NOT NULL DEFAULT 25,
  weight_writing          INTEGER NOT NULL DEFAULT 25,
  daily_minutes_goal      INTEGER NOT NULL DEFAULT 15,
  comprehension_goal_pct  INTEGER,             -- НЕ хардкод — ставит сам пользователь на онбординге
  target_jlpt_level       TEXT CHECK (target_jlpt_level IN ('N5','N4','N3','N2','N1')),
  placement_level         TEXT CHECK (placement_level IN ('N5','N4','N3','N2','N1')),
  updated_at              TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Текущее состояние карточки SRS. Уникальна связка
-- (пользователь, элемент контента, тип упражнения) — то есть у одного
-- кандзи может быть несколько карточек: на значение, на чтение, на письмо.
CREATE TABLE srs_cards (
  id               TEXT PRIMARY KEY,   -- UUID, генерируется на клиенте
  user_id          TEXT NOT NULL REFERENCES users(id),
  content_item_id  INTEGER NOT NULL REFERENCES content_items(id),
  exercise_type    TEXT NOT NULL REFERENCES exercise_types(code),
  state            TEXT NOT NULL CHECK (state IN ('new','learning','review','relearning','suspended'))
                     DEFAULT 'new',
  due_at           TEXT,
  stability        REAL,               -- параметры FSRS
  difficulty       REAL,
  reps             INTEGER NOT NULL DEFAULT 0,
  lapses           INTEGER NOT NULL DEFAULT 0,
  last_reviewed_at TEXT,
  UNIQUE (user_id, content_item_id, exercise_type)
);
CREATE INDEX idx_srs_due ON srs_cards(user_id, due_at);

-- Источник истины: append-only журнал каждого повторения.
-- Синхронизация Windows <-> Android сводится к обмену новыми строками
-- этой таблицы — конфликтов почти не бывает по конструкции.
CREATE TABLE review_log (
  id               TEXT PRIMARY KEY,   -- UUID, генерируется на клиенте (идемпотентность синка)
  user_id          TEXT NOT NULL REFERENCES users(id),
  card_id          TEXT NOT NULL REFERENCES srs_cards(id),
  rating           TEXT NOT NULL CHECK (rating IN ('again','hard','good','easy')),
  reviewed_at      TEXT NOT NULL,
  response_time_ms INTEGER,
  device           TEXT                -- 'windows' | 'android' | ...
);
CREATE INDEX idx_review_log_user_time ON review_log(user_id, reviewed_at);

CREATE TABLE unit_progress (
  user_id      TEXT NOT NULL REFERENCES users(id),
  unit_id      INTEGER NOT NULL REFERENCES units(id),
  status       TEXT NOT NULL CHECK (status IN ('locked','unlocked','in_progress','completed'))
                DEFAULT 'locked',
  started_at   TEXT,
  completed_at TEXT,
  PRIMARY KEY (user_id, unit_id)
);

-- Личный словарь — слова вне куррикулума (вкладка "Словарь").
CREATE TABLE user_vocab (
  user_id         TEXT NOT NULL REFERENCES users(id),
  content_item_id INTEGER NOT NULL REFERENCES content_items(id),  -- kind = 'word'
  added_at        TEXT NOT NULL DEFAULT (datetime('now')),
  source          TEXT CHECK (source IN ('manual','from_unit','from_reading')),
  PRIMARY KEY (user_id, content_item_id)
);

CREATE TABLE daily_activity (
  user_id          TEXT NOT NULL REFERENCES users(id),
  activity_date    TEXT NOT NULL,      -- 'YYYY-MM-DD'
  reviews_done     INTEGER NOT NULL DEFAULT 0,
  new_items_learned INTEGER NOT NULL DEFAULT 0,
  minutes_spent    INTEGER NOT NULL DEFAULT 0,
  goal_met         INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, activity_date)
);

-- Периодический снимок оценки понимания — по каждому из 4 столпов
-- отдельно (не одно число), плюс агрегат для главного экрана.
CREATE TABLE comprehension_snapshot (
  user_id        TEXT NOT NULL REFERENCES users(id),
  snapshot_date  TEXT NOT NULL,
  reading_pct    REAL,
  listening_pct  REAL,
  speaking_score REAL,
  writing_score  REAL,
  overall_pct    REAL,
  PRIMARY KEY (user_id, snapshot_date)
);
