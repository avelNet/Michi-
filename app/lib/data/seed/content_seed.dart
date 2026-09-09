import 'package:drift/drift.dart';

import '../database.dart';
import 'kanji_import.dart';

/// Единственный локальный профиль на устройстве до появления
/// многопользовательских аккаунтов/синка (см. docs/database-design.md).
const localUserId = 'local';

/// Годзюон: (ромадзи, ряд, хирагана, катакана) — оба алфавита идут
/// параллельно, т.к. это ровно одни и те же позиции таблицы.
const _gojuon = [
  ['a', 'a', 'あ', 'ア'], ['i', 'a', 'い', 'イ'], ['u', 'a', 'う', 'ウ'], ['e', 'a', 'え', 'エ'], ['o', 'a', 'お', 'オ'],
  ['ka', 'ka', 'か', 'カ'], ['ki', 'ka', 'き', 'キ'], ['ku', 'ka', 'く', 'ク'], ['ke', 'ka', 'け', 'ケ'], ['ko', 'ka', 'こ', 'コ'],
  ['sa', 'sa', 'さ', 'サ'], ['shi', 'sa', 'し', 'シ'], ['su', 'sa', 'す', 'ス'], ['se', 'sa', 'せ', 'セ'], ['so', 'sa', 'そ', 'ソ'],
  ['ta', 'ta', 'た', 'タ'], ['chi', 'ta', 'ち', 'チ'], ['tsu', 'ta', 'つ', 'ツ'], ['te', 'ta', 'て', 'テ'], ['to', 'ta', 'と', 'ト'],
  ['na', 'na', 'な', 'ナ'], ['ni', 'na', 'に', 'ニ'], ['nu', 'na', 'ぬ', 'ヌ'], ['ne', 'na', 'ね', 'ネ'], ['no', 'na', 'の', 'ノ'],
  ['ha', 'ha', 'は', 'ハ'], ['hi', 'ha', 'ひ', 'ヒ'], ['fu', 'ha', 'ふ', 'フ'], ['he', 'ha', 'へ', 'ヘ'], ['ho', 'ha', 'ほ', 'ホ'],
  ['ma', 'ma', 'ま', 'マ'], ['mi', 'ma', 'み', 'ミ'], ['mu', 'ma', 'む', 'ム'], ['me', 'ma', 'め', 'メ'], ['mo', 'ma', 'も', 'モ'],
  ['ya', 'ya', 'や', 'ヤ'], ['yu', 'ya', 'ゆ', 'ユ'], ['yo', 'ya', 'よ', 'ヨ'],
  ['ra', 'ra', 'ら', 'ラ'], ['ri', 'ra', 'り', 'リ'], ['ru', 'ra', 'る', 'ル'], ['re', 'ra', 'れ', 'レ'], ['ro', 'ra', 'ろ', 'ロ'],
  ['wa', 'wa', 'わ', 'ワ'], ['wo', 'wa', 'を', 'ヲ'],
  ['n', 'n', 'ん', 'ン'],
];

