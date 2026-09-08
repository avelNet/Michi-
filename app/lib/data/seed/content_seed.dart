import 'package:drift/drift.dart';

import '../database.dart';

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
    Future<int> insertKanji({
      required String char,
      required List<String> meanings,
      required List<String> onYomi,
      required List<String> kunYomi,
      required int strokes,
    }) async {
      final contentId = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'kanji', jlptLevel: const Value('N5')),
          );
      await db.into(db.kanji).insert(
            KanjiCompanion.insert(
              contentItemId: Value(contentId),
              char: char,
              meaningsRu: _jsonArray(meanings),
              onYomi: Value(_jsonArray(onYomi)),
              kunYomi: Value(_jsonArray(kunYomi)),
              strokeCount: Value(strokes),
            ),
          );
      return contentId;
    }

    Future<int> insertWord({
      required String surface,
      required String reading,
      required List<String> meanings,
      required List<int> kanjiContentIds,
    }) async {
      final contentId = await db.into(db.contentItems).insert(
            ContentItemsCompanion.insert(kind: 'word', jlptLevel: const Value('N5')),
          );
      await db.into(db.words).insert(
            WordsCompanion.insert(
              contentItemId: Value(contentId),
              surfaceForm: surface,
              reading: reading,
              meaningsRu: _jsonArray(meanings),
            ),
          );
      for (var i = 0; i < kanjiContentIds.length; i++) {
        await db.into(db.wordKanji).insert(
              WordKanjiCompanion.insert(
                wordContentItemId: contentId,
                kanjiContentItemId: kanjiContentIds[i],
                position: i,
              ),
            );
      }
      return contentId;
    }

    final kanjiShoku = await insertKanji(
      char: '食', meanings: ['еда', 'есть'], onYomi: ['ショク'], kunYomi: ['た.べる'], strokes: 9,
    );
    final kanjiHito = await insertKanji(
      char: '人', meanings: ['человек'], onYomi: ['ジン', 'ニン'], kunYomi: ['ひと'], strokes: 2,
    );
    final kanjiHi = await insertKanji(
      char: '日', meanings: ['день', 'солнце'], onYomi: ['ニチ', 'ジツ'], kunYomi: ['ひ'], strokes: 4,
    );
    final kanjiHon = await insertKanji(
      char: '本', meanings: ['книга', 'основа'], onYomi: ['ホン'], kunYomi: ['もと'], strokes: 5,
    );
    final kanjiGo = await insertKanji(
      char: '語', meanings: ['язык', 'слово'], onYomi: ['ゴ'], kunYomi: ['かた.る'], strokes: 14,
    );

    await insertWord(surface: '食べる', reading: 'たべる', meanings: ['есть, кушать'], kanjiContentIds: [kanjiShoku]);
    await insertWord(surface: '人', reading: 'ひと', meanings: ['человек'], kanjiContentIds: [kanjiHito]);
    await insertWord(surface: '日本', reading: 'にほん', meanings: ['Япония'], kanjiContentIds: [kanjiHi, kanjiHon]);
    await insertWord(
      surface: '日本語', reading: 'にほんご', meanings: ['японский язык'],
      kanjiContentIds: [kanjiHi, kanjiHon, kanjiGo],
    );

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

    final uHiragana = await insertUnit(
      title: 'Хирагана', subtitle: '46 знаков + сочетания', kind: 'kana', jlptLevel: 'N5', sortOrder: 1,
    );
    final uKatakana = await insertUnit(
      title: 'Катакана', subtitle: '46 знаков + заимствования', kind: 'kana', jlptLevel: 'N5', sortOrder: 2,
    );
    final uKanji1 = await insertUnit(
      title: 'Кандзи и слова I', subtitle: 'Первые иероглифы в связке со словами',
      kind: 'kanji_vocab', jlptLevel: 'N5', sortOrder: 3,
    );
    final uParticles1 = await insertUnit(
      title: 'Частицы I', subtitle: 'は・が・を・に', kind: 'particle', jlptLevel: 'N5', sortOrder: 4,
    );
    final uGrammar1 = await insertUnit(
      title: 'Грамматика N5 I', subtitle: 'です/ます, простые предложения',
      kind: 'grammar', jlptLevel: 'N5', sortOrder: 5,
    );
    final uListening1 = await insertUnit(
      title: 'Аудирование I', subtitle: 'Базовые фразы на слух', kind: 'listening', jlptLevel: 'N5', sortOrder: 6,
    );
    final uKanji2 = await insertUnit(
      title: 'Кандзи и слова II', subtitle: 'Составные слова', kind: 'kanji_vocab', jlptLevel: 'N5', sortOrder: 7,
    );
    final uParticles2 = await insertUnit(
      title: 'Частицы II', subtitle: 'で・と・も・から・まで', kind: 'particle', jlptLevel: 'N5', sortOrder: 8,
    );
    final uGrammar2 = await insertUnit(
      title: 'Грамматика N5 II', subtitle: 'て-форма, просьбы, желания',
      kind: 'grammar', jlptLevel: 'N5', sortOrder: 9,
    );
    final uListening2 = await insertUnit(
      title: 'Аудирование II', subtitle: 'Диалоги в естественном темпе',
      kind: 'listening', jlptLevel: 'N5', sortOrder: 10,
    );
    final uMilestone = await insertUnit(
      title: 'Веха N5', subtitle: 'Контрольная проверка уровня', kind: 'milestone', jlptLevel: 'N5', sortOrder: 11,
    );

    final unitChain = [
      uHiragana, uKatakana, uKanji1, uParticles1, uGrammar1,
      uListening1, uKanji2, uParticles2, uGrammar2, uListening2,
    ];
    for (var i = 1; i < unitChain.length; i++) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: unitChain[i], requiresUnitId: unitChain[i - 1]),
          );
    }
    for (final u in unitChain) {
      await db.into(db.unitPrerequisites).insert(
            UnitPrerequisitesCompanion.insert(unitId: uMilestone, requiresUnitId: u),
          );
    }

    Future<void> linkUnitItems(int unitId, Iterable<int> contentIds) async {
      for (final id in contentIds) {
        await db.into(db.unitItems).insert(
              UnitItemsCompanion.insert(unitId: unitId, contentItemId: id),
            );
      }
    }

    await linkUnitItems(uHiragana, hiraganaIds.values);
    await linkUnitItems(uKatakana, katakanaIds.values);
    await linkUnitItems(uKanji1, [kanjiShoku, kanjiHito, kanjiHi, kanjiHon, kanjiGo]);
    await linkUnitItems(uParticles1, [particleWa, particleGa, particleWo, particleNi]);

    // ---- Прогресс демо-пользователя (наглядно повторяет состояние
    // из макета: первые 3 юнита пройдены, 4-й — текущий) -----------------
    Future<void> setProgress(int unitId, String status) {
      return db.into(db.unitProgress).insert(
            UnitProgressCompanion.insert(
              userId: localUserId,
              unitId: unitId,
              status: Value(status),
            ),
          );
    }

    await setProgress(uHiragana, 'completed');
    await setProgress(uKatakana, 'completed');
    await setProgress(uKanji1, 'completed');
    await setProgress(uParticles1, 'in_progress');
    for (final u in [uGrammar1, uListening1, uKanji2, uParticles2, uGrammar2, uListening2, uMilestone]) {
      await setProgress(u, 'locked');
    }
  });
}

String _jsonArray(List<String> items) {
  final escaped = items.map((s) => '"${s.replaceAll('"', '\\"')}"').join(',');
  return '[$escaped]';
}
