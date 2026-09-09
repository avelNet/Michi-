import 'dart:convert';

import 'package:drift/drift.dart';

import '../database.dart';

/// Полный последовательный курс N5: грамматика, частицы, базовая лексика,
/// аудирование — плюс сборка дорожной карты в один связный маршрут.
///
/// Запускается на КАЖДОМ старте и полностью идемпотентен: контент
/// добавляется по натуральным ключам (заголовок пункта грамматики, сам
/// знак частицы, пара «написание|чтение» слова), граф юнитов
/// пересобирается заново. Существующие установки, где сид уже отработал
/// старую (неполную) карту, до-наполняются без потери прогресса —
/// content_item_id уже созданных элементов не меняются.
Future<void> ensureCurriculum(AppDatabase db) async {
  await db.transaction(() async {
    // ---------- helpers ------------------------------------------------
    Future<int> ensureUnit(
      String title, {
      required String kind,
      String? subtitle,
      String jlpt = 'N5',
      required int sortOrder,
      String? description,
    }) async {
      final existing = await (db.select(db.units)
            ..where((t) => t.title.equals(title)))
          .getSingleOrNull();
      if (existing != null) {
        await (db.update(db.units)..where((t) => t.id.equals(existing.id))).write(
          UnitsCompanion(
            kind: Value(kind),
            subtitle: Value(subtitle),
            sortOrder: Value(sortOrder),
            description: Value(description ?? existing.description),
          ),
        );
        return existing.id;
      }
      return db.into(db.units).insert(UnitsCompanion.insert(
            title: title,
            subtitle: Value(subtitle),
            kind: kind,
            jlptLevel: Value(jlpt),
            sortOrder: sortOrder,
            description: Value(description),
          ));
    }

    Future<int> ensureGrammar(GrammarSeed g) async {
      final ex = await (db.select(db.grammarPoints)
            ..where((t) => t.title.equals(g.title)))
          .getSingleOrNull();
      if (ex != null) {
        await (db.update(db.grammarPoints)
              ..where((t) => t.contentItemId.equals(ex.contentItemId)))
            .write(GrammarPointsCompanion(
          pattern: Value(g.pattern),
          explanation: Value(g.explanation),
          register: Value(g.register),
        ));
        return ex.contentItemId;
      }
      final cid = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(
                kind: 'grammar_point', jlptLevel: const Value('N5')),
          );
      await db.into(db.grammarPoints).insert(GrammarPointsCompanion.insert(
            contentItemId: Value(cid),
            title: g.title,
            pattern: g.pattern,
            explanation: g.explanation,
            register: Value(g.register),
          ));
      return cid;
    }

    Future<int> ensureParticle(ParticleSeed p) async {
      final ex = await (db.select(db.particles)
            ..where((t) => t.particle.equals(p.particle)))
          .getSingleOrNull();
      if (ex != null) {
        await (db.update(db.particles)
              ..where((t) => t.contentItemId.equals(ex.contentItemId)))
            .write(ParticlesCompanion(
          category: Value(p.category),
          shortDescription: Value(p.shortDescription),
          longTheory: Value(p.longTheory),
          confusableWith: Value(p.confusableWith),
        ));
        return ex.contentItemId;
      }
      final cid = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(
                kind: 'particle', jlptLevel: const Value('N5')),
          );
      await db.into(db.particles).insert(ParticlesCompanion.insert(
            contentItemId: Value(cid),
            particle: p.particle,
            category: Value(p.category),
            shortDescription: Value(p.shortDescription),
            longTheory: Value(p.longTheory),
            confusableWith: Value(p.confusableWith),
          ));
      return cid;
    }

    Future<int> ensureWord(WordSeed w, {String? jlpt = 'N5'}) async {
      final ex = await (db.select(db.words)
            ..where((t) =>
                t.surfaceForm.equals(w.surface) & t.reading.equals(w.reading)))
          .getSingleOrNull();
      if (ex != null) return ex.contentItemId;
      final cid = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'word', jlptLevel: Value(jlpt)),
          );
      await db.into(db.words).insert(WordsCompanion.insert(
            contentItemId: Value(cid),
            surfaceForm: w.surface,
            reading: w.reading,
            meaningsRu: jsonEncode(w.meanings),
            isKanaOnly: Value(w.kanaOnly ? 1 : 0),
          ));
      return cid;
    }

    Future<void> link(int unitId, Iterable<int> contentIds) async {
      for (final id in contentIds) {
        await db.into(db.unitItems).insert(
              UnitItemsCompanion.insert(unitId: unitId, contentItemId: id),
              mode: InsertMode.insertOrIgnore,
            );
      }
    }

    // ---------- units ------------------------------------------------
    final uHiragana = await _unitIdByTitle(db, 'Хирагана');
    final uKatakana = await _unitIdByTitle(db, 'Катакана');

    final kanjiUnitIds = await _kanjiUnitIdsInOrder(db);

    final uVocab1 = await ensureUnit('Базовые слова N5 I',
        kind: 'mixed',
        subtitle: 'Приветствия, числа, люди, время',
        sortOrder: 20,
        description:
            'Небольшой запас слов, на который дальше опирается вся грамматика. '
            'Здесь — то, что нужно в каждом первом разговоре: приветствия, '
            'числа, местоимения, слова про время и людей.');
    final uGrammar1 = await ensureUnit('Грамматика N5 I',
        kind: 'grammar',
        subtitle: 'です, это/то, вопрос か, прилагательные',
        sortOrder: 21,
        description:
            'Костяк простого предложения: связка です, указательные слова, '
            'два типа прилагательных и вопрос через か.');
    final uParticles1 = await _unitIdByTitleOrEnsure(db, 'Частицы I', ensureUnit,
        kind: 'particle',
        subtitle: 'は · が · を · に',
        sortOrder: 22,
        description:
            'Частицы показывают роль слова в предложении. Четыре самые частые: '
            'は (тема), が (подлежащее), を (прямое дополнение), に (куда/когда/где).');
    final uVocab2 = await ensureUnit('Базовые слова N5 II',
        kind: 'mixed',
        subtitle: 'Глаголы, места, предметы, признаки',
        sortOrder: 23,
        description:
            'Второй заход по лексике: глаголы действия, названия мест, '
            'повседневные предметы и прилагательные-признаки.');
    final uGrammar2 = await _unitIdByTitleOrEnsure(
        db, 'Грамматика N5 II', ensureUnit,
        kind: 'grammar',
        subtitle: 'ます-глаголы, есть/находиться, движение, хочу',
        sortOrder: 24,
        description:
            'Глагол в вежливой форме, существование (います/あります), '
            'движение куда-то и конструкция «хочу сделать».');
    final uParticles2 = await _unitIdByTitleOrEnsure(db, 'Частицы II', ensureUnit,
        kind: 'particle',
        subtitle: 'で · へ · と · も · の',
        sortOrder: 25,
        description:
            'Частицы места действия и средства (で), направления (へ), '
            'совместности и соединения (と), «тоже» (も) и связка существительных (の).');
    final uListening1 = await _unitIdByTitleOrEnsure(
        db, 'Аудирование I', ensureUnit,
        kind: 'listening',
        subtitle: 'Короткие фразы на слух',
        sortOrder: 26,
        description:
            'Слушайте фразу целиком, потом проверяйте себя. Кнопка 🔊 '
            'озвучивает через системный синтезатор Windows. Если японского '
            'голоса в системе нет — читайте вслух сами по ромадзи, это тоже '
            'полезно.');
    final uGrammar3 = await ensureUnit('Грамматика N5 III',
        kind: 'grammar',
        subtitle: 'て-форма: просьбы, длительность, запрет, долг',
        sortOrder: 27,
        description:
            'Одна из главных форм японского глагола — て-форма — и всё, что '
            'на ней строится: просьбы, «сейчас делаю», «после того как», запрет, '
            'долженствование.');
    final uParticles3 = await ensureUnit('Частицы III',
        kind: 'particle',
        subtitle: 'から · まで · や · か · ね · よ · より',
        sortOrder: 28,
        description:
            'Частицы «от…до», неполного перечисления (や), выбора (か), '
            'оттенков в конце фразы (ね/よ) и сравнения (より).');
    final uListening2 = await _unitIdByTitleOrEnsure(
        db, 'Аудирование II', ensureUnit,
        kind: 'listening',
        subtitle: 'Мини-диалоги',
        sortOrder: 29,
        description: 'Короткие обмены репликами в естественном темпе.');
    final uMilestone = await _unitIdByTitleOrEnsure(db, 'Веха N5', ensureUnit,
        kind: 'milestone',
        subtitle: 'Проверка уровня',
        sortOrder: 90,
        description:
            'Контрольная точка: если уверенно проходите повторение по всем '
            'разделам N5 — можно двигаться к N4.');

    // ---------- content -> units -----------------------------------
    Future<List<int>> grammarIds(List<GrammarSeed> gs) async =>
        [for (final g in gs) await ensureGrammar(g)];
    Future<List<int>> particleIds(List<ParticleSeed> ps) async =>
        [for (final p in ps) await ensureParticle(p)];
    Future<List<int>> wordIds(List<WordSeed> ws) async =>
        [for (final w in ws) await ensureWord(w)];

    await link(uGrammar1, await grammarIds(grammarN5I));
    await link(uGrammar2, await grammarIds(grammarN5II));
    await link(uGrammar3, await grammarIds(grammarN5III));

    await link(uParticles1, await particleIds(particlesI));
    await link(uParticles2, await particleIds(particlesII));
    await link(uParticles3, await particleIds(particlesIII));

    await link(uVocab1, await wordIds(coreVocabI));
    await link(uVocab2, await wordIds(coreVocabII));

    await link(uListening1, await wordIds(listeningI));
    await link(uListening2, await wordIds(listeningII));

    // ---------- N4: каркас трека кандзи (данные уже в базе) --------
    // 170 кандзи N4 импортированы вместе с N5 — раскладываем их в юниты
    // по 25, чтобы трек кандзи продолжался за N5, а не обрывался.
    final n4KanjiUnitIds = <int>[];
    final n4Kanji = await (db.select(db.contentItems)
          ..where((t) => t.kind.equals('kanji') & t.jlptLevel.equals('N4'))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    if (n4Kanji.isNotEmpty) {
      const chunk = 25;
      final roman = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'];
      for (var start = 0; start < n4Kanji.length; start += chunk) {
        final part = n4Kanji.sublist(start, (start + chunk).clamp(0, n4Kanji.length));
        final idx = n4KanjiUnitIds.length;
        final unitId = await ensureUnit(
          'Кандзи N4 · ${roman[idx]}',
          kind: 'kanji_vocab',
          jlpt: 'N4',
          subtitle: '${part.length} иероглифов N4 со словами',
          sortOrder: 200 + idx,
          description: idx == 0
              ? 'Кандзи уровня N4 — те же правила, что и в N5: каждый иероглиф '
                  'сразу со словами, где он реально встречается. Порядок — по '
                  'частотности.'
              : 'Ещё ${part.length} иероглифов N4.',
        );
        final ids = <int>[];
        for (final k in part) {
          ids.add(k.id);
          final ws = await (db.select(db.wordKanji)
                ..where((t) => t.kanjiContentItemId.equals(k.id)))
              .get();
          ids.addAll(ws.map((w) => w.wordContentItemId));
        }
        await link(unitId, ids);
        n4KanjiUnitIds.add(unitId);
      }
    }

    final uMilestoneN4 = n4KanjiUnitIds.isEmpty
        ? null
        : await ensureUnit('Веха N4',
            kind: 'milestone',
            jlpt: 'N4',
            subtitle: 'Проверка уровня N4',
            sortOrder: 260,
            description:
                'Кандзи N4 пройдены. Грамматика и лексика N4 добавятся в '
                'следующих обновлениях курса — трек уже готов их принять.');

    // ---------- roadmap graph (rebuilt from scratch) ---------------
    await db.delete(db.unitPrerequisites).go();
    Future<void> req(int unit, int requires) => db
        .into(db.unitPrerequisites)
        .insert(
          UnitPrerequisitesCompanion.insert(
              unitId: unit, requiresUnitId: requires),
          mode: InsertMode.insertOrIgnore,
        );

    // Кана — общий вход.
    await req(uKatakana, uHiragana);

    // Трек кандзи — своя цепочка, открывается после каны. За N5 сразу
    // продолжается кандзи N4, затем Веха N4.
    final kanjiChain = [...kanjiUnitIds, ...n4KanjiUnitIds];
    if (kanjiChain.isNotEmpty) {
      await req(kanjiChain.first, uKatakana);
      for (var i = 1; i < kanjiChain.length; i++) {
        await req(kanjiChain[i], kanjiChain[i - 1]);
      }
    }
    if (uMilestoneN4 != null && n4KanjiUnitIds.isNotEmpty) {
      await req(uMilestoneN4, n4KanjiUnitIds.last);
    }

    // Основной путь — один сквозной маршрут.
    final mainChain = [
      uVocab1,
      uGrammar1,
      uParticles1,
      uVocab2,
      uGrammar2,
      uParticles2,
      uListening1,
      uGrammar3,
      uParticles3,
      uListening2,
    ];
    await req(mainChain.first, uKatakana);
    for (var i = 1; i < mainChain.length; i++) {
      await req(mainChain[i], mainChain[i - 1]);
    }

    // Веха требует хвост основного пути и хвост трека кандзи.
    await req(uMilestone, mainChain.last);
    if (kanjiUnitIds.isNotEmpty) await req(uMilestone, kanjiUnitIds.last);
  });
}