/// Наполняет базу минимальным реальным контентом, если она ещё пуста:
/// вся хирагана и катакана, 5 кандзи в связке со словами (в т.ч. одно
/// трёхкандзийное дзюкуго 日本語), 4 базовые частицы, и 11 юнитов
/// дорожной карты ровно в том составе, что был в дизайн-макете —
/// теперь как настоящие строки БД, а не захардкоженный JS.
Future<void> seedContentIfEmpty(AppDatabase db) async {
  final alreadySeeded = await db.select(db.contentItems).get();
  if (alreadySeeded.isNotEmpty) return;

  await db.transaction(() async {
    await db.into(db.users).insert(
          UsersCompanion.insert(id: localUserId),
          mode: InsertMode.insertOrIgnore,
        );
    await db.into(db.userProfile).insert(
          UserProfileCompanion.insert(userId: localUserId),
          mode: InsertMode.insertOrIgnore,
        );

    // ---- Типы упражнений --------------------------------------------
    // MVP: один универсальный тип «переверни карточку и оцени себя» —
    // подходит для любого вида контента (кана/кандзи/слово/частица).
    // Остальные типы (аудирование, письмо и т.д.) добавляются сюда же
    // по мере реализации соответствующих упражнений, без миграции схемы.
    await db.into(db.exerciseTypes).insert(
          ExerciseTypesCompanion.insert(
            code: 'flip_recall',
            pillar: 'reading',
            labelRu: 'Вспомнить и перевернуть',
          ),
          mode: InsertMode.insertOrIgnore,
        );

    // ---- Кана ------------------------------------------------------
    var sortOrder = 0;
    final hiraganaIds = <String, int>{};
    final katakanaIds = <String, int>{};
    for (final row in _gojuon) {
      final romaji = row[0];
      final gojuonRow = row[1];
      final hira = row[2];
      final kata = row[3];
      sortOrder++;

      final hiraContentId = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'kana'),
          );
      await db.into(db.kana).insert(
            KanaCompanion.insert(
              contentItemId: Value(hiraContentId),
              script: 'hiragana',
              char: hira,
              romaji: romaji,
              gojuonRow: Value(gojuonRow),
              sortOrder: Value(sortOrder),
            ),
          );
      hiraganaIds[romaji] = hiraContentId;

      final kataContentId = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'kana'),
          );
      await db.into(db.kana).insert(
            KanaCompanion.insert(
              contentItemId: Value(kataContentId),
              script: 'katakana',
              char: kata,
              romaji: romaji,
              gojuonRow: Value(gojuonRow),
              sortOrder: Value(sortOrder),
            ),
          );
      katakanaIds[romaji] = kataContentId;
    }

    // ---- Кандзи + слова (в связке, не по отдельности) ---------------
    // Реальные данные, не выдуманные: список кандзи и частотность —
    // AnchorI/jlpt-kanji-dictionary (MIT), он/кун-чтения — kanjiapi.dev
    // (KANJIDIC2), слова-сочетания с русским переводом — тот же
    // jlpt-kanji-dictionary (JMdict-based). Импортируются ВСЕ уровни
    // (~2100 кандзи) сразу — не только N5, чтобы остальное было готово
    // для будущих юнитов, не только для того, что уже на Карте.
    final kanjiImport = await importKanjiDataset(db);
    final n5Kanji = List<ImportedKanji>.from(kanjiImport.byLevel['N5'] ?? const []);

    // ---- Частицы ------------------------------------------------------
    Future<int> insertParticle({
      required String particle,
      required String category,
      required String shortDescription,
      required String longTheory,
    }) async {
      final contentId = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'particle', jlptLevel: const Value('N5')),
          );
      await db.into(db.particles).insert(
            ParticlesCompanion.insert(
              contentItemId: Value(contentId),
              particle: particle,
              category: Value(category),
              shortDescription: Value(shortDescription),
              longTheory: Value(longTheory),
            ),
          );
      return contentId;
    }

    final particleWa = await insertParticle(
      particle: 'は', category: 'тематическая',
      shortDescription: 'Обозначает тему предложения',
      longTheory: 'は (произносится «wa») отмечает тему высказывания — то, о чём '
          'идёт речь. Не путать с подлежащим: тема может быть шире.',
    );
    final particleGa = await insertParticle(
      particle: 'が', category: 'падежная',
      shortDescription: 'Обозначает подлежащее',
      longTheory: 'が отмечает грамматическое подлежащее — того, кто выполняет '
          'действие или обладает свойством. Часто противопоставляется は.',
    );
    final particleWo = await insertParticle(
      particle: 'を', category: 'падежная',
      shortDescription: 'Обозначает прямое дополнение',
      longTheory: 'を отмечает прямой объект действия — то, над чем действие '
          'совершается.',
    );
    final particleNi = await insertParticle(
      particle: 'に', category: 'падежная',
      shortDescription: 'Направление, время, местонахождение',
      longTheory: 'に указывает направление движения, момент времени или место '
          'нахождения — один из самых многозначных показателей.',
    );

    // ---- Юниты дорожной карты ------------------------------------------
    Future<int> insertUnit({
      required String title,
      String? subtitle,
      required String kind,
      String? jlptLevel,
      required int sortOrder,
      String? description,
    }) {
      return db.into(db.units).insert(
            UnitsCompanion.insert(
              title: title,
              subtitle: Value(subtitle),
              kind: kind,
              jlptLevel: Value(jlptLevel),
              sortOrder: sortOrder,
              description: Value(description),
            ),
          );
    }

    const strokeOrderRules =
        '\n\nПорядок черт подчиняется общим правилам (одинаковым для каны и '
        'кандзи):\n'
        '• сверху вниз;\n'
        '• слева направо;\n'
        '• горизонтальная черта обычно пишется раньше пересекающей её '
        'вертикальной;\n'
        '• при симметричных знаках сначала центр, потом левая часть, потом '
        'правая;\n'
        '• черта, охватывающая знак снаружи (рамка), пишется раньше '
        'внутреннего содержимого, а замыкается — после него;\n'
        '• сквозная черта, проходящая через весь знак, обычно пишется последней.\n'
        'Точный порядок для каждого конкретного знака появится здесь позже '
        '(по мере проверки данных) — сами правила уже можно применять.';

    final uHiragana = await insertUnit(
      title: 'Хирагана', subtitle: '46 знаков + сочетания', kind: 'kana', jlptLevel: 'N5', sortOrder: 1,
      description: 'Хирагана — основная слоговая азбука японского языка, 46 базовых '
          'знаков. Каждый знак читается ровно одним слогом (морой) и не меняет '
          'произношения в зависимости от положения в слове — в отличие от букв '
          'русского или английского алфавита. С хираганы пишутся окончания слов, '
          'частицы и любые слова, для которых нет или не используется кандзи.'
          '$strokeOrderRules',
    );
    final uKatakana = await insertUnit(
      title: 'Катакана', subtitle: '46 знаков + заимствования', kind: 'kana', jlptLevel: 'N5', sortOrder: 2,
      description: 'Катакана — вторая азбука, ровно те же 46 звуков, что и в '
          'хирагане, но другими знаками. Используется для заимствованных слов '
          '(コーヒー — «кофе»), иностранных имён, названий животных и растений, '
          'а также для эмоционального выделения слова — как в русском капслок.'
          '$strokeOrderRules',
    );
    Future<void> linkUnitItems(int unitId, Iterable<int> contentIds) async {
      for (final id in contentIds) {
        await db.into(db.unitItems).insert(
              UnitItemsCompanion.insert(unitId: unitId, contentItemId: id),
              mode: InsertMode.insertOrIgnore,
            );
      }
    }

    // Реальных N5-кандзи 80 (не выдуманное "100+" — ровно то, что даёт
    // источник) — одним юнитом было бы слишком много карточек за раз,
    // поэтому дробим на несколько по ~20. Исходный датасет уже упорядочен
    // по частотности использования, порядок сохраняется как есть.
    const chunkSize = 20;
    final kanjiUnitIds = <int>[];
    for (var start = 0; start < n5Kanji.length; start += chunkSize) {
      final chunk = n5Kanji.sublist(start, (start + chunkSize).clamp(0, n5Kanji.length));
      final chunkIndex = kanjiUnitIds.length + 1;
      final roman = ['I', 'II', 'III', 'IV', 'V', 'VI'][kanjiUnitIds.length];
      final unitId = await insertUnit(
        title: 'Кандзи и слова $roman',
        subtitle: '${chunk.length} иероглифов в связке со словами',
        kind: 'kanji_vocab', jlptLevel: 'N5', sortOrder: 3 + kanjiUnitIds.length,
        description: chunkIndex == 1
            ? 'Кандзи не учат по одному — каждый иероглиф сразу привязан к '
                'чтению каной и к реальным словам, где он встречается. Например 日 '
                '(«день/солнце») и 本 («книга/основа») сами по себе — просто иероглифы, '
                'а вместе — 日本 («Япония»). Это и есть принцип «кандзи в связке», а не '
                'в одиночку — так учится каждый следующий иероглиф.'
            : 'Ещё ${chunk.length} иероглифов N5, тоже сразу со словами, где они '
                'встречаются.',
      );
      final itemIds = <int>[];
      for (final k in chunk) {
        itemIds.add(k.contentItemId);
        itemIds.addAll(k.wordContentItemIds);
      }
      await linkUnitItems(unitId, itemIds);
      kanjiUnitIds.add(unitId);
    }

    final uParticles1 = await insertUnit(
      title: 'Частицы I', subtitle: 'は・が・を・に', kind: 'particle', jlptLevel: 'N5',
      sortOrder: 3 + kanjiUnitIds.length + 1,
      description: 'Частицы — служебные слова, которые показывают роль каждого '
          'слова в предложении: кто действует, над чем действие совершается, '
          'куда направлено. Без них японское предложение не разобрать на части. '
          'Здесь — четыре самые частотные: は, が, を, に.',
    );
    final uGrammar1 = await insertUnit(
      title: 'Грамматика N5 I', subtitle: 'です/ます, простые предложения',
      kind: 'grammar', jlptLevel: 'N5', sortOrder: 3 + kanjiUnitIds.length + 2,
    );
    final uListening1 = await insertUnit(
      title: 'Аудирование I', subtitle: 'Базовые фразы на слух', kind: 'listening', jlptLevel: 'N5',
      sortOrder: 3 + kanjiUnitIds.length + 3,
    );
    final uParticles2 = await insertUnit(
      title: 'Частицы II', subtitle: 'で・と・も・から・まで', kind: 'particle', jlptLevel: 'N5',
      sortOrder: 3 + kanjiUnitIds.length + 4,
    );
    final uGrammar2 = await insertUnit(
      title: 'Грамматика N5 II', subtitle: 'て-форма, просьбы, желания',
      kind: 'grammar', jlptLevel: 'N5', sortOrder: 3 + kanjiUnitIds.length + 5,
    );
    final uListening2 = await insertUnit(
      title: 'Аудирование II', subtitle: 'Диалоги в естественном темпе',
      kind: 'listening', jlptLevel: 'N5', sortOrder: 3 + kanjiUnitIds.length + 6,
    );
    final uMilestone = await insertUnit(
      title: 'Веха N5', subtitle: 'Контрольная проверка уровня', kind: 'milestone', jlptLevel: 'N5',
      sortOrder: 3 + kanjiUnitIds.length + 7,
    );

    // Кана — строго последовательно, это общий шлюз перед всем остальным.
    await db.into(db.unitPrerequisites).insert(
          UnitPrerequisitesCompanion.insert(unitId: uKatakana, requiresUnitId: uHiragana),
        );

    // Дальше — ДВА параллельных трека, не блокирующих друг друга: кандзи
    // и основной (частицы/грамматика/аудирование). Оба открываются сразу
    // после каны, внутри каждого — последовательно, сходятся только на
    // вехе. Можно в любой день выбрать, чем заниматься.
    final mainChain = [uParticles1, uGrammar1, uListening1, uParticles2, uGrammar2, uListening2];

    if (kanjiUnitIds.isNotEmpty) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: kanjiUnitIds.first, requiresUnitId: uKatakana),
          );
    }
    await db.into(db.unitPrerequisites).insert(
          UnitPrerequisitesCompanion.insert(unitId: mainChain.first, requiresUnitId: uKatakana),
        );

    for (var i = 1; i < kanjiUnitIds.length; i++) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: kanjiUnitIds[i], requiresUnitId: kanjiUnitIds[i - 1]),
          );
    }
    for (var i = 1; i < mainChain.length; i++) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: mainChain[i], requiresUnitId: mainChain[i - 1]),
          );
    }

    // Веха требует хвост обоих треков — а значит транзитивно весь путь
    // до неё в каждом из них (внутренние зависимости уже это гарантируют).
    for (final tail in [if (kanjiUnitIds.isNotEmpty) kanjiUnitIds.last, mainChain.last]) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: uMilestone, requiresUnitId: tail),
          );
    }

    await linkUnitItems(uHiragana, hiraganaIds.values);
    await linkUnitItems(uKatakana, katakanaIds.values);
    await linkUnitItems(uParticles1, [particleWa, particleGa, particleWo, particleNi]);

    // Прогресс не сеется вообще — никакого фейкового «уже пройдено».
    // Статус каждого юнита вычисляется на лету из unit_prerequisites
    // (см. RoadmapRepository.loadUnits): без прогресса юнит без
    // предпосылок (Хирагана) сразу «unlocked», остальные — «locked».
    // Реальный прогресс появляется только когда юзер проходит урок.
  });
}