Future<int> _unitIdByTitle(AppDatabase db, String title) async {
  final row =
      await (db.select(db.units)..where((t) => t.title.equals(title))).getSingle();
  return row.id;
}

Future<int> _unitIdByTitleOrEnsure(
  AppDatabase db,
  String title,
  Future<int> Function(String,
          {required String kind,
          String? subtitle,
          String jlpt,
          required int sortOrder,
          String? description})
      ensure, {
  required String kind,
  String? subtitle,
  required int sortOrder,
  String? description,
}) {
  return ensure(title,
      kind: kind,
      subtitle: subtitle,
      sortOrder: sortOrder,
      description: description);
}

/// id юнитов трека кандзи по возрастанию sort_order (Кандзи и слова I..N).
Future<List<int>> _kanjiUnitIdsInOrder(AppDatabase db) async {
  final rows = await (db.select(db.units)
        ..where((t) => t.kind.equals('kanji_vocab'))
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .get();
  return rows.map((r) => r.id).toList();
}

// =====================================================================
// ДАННЫЕ
// =====================================================================

class GrammarSeed {
  final String title;
  final String pattern;
  final String explanation;
  final String register; // casual | polite | formal
  const GrammarSeed(this.title, this.pattern, this.explanation,
      {this.register = 'polite'});
}

class ParticleSeed {
  final String particle;
  final String category;
  final String shortDescription;
  final String longTheory;
  final String? confusableWith;
  const ParticleSeed(this.particle, this.category, this.shortDescription,
      this.longTheory,
      {this.confusableWith});
}

class WordSeed {
  final String surface;
  final String reading;
  final List<String> meanings;
  final bool kanaOnly;
  const WordSeed(this.surface, this.reading, this.meanings,
      {this.kanaOnly = false});
}

// ---------------------------------------------------------------------
// Грамматика N5 I — костяк простого предложения
// ---------------------------------------------------------------------
const grammarN5I = <GrammarSeed>[
  GrammarSeed(
    'AはBです — «A есть B»',
    'A は B です',
    'Основное утвердительное предложение. は (читается «wa») отмечает тему, '
        'です — вежливая связка «есть/является». Глагола-связки в русском смысле '
        'нет, порядок жёсткий: тема — впереди, です — в самом конце.\n'
        'わたしは がくせいです。 — Я студент.\n'
        'これは ほんです。 — Это книга.',
  ),
  GrammarSeed(
    'AはBじゃないです — отрицание связки',
    'A は B じゃないです / ではありません',
    'Отрицание «A не есть B». Разговорный вариант — じゃないです, более '
        'формальный — ではありません (は здесь тоже «wa»).\n'
        'わたしは せんせいじゃないです。 — Я не учитель.\n'
        'これは わたしの かばんではありません。 — Это не моя сумка.',
  ),
  GrammarSeed(
    '…か — вопросительная частица',
    '… です か',
    'Ставится в самый конец предложения и превращает его в вопрос. Порядок '
        'слов не меняется, вопросительный знак не обязателен.\n'
        'あなたは がくせいですか。 — Вы студент?\n'
        'これは なんですか。 — Что это?',
  ),
  GrammarSeed(
    'これ · それ · あれ · どれ — это / то / вон то / который',
    'これ / それ / あれ / どれ',
    'Указывают на предмет, сами по себе (без существительного). これ — рядом с '
        'говорящим, それ — рядом с собеседником, あれ — вдали от обоих, どれ — '
        '«который из».\n'
        'それは わたしの ペンです。 — Это (у тебя) моя ручка.\n'
        'あれは えきですか。 — Вон то — станция?',
  ),
  GrammarSeed(
    'この · その · あの · どの + существительное',
    'この / その / あの / どの + N',
    'То же деление по расстоянию, что これ/それ/あれ, но обязательно с '
        'существительным после: «этот дом», «та книга».\n'
        'この ほんは おもしろいです。 — Эта книга интересная.\n'
        'あの ひとは だれですか。 — Кто вон тот человек?',
  ),
  GrammarSeed(
    'ここ · そこ · あそこ · どこ — здесь / там / вон там / где',
    'ここ / そこ / あそこ / どこ',
    'Указательные слова для места. どこ — вопрос «где».\n'
        'トイレは どこですか。 — Где туалет?\n'
        'えきは あそこです。 — Станция вон там.',
  ),
  GrammarSeed(
    'い-прилагательные',
    'い-adj + N / い-adj です',
    'Прилагательные, оканчивающиеся на い. Перед существительным ставятся без '
        'изменений (おおきい いえ — большой дом), в конце предложения — просто '
        '+ です. Отрицание: い → くないです (おおきくないです — не большой).\n'
        'この かばんは たかいです。 — Эта сумка дорогая.\n'
        'きょうは さむくないです。 — Сегодня не холодно.',
  ),
  GrammarSeed(
    'な-прилагательные',
    'な-adj な + N / な-adj です',
    'Вторая группа прилагательных. Перед существительным добавляют な '
        '(きれいな はな — красивый цветок), в конце предложения — + です без な. '
        'Отрицание: じゃないです.\n'
        'この まちは しずかです。 — Этот город тихий.\n'
        'へやは きれいじゃないです。 — Комната не чистая.',
  ),
  GrammarSeed(
    'AはBがすきです — нравится / умеет',
    'A は B が すき / じょうず です',
    'Чувство или умение оформляется через が: объект симпатии/навыка помечается '
        'が, а не を. Так же работают きらい (не нравится), じょうず (умело), '
        'へた (неумело), ほしい (хочется).\n'
        'わたしは にほんごが すきです。 — Мне нравится японский.\n'
        'あには りょうりが じょうずです。 — Старший брат хорошо готовит.',
  ),
  GrammarSeed(
    '…も — «тоже»',
    'A も B です',
    'も заменяет は или が и означает «тоже, также». '
        'わたしも — «я тоже».\n'
        'わたしは がくせいです。かれも がくせいです。 — Я студент. Он тоже студент.\n'
        'これも ください。 — Это тоже дайте, пожалуйста.',
  ),
  GrammarSeed(
    'NのN — определение существительным',
    'N1 の N2',
    'の связывает два существительных: принадлежность (わたしの ほん — моя '
        'книга), вид/материал (にほんごの せんせい — учитель японского), место '
        '(とうきょうの だいがく — университет в Токио).\n'
        'これは ともだちの くるまです。 — Это машина друга.\n'
        'にほんごの じゅぎょうは たのしいです。 — Урок японского весёлый.',
  ),
  GrammarSeed(
    '…ました / …ませんでした — прошедшее время',
    'V-ます → V-ました / V-ませんでした',
    'Вежливое прошедшее: ます → ました (сделал), ません → ませんでした (не '
        'сделал). Время показывается только глаголом, слова вроде きのう '
        '(вчера) его дублируют для ясности.\n'
        'きのう えいがを みました。 — Вчера смотрел фильм.\n'
        'あさごはんを たべませんでした。 — Не позавтракал.',
  ),
];

// ---------------------------------------------------------------------
// Грамматика N5 II — глаголы, существование, движение, желание
// ---------------------------------------------------------------------
const grammarN5II = <GrammarSeed>[
  GrammarSeed(
    'V-ます / V-ません — вежливое настояще-будущее',
    'V-ます / V-ません',
    'Базовая вежливая форма глагола. ます — утверждение (и настоящее, и '
        'будущее), ません — отрицание. Конкретное время уточняют словами '
        '(まいにち — каждый день, あした — завтра).\n'
        'まいにち にほんごを べんきょうします。 — Каждый день учу японский.\n'
        'おさけを のみません。 — Не пью алкоголь.',
  ),
  GrammarSeed(
    'います / あります — существование',
    'N が います / あります',
    'Оба значат «есть, имеется». います — для живого (люди, животные), '
        'あります — для неживого и явлений. Предмет помечается が.\n'
        'つくえの うえに ねこが います。 — На столе кошка.\n'
        'かばんの なかに ほんが あります。 — В сумке есть книга.',
  ),
  GrammarSeed(
    '…に あります / います — местонахождение',
    'N1 は N2 に あります / います',
    'Где что находится: место помечается に. Тема (N1) — то, о чём говорим, '
        'место (N2) + に — ответ «где».\n'
        'わたしの いえは えきの ちかくに あります。 — Мой дом рядом со станцией.\n'
        'せんせいは きょうしつに います。 — Учитель в классе.',
  ),
  GrammarSeed(
    '…へ / …に いきます · きます · かえります — движение',
    'место へ/に いきます',
    'Направление движения помечается へ (читается «e») или に. Глаголы: '
        'いきます (идти туда), きます (приходить сюда), かえります '
        '(возвращаться).\n'
        'あした とうきょうへ いきます。 — Завтра еду в Токио.\n'
        'ろくじに いえに かえります。 — В шесть вернусь домой.',
  ),
  GrammarSeed(
    '…で — место действия',
    'место で V',
    'Где происходит действие — помечается で (не に!). に — это точка '
        'нахождения/назначения, で — площадка, где что-то делают.\n'
        'としょかんで ほんを よみます。 — Читаю книгу в библиотеке.\n'
        'うちで えいがを みます。 — Смотрю фильм дома.',
    register: 'polite',
  ),
  GrammarSeed(
    '…を — прямое дополнение',
    'N を V',
    'を отмечает то, над чем совершается действие: «читаю (что?) книгу». '
        'С глаголами движения を имеет другой смысл — «по/через» (みちを '
        'あるきます — иду по улице).\n'
        'ごはんを たべます。 — Ем рис.\n'
        'てがみを かきます。 — Пишу письмо.',
  ),
  GrammarSeed(
    '…と — совместность: «с кем»',
    'N と V',
    'と между существительными — «и» (полное перечисление: ぱんと たまご — '
        'хлеб и яйцо). と перед глаголом — «вместе с»: «с кем делаю».\n'
        'ともだちと えいがを みました。 — Смотрел фильм с другом.\n'
        'かぞくと にほんへ いきます。 — Едем в Японию с семьёй.',
  ),
  GrammarSeed(
    '…ませんか / …ましょう — приглашение и предложение',
    'V-ませんか / V-ましょう',
    'V-ませんか — вежливое приглашение «не хотите ли…?». V-ましょう — «давайте…» '
        '(говорящий уже настроен). Ответ-согласие часто: ええ、V-ましょう.\n'
        'いっしょに ひるごはんを たべませんか。 — Не пообедаем вместе?\n'
        'じゃあ、いきましょう。 — Тогда пойдём.',
  ),
  GrammarSeed(
    'V-たいです — «хочу сделать»',
    'V-ます основа + たいです',
    'Убираем ます, добавляем たいです: のみます → のみたいです (хочу выпить). '
        'Объект желания может помечаться が или を. Отрицание — たくないです.\n'
        'みずが のみたいです。 — Хочу воды.\n'
        'きょうは どこも いきたくないです。 — Сегодня никуда не хочу идти.',
  ),
  GrammarSeed(
    '…が、… — «но» (мягкое противопоставление)',
    'предложение 1 が、предложение 2',
    'が в конце придаточного — «но, однако», мягче, чем でも. Соединяет два '
        'законченных предложения.\n'
        'この りょうりは たかいですが、おいしいです。 — Это блюдо дорогое, но вкусное.\n'
        'にほんごは むずかしいですが、たのしいです。 — Японский трудный, но интересный.',
  ),
  GrammarSeed(
    '…から — «потому что» (причина)',
    'причина から、следствие',
    'から после предложения — «так как, потому что». Причина идёт первой, '
        'вывод — вторым. Не путать с から-«из/от» после существительного.\n'
        'あついですから、まどを あけます。 — Жарко, поэтому открою окно.\n'
        'じかんが ありませんから、いきません。 — Времени нет, поэтому не пойду.',
  ),
  GrammarSeed(
    '数 + counters — счётные суффиксы',
    '数字 + つ / 人 / 枚 / 本 / 回',
    'Считать «просто числом» нельзя — нужен счётный суффикс под тип предмета: '
        '〜つ (универсальный, 1–9: ひとつ, ふたつ…), 〜人 (にん — люди), 〜枚 (まい '
        '— плоское: листы, билеты), 〜本 (ほん — длинное: ручки, бутылки), 〜回 '
        '(かい — разы).\n'
        'りんごを みっつ ください。 — Дайте три яблока.\n'
        'きってを にまい かいました。 — Купил две марки.',
  ),
];

// ---------------------------------------------------------------------
// Грамматика N5 III — て-форма и всё вокруг неё
// ---------------------------------------------------------------------
const grammarN5III = <GrammarSeed>[
  GrammarSeed(
    'て-форма глагола — образование',
    'V → V-て',
    'Ключевая соединительная форма. Для II спряжения (…る): る → て '
        '(たべる → たべて). Для I спряжения — по окончанию: う·つ·る → って, '
        'む·ぶ·ぬ → んで, く → いて (いく → いって — искл.), ぐ → いで, す → して. '
        'Неправильные: する → して, くる → きて.',
    register: 'casual',
  ),
  GrammarSeed(
    'V-てください — просьба',
    'V-て ください',
    'Вежливая просьба сделать что-то. Смягчается словами すみませんが… перед '
        'ней.\n'
        'もう いちど いってください。 — Скажите ещё раз, пожалуйста.\n'
        'ここに なまえを かいてください。 — Напишите здесь имя.',
  ),
  GrammarSeed(
    'V-ています — длящееся действие и состояние',
    'V-て います',
    'Два значения: (1) действие прямо сейчас (いま ごはんを たべています — сейчас '
        'ем), (2) устойчивое состояние/факт (とうきょうに すんでいます — живу в '
        'Токио; けっこんしています — женат).\n'
        'あめが ふっています。 — Идёт дождь.\n'
        'ちちは ぎんこうで はたらいています。 — Отец работает в банке.',
  ),
  GrammarSeed(
    'V-てから — «после того как»',
    'V-て から、…',
    'Сначала одно действие, потом другое, с акцентом на порядок. Отличается от '
        'простого перечисления через て тем, что подчёркивает «только после».\n'
        'ごはんを たべてから、べんきょうします。 — Поем и потом буду заниматься.\n'
        'てを あらってから、たべてください。 — Помойте руки, потом ешьте.',
  ),
  GrammarSeed(
    'V-ないでください — «пожалуйста, не…»',
    'V-ない + でください',
    'Просьба чего-то НЕ делать. Берём отрицательную (ない) форму: たべる → '
        'たべない → たべないでください.\n'
        'ここで しゃしんを とらないでください。 — Не фотографируйте здесь.\n'
        'しんぱいしないでください。 — Не волнуйтесь.',
  ),
  GrammarSeed(
    'V-なければなりません — долженствование',
    'V-ない → V-なければなりません',
    '«Обязан, должен». Разговорно сокращается до …なきゃ. Форма громоздкая — '
        'учат целиком как оборот. Мягче: …ほうが いいです (лучше бы…).\n'
        'あした はやく おきなければなりません。 — Завтра надо встать рано.\n'
        'くすりを のまなければなりません。 — Нужно принять лекарство.',
  ),
  GrammarSeed(
    'V-ことが できます — «мочь, уметь»',
    'V(словарная) こと が できます',
    'Способность или разрешение. Глагол — в словарной форме + ことが できます. '
        'Отрицание — ことが できません.\n'
        'わたしは かんじを よむことが できます。 — Я умею читать кандзи.\n'
        'ここで おかねを はらうことが できますか。 — Здесь можно заплатить?',
  ),
  GrammarSeed(
    'AよりBのほうが… — сравнение',
    'A より B の ほうが adj です',
    '«B более adj, чем A». より ставится после того, что «слабее». Вопрос: '
        'AとBと どちらが adj ですか。\n'
        'でんしゃより くるまの ほうが はやいです。 — Машина быстрее поезда.\n'
        'なつと ふゆと どちらが すきですか。 — Что больше нравится — лето или зима?',
  ),
  GrammarSeed(
    'いちばん… — превосходная степень',
    'グループ の なかで いちばん adj',
    'いちばん перед прилагательным — «самый». Область сравнения задаётся '
        '…の なかで.\n'
        'クラスで いちばん せが たかいです。 — Самый высокий в классе.\n'
        'にほんで ふじさんが いちばん たかいです。 — В Японии Фудзи — самая высокая.',
  ),
  GrammarSeed(
    'まだ / もう — «ещё» / «уже»',
    'もう V-ました / まだ V-ていません',
    'もう + прошедшее — «уже сделал». まだ + …ていません — «ещё не». '
        'まだ + утверждение — «всё ещё».\n'
        'もう ひるごはんを たべましたか。 — Уже пообедали?\n'
        'いいえ、まだ たべていません。 — Нет, ещё не ел.',
  ),
];

// ---------------------------------------------------------------------
// Частицы
// ---------------------------------------------------------------------
const particlesI = <ParticleSeed>[
  ParticleSeed('は', 'тематическая', 'Отмечает тему предложения',
      'は (произносится «wa») выделяет тему — то, о чём идёт речь дальше. Это не '
          'то же самое, что подлежащее: тема может быть шире («Что касается X — …»). '
          'Часто противопоставляется が.',
      confusableWith: 'が'),
  ParticleSeed('が', 'падежная', 'Отмечает подлежащее',
      'が указывает того, кто выполняет действие или обладает свойством — и '
          'подаёт это как новую информацию. С すき/じょうず/ある/いる/ほしい '
          'объект тоже помечается が.',
      confusableWith: 'は'),
  ParticleSeed('を', 'падежная', 'Прямое дополнение',
      'を (произносится «o») отмечает объект, над которым совершается действие: '
          '«читаю (что?) книгу». С глаголами движения — «по/через»: '
          'こうえんを さんぽします.'),
  ParticleSeed('に', 'падежная', 'Куда, когда, где находится',
      'Очень многозначная: направление (がっこうに いく), точное время '
          '(しちじに おきる), место нахождения с ある/いる (へやに いる), адресат '
          '(ともだちに あげる).',
      confusableWith: 'で'),
];

const particlesII = <ParticleSeed>[
  ParticleSeed('で', 'падежная', 'Место действия и средство',
      'Два основных значения: где происходит действие (としょかんで べんきょうする) '
          'и чем/на чём (バスで いく — на автобусе, はしで たべる — палочками). '
          'Не путать с に — та про точку нахождения, で про процесс.',
      confusableWith: 'に'),
  ParticleSeed('へ', 'падежная', 'Направление движения',
      'へ (произносится «e») ставится после места и перед глаголом движения: '
          'にほんへ いく. Часто взаимозаменяема с に в этом значении, но へ '
          'подчёркивает именно направление, а не конечную точку.',
      confusableWith: 'に'),
  ParticleSeed('と', 'соединительная', '«И» (полный список) / «вместе с»',
      'Между существительными と — «и», причём список считается полным '
          '(ぱんと たまご — только хлеб и яйцо). Перед глаголом と — «совместно с» '
          '(ともだちと はなす).',
      confusableWith: 'や'),
  ParticleSeed('も', 'выделительная', '«Тоже, также»',
      'Заменяет は или が: «X тоже». С отрицанием и вопросительным словом даёт '
          '«ни…»: なにも たべない (ничего не ем), だれも いない (никого нет).'),
  ParticleSeed('の', 'соединительная', 'Связка существительных',
      'N1の N2: принадлежность (わたしの), свойство (にほんごの ほん — книга по '
          'японскому), место (きょうとの おてら). Ещё の заменяет повторяющееся '
          'существительное: あかいのを ください — дайте красный.'),
];

const particlesIII = <ParticleSeed>[
  ParticleSeed('から', 'падежная', '«От, из» (начало) — и «потому что»',
      'После существительного — точка начала во времени или пространстве '
          '(くじから — с девяти, とうきょうから — из Токио). После предложения — '
          '«потому что» (см. грамматику).'),
  ParticleSeed('まで', 'падежная', '«До» (предел)',
      'Граница во времени или пространстве: ごじまで (до пяти), えきまで (до '
          'станции). Часто в паре: 〜から〜まで — «от… до…».'),
  ParticleSeed('や', 'соединительная', '«И» (неполный список, «и т.п.»)',
      'Перечисляет примеры, список открыт: つくえの うえに ほんや ノートが '
          'あります — на столе книги, тетради и прочее. Усиливается через …など.',
      confusableWith: 'と'),
  ParticleSeed('か', 'вопросительная', 'Вопрос — и «или»',
      'В конце предложения — вопрос (いきますか). Между существительными — «или» '
          '(コーヒーか おちゃ — кофе или чай).'),
  ParticleSeed('ね', 'финальная', 'Ищет согласия: «…ведь?, правда?»',
      'В конце фразы приглашает собеседника согласиться или подтвердить общее '
          'знание: いい てんきですね — хорошая погода, правда? Мягкая, '
          'располагающая интонация.',
      confusableWith: 'よ'),
  ParticleSeed('よ', 'финальная', 'Сообщает новое: «между прочим, имей в виду»',
      'В конце фразы подаёт информацию, которой собеседник, по мнению '
          'говорящего, не знал: でんしゃが きましたよ — поезд пришёл (ты не '
          'заметил). Слишком частое よ звучит напористо.',
      confusableWith: 'ね'),
  ParticleSeed('より', 'сравнительная', '«Чем» (в сравнении)',
      'После того, с чем сравнивают и что «уступает»: AよりB — «B больше…, чем '
          'A». Обычно в связке с …のほうが (см. грамматику).'),
];

// ---------------------------------------------------------------------
// Базовая лексика N5
// ---------------------------------------------------------------------
const coreVocabI = <WordSeed>[
  WordSeed('こんにちは', 'こんにちは', ['здравствуйте', 'добрый день'], kanaOnly: true),
  WordSeed('おはようございます', 'おはようございます', ['доброе утро'], kanaOnly: true),
  WordSeed('こんばんは', 'こんばんは', ['добрый вечер'], kanaOnly: true),
  WordSeed('さようなら', 'さようなら', ['до свидания'], kanaOnly: true),
  WordSeed('ありがとうございます', 'ありがとうございます', ['спасибо'], kanaOnly: true),
  WordSeed('すみません', 'すみません', ['извините', 'простите', 'спасибо (за беспокойство)'], kanaOnly: true),
  WordSeed('はい', 'はい', ['да'], kanaOnly: true),
  WordSeed('いいえ', 'いいえ', ['нет'], kanaOnly: true),
  WordSeed('私', 'わたし', ['я']),
  WordSeed('あなた', 'あなた', ['ты', 'вы'], kanaOnly: true),
  WordSeed('人', 'ひと', ['человек']),
  WordSeed('友達', 'ともだち', ['друг']),
  WordSeed('先生', 'せんせい', ['учитель', 'преподаватель']),
  WordSeed('学生', 'がくせい', ['студент', 'учащийся']),
  WordSeed('家族', 'かぞく', ['семья']),
  WordSeed('父', 'ちち', ['(мой) отец']),
  WordSeed('母', 'はは', ['(моя) мать']),
  WordSeed('兄', 'あに', ['(мой) старший брат']),
  WordSeed('姉', 'あね', ['(моя) старшая сестра']),
  WordSeed('一', 'いち', ['один', '1']),
  WordSeed('二', 'に', ['два', '2']),
  WordSeed('三', 'さん', ['три', '3']),
  WordSeed('四', 'よん', ['четыре', '4']),
  WordSeed('五', 'ご', ['пять', '5']),
  WordSeed('六', 'ろく', ['шесть', '6']),
  WordSeed('七', 'なな', ['семь', '7']),
  WordSeed('八', 'はち', ['восемь', '8']),
  WordSeed('九', 'きゅう', ['девять', '9']),
  WordSeed('十', 'じゅう', ['десять', '10']),
  WordSeed('百', 'ひゃく', ['сто', '100']),
  WordSeed('千', 'せん', ['тысяча', '1000']),
  WordSeed('今', 'いま', ['сейчас']),
  WordSeed('今日', 'きょう', ['сегодня']),
  WordSeed('明日', 'あした', ['завтра']),
  WordSeed('昨日', 'きのう', ['вчера']),
  WordSeed('毎日', 'まいにち', ['каждый день']),
  WordSeed('朝', 'あさ', ['утро']),
  WordSeed('昼', 'ひる', ['день', 'полдень']),
  WordSeed('夜', 'よる', ['ночь', 'вечер']),
  WordSeed('時間', 'じかん', ['время', 'час (продолжительность)']),
];

const coreVocabII = <WordSeed>[
  WordSeed('食べる', 'たべる', ['есть', 'кушать']),
  WordSeed('飲む', 'のむ', ['пить']),
  WordSeed('見る', 'みる', ['смотреть', 'видеть']),
  WordSeed('聞く', 'きく', ['слушать', 'спрашивать']),
  WordSeed('話す', 'はなす', ['говорить', 'разговаривать']),
  WordSeed('読む', 'よむ', ['читать']),
  WordSeed('書く', 'かく', ['писать']),
  WordSeed('行く', 'いく', ['идти', 'ехать (туда)']),
  WordSeed('来る', 'くる', ['приходить', 'приезжать']),
  WordSeed('帰る', 'かえる', ['возвращаться (домой)']),
  WordSeed('する', 'する', ['делать'], kanaOnly: true),
  WordSeed('買う', 'かう', ['покупать']),
  WordSeed('会う', 'あう', ['встречаться']),
  WordSeed('待つ', 'まつ', ['ждать']),
  WordSeed('分かる', 'わかる', ['понимать']),
  WordSeed('起きる', 'おきる', ['вставать', 'просыпаться']),
  WordSeed('寝る', 'ねる', ['ложиться спать', 'спать']),
  WordSeed('働く', 'はたらく', ['работать']),
  WordSeed('勉強する', 'べんきょうする', ['учиться', 'заниматься']),
  WordSeed('大きい', 'おおきい', ['большой']),
  WordSeed('小さい', 'ちいさい', ['маленький']),
  WordSeed('高い', 'たかい', ['высокий', 'дорогой']),
  WordSeed('安い', 'やすい', ['дешёвый']),
  WordSeed('新しい', 'あたらしい', ['новый']),
  WordSeed('古い', 'ふるい', ['старый (о вещах)']),
  WordSeed('いい', 'いい', ['хороший'], kanaOnly: true),
  WordSeed('悪い', 'わるい', ['плохой']),
  WordSeed('暑い', 'あつい', ['жаркий']),
  WordSeed('寒い', 'さむい', ['холодный (о погоде)']),
  WordSeed('おいしい', 'おいしい', ['вкусный'], kanaOnly: true),
  WordSeed('楽しい', 'たのしい', ['весёлый', 'приятный']),
  WordSeed('難しい', 'むずかしい', ['трудный', 'сложный']),
  WordSeed('家', 'いえ', ['дом']),
  WordSeed('学校', 'がっこう', ['школа']),
  WordSeed('駅', 'えき', ['станция', 'вокзал']),
  WordSeed('店', 'みせ', ['магазин', 'заведение']),
  WordSeed('病院', 'びょういん', ['больница']),
  WordSeed('図書館', 'としょかん', ['библиотека']),
  WordSeed('水', 'みず', ['вода']),
  WordSeed('お茶', 'おちゃ', ['чай']),
  WordSeed('ご飯', 'ごはん', ['рис', 'еда', 'приём пищи']),
  WordSeed('パン', 'パン', ['хлеб'], kanaOnly: true),
  WordSeed('肉', 'にく', ['мясо']),
  WordSeed('魚', 'さかな', ['рыба']),
  WordSeed('車', 'くるま', ['машина', 'автомобиль']),
  WordSeed('電車', 'でんしゃ', ['электричка', 'поезд']),
  WordSeed('本', 'ほん', ['книга']),
  WordSeed('鞄', 'かばん', ['сумка', 'портфель'], kanaOnly: true),
];

// ---------------------------------------------------------------------
// Аудирование — фразы целиком (озвучиваются системным синтезатором)
// ---------------------------------------------------------------------
const listeningI = <WordSeed>[
  WordSeed('はじめまして。', 'はじめまして。', ['Приятно познакомиться.'], kanaOnly: true),
  WordSeed('お名前は何ですか。', 'おなまえはなんですか。', ['Как вас зовут?'], kanaOnly: true),
  WordSeed('私は田中です。', 'わたしはたなかです。', ['Я Танака.'], kanaOnly: true),
  WordSeed('これはいくらですか。', 'これはいくらですか。', ['Сколько это стоит?'], kanaOnly: true),
  WordSeed('トイレはどこですか。', 'トイレはどこですか。', ['Где туалет?'], kanaOnly: true),
  WordSeed('もう一度お願いします。', 'もういちどおねがいします。', ['Повторите, пожалуйста.'], kanaOnly: true),
  WordSeed('ゆっくり話してください。', 'ゆっくりはなしてください。', ['Говорите медленнее, пожалуйста.'], kanaOnly: true),
  WordSeed('分かりました。', 'わかりました。', ['Понял.', 'Ясно.'], kanaOnly: true),
  WordSeed('分かりません。', 'わかりません。', ['Не понимаю.'], kanaOnly: true),
  WordSeed('今何時ですか。', 'いまなんじですか。', ['Который сейчас час?'], kanaOnly: true),
  WordSeed('お元気ですか。', 'おげんきですか。', ['Как вы себя чувствуете?', 'Как дела?'], kanaOnly: true),
  WordSeed('いただきます。', 'いただきます。', ['Приятного аппетита (перед едой).'], kanaOnly: true),
];

const listeningII = <WordSeed>[
  WordSeed('すみません、駅はどこですか。', 'すみません、えきはどこですか。', ['Извините, где станция?'], kanaOnly: true),
  WordSeed('まっすぐ行ってください。', 'まっすぐいってください。', ['Идите прямо.'], kanaOnly: true),
  WordSeed('この電車は東京へ行きますか。', 'このでんしゃはとうきょうへいきますか。', ['Этот поезд идёт в Токио?'], kanaOnly: true),
  WordSeed('はい、行きます。', 'はい、いきます。', ['Да, идёт.'], kanaOnly: true),
  WordSeed('コーヒーを一つください。', 'コーヒーをひとつください。', ['Один кофе, пожалуйста.'], kanaOnly: true),
  WordSeed('はい、少々お待ちください。', 'はい、しょうしょうおまちください。', ['Да, подождите немного.'], kanaOnly: true),
  WordSeed('明日、映画を見に行きませんか。', 'あした、えいがをみにいきませんか。', ['Не сходим завтра в кино?'], kanaOnly: true),
  WordSeed('いいですね。行きましょう。', 'いいですね。いきましょう。', ['Хорошо. Пойдём.'], kanaOnly: true),
  WordSeed('週末は何をしましたか。', 'しゅうまつはなにをしましたか。', ['Что делали на выходных?'], kanaOnly: true),
  WordSeed('友達と買い物をしました。', 'ともだちとかいものをしました。', ['Ходил по магазинам с другом.'], kanaOnly: true),
  WordSeed('お仕事は何ですか。', 'おしごとはなんですか。', ['Кем вы работаете?'], kanaOnly: true),
  WordSeed('銀行で働いています。', 'ぎんこうではたらいています。', ['Работаю в банке.'], kanaOnly: true),
];
