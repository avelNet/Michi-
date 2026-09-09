import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../domain/japanese/dictionary_text.dart';
import '../../domain/japanese/romaji.dart';
import '../../domain/streak.dart';

class RoadmapUnit {
  final int id;
  final String title;
  final String? subtitle;
  final String? description;
  final String kind;
  final String? jlptLevel;
  final int sortOrder;
  final String status; // locked | unlocked | in_progress | completed

  RoadmapUnit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.kind,
    required this.jlptLevel,
    required this.sortOrder,
    required this.status,
  });
}

/// Один элемент урока: лицевая/тыльная сторона карточки + опциональная
/// развёрнутая теория (мнемоника кандзи, разбор частицы/грамматики).
class LessonItem {
  final int contentItemId;
  final String front;
  final String back;
  final String? theory;

  LessonItem({required this.contentItemId, required this.front, required this.back, required this.theory});
}

/// Запросы для экрана «Дорожная карта» — тонкий слой поверх Drift,
/// чтобы UI-виджет не знал про join'ы и таблицы напрямую.
class RoadmapRepository {
  final AppDatabase db;
  RoadmapRepository(this.db);

  /// Статус юнита — не то, что заранее записано в базу «на всякий
  /// случай», а вычисляется на лету: если реально начат/пройден — берём
  /// это; иначе, если все предпосылки (`unit_prerequisites`) выполнены —
  /// он «unlocked», иначе «locked». Так нет риска рассинхронизации
  /// между сохранённым статусом и фактическим прогрессом.
  Future<List<RoadmapUnit>> loadUnits(String userId) async {
    final units = await (db.select(db.units)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final progressRows = await (db.select(db.unitProgress)..where((t) => t.userId.equals(userId))).get();
    final progressByUnit = {for (final p in progressRows) p.unitId: p.status};

    final prereqRows = await db.select(db.unitPrerequisites).get();
    final prereqsByUnit = <int, List<int>>{};
    for (final r in prereqRows) {
      prereqsByUnit.putIfAbsent(r.unitId, () => []).add(r.requiresUnitId);
    }

    return units.map((unit) {
      final explicit = progressByUnit[unit.id];
      String status;
      if (explicit == 'completed' || explicit == 'in_progress') {
        status = explicit!;
      } else {
        final prereqs = prereqsByUnit[unit.id] ?? const [];
        final allDone = prereqs.every((id) => progressByUnit[id] == 'completed');
        status = allDone ? 'unlocked' : 'locked';
      }
      return RoadmapUnit(
        id: unit.id,
        title: unit.title,
        subtitle: unit.subtitle,
        description: unit.description,
        kind: unit.kind,
        jlptLevel: unit.jlptLevel,
        sortOrder: unit.sortOrder,
        status: status,
      );
    }).toList();
  }

  Future<void> markUnitCompleted(String userId, int unitId) async {
    await db.into(db.unitProgress).insertOnConflictUpdate(
          UnitProgressCompanion.insert(
            userId: userId,
            unitId: unitId,
            status: const Value('completed'),
            completedAt: Value(DateTime.now().toIso8601String()),
          ),
        );
  }

  Future<void> markUnitStarted(String userId, int unitId) async {
    final existing = await (db.select(db.unitProgress)
          ..where((t) => t.userId.equals(userId) & t.unitId.equals(unitId)))
        .getSingleOrNull();
    if (existing != null) return;
    await db.into(db.unitProgress).insert(
          UnitProgressCompanion.insert(
            userId: userId,
            unitId: unitId,
            status: const Value('in_progress'),
            startedAt: Value(DateTime.now().toIso8601String()),
          ),
        );
  }

  /// Суточный лимит СПЕЦИФИЧНО на кандзи (не на остальной контент):
  /// один юнит кандзи в день — не потому что "неудобно", а потому что
  /// реально невозможно осилить больше за раз. `excludingUnitId`
  /// позволяет не блокировать продолжение уже начатого сегодня же юнита.
  Future<bool> kanjiDailyLimitReached(String userId, {required int excludingUnitId}) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final query = db.select(db.unitProgress).join([
      innerJoin(db.units, db.units.id.equalsExp(db.unitProgress.unitId)),
    ])
      ..where(
        db.unitProgress.userId.equals(userId) &
            db.units.kind.equals('kanji_vocab') &
            db.unitProgress.status.equals('completed') &
            db.unitProgress.unitId.equals(excludingUnitId).not(),
      );
    final rows = await query.get();
    return rows.any((row) {
      final completedAt = row.readTable(db.unitProgress).completedAt;
      return completedAt != null && completedAt.startsWith(today);
    });
  }

  /// Контент юнита (для экрана урока): элементы + их теория/подписи,
  /// без знания вызывающей стороной устройства конкретных таблиц.
  Future<List<LessonItem>> loadUnitLessonItems(int unitId) async {
    final links = await (db.select(db.unitItems)..where((t) => t.unitId.equals(unitId))).get();
    final items = <LessonItem>[];
    for (final link in links) {
      final ci = await (db.select(db.contentItems)..where((t) => t.id.equals(link.contentItemId))).getSingle();
      switch (ci.kind) {
        case 'kana':
          final k = await (db.select(db.kana)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          items.add(LessonItem(contentItemId: ci.id, front: k.char, back: k.romaji, theory: await _kanaExamples(ci.id)));
        case 'kanji':
          final k = await (db.select(db.kanji)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          final onRu = k.onYomi != null ? _readingsWithRomaji(k.onYomi!) : null;
          final kunRu = k.kunYomi != null ? _readingsWithRomaji(k.kunYomi!) : null;
          final readingLines = [
            if (onRu != null && onRu.isNotEmpty) 'он: $onRu',
            if (kunRu != null && kunRu.isNotEmpty) 'кун: $kunRu',
          ].join('\n');
          items.add(LessonItem(
            contentItemId: ci.id,
            front: k.char,
            back: '${joinCleanMeanings(k.meaningsRu)}${readingLines.isEmpty ? '' : '\n$readingLines'}',
            theory: k.mnemonic,
          ));
        case 'word':
          final w = await (db.select(db.words)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          final decomposition = await _kanjiDecomposition(ci.id);
          items.add(LessonItem(
            contentItemId: ci.id,
            front: w.surfaceForm,
            back: '${w.reading} (${kanaToRomaji(w.reading)})\n${joinCleanMeanings(w.meaningsRu)}',
            theory: decomposition,
          ));
        case 'particle':
          final p = await (db.select(db.particles)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          items.add(LessonItem(contentItemId: ci.id, front: p.particle, back: p.shortDescription ?? '', theory: p.longTheory));
        case 'grammar_point':
          final g = await (db.select(db.grammarPoints)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          items.add(LessonItem(contentItemId: ci.id, front: g.title, back: g.pattern, theory: g.explanation));
      }
    }
    return items;
  }

  /// Разбивка слова на составляющие кандзи с их собственными значениями
  /// — например для 国民 показать не только «народ, нация» целиком, а
  /// и то, что 国 значит «страна», а 民 значит «люди/народ» по отдельности.
  /// Так кандзи не теряется как отдельный смысл внутри сочетания, даже
  /// если само сочетание введено раньше своих частей.
  String _readingsWithRomaji(String jsonArray) {
    return parseMeaningsJson(jsonArray).map((r) => '$r (${kanaToRomaji(r)})').join(', ');
  }

  Future<String?> _kanjiDecomposition(int wordContentItemId) async {
    final query = db.select(db.wordKanji).join([
      innerJoin(db.kanji, db.kanji.contentItemId.equalsExp(db.wordKanji.kanjiContentItemId)),
    ])
      ..where(db.wordKanji.wordContentItemId.equals(wordContentItemId));
    final rows = await query.get();
    if (rows.length < 2) return null; // одиночный кандзи — уже показан на своей карточке

    final parts = rows.map((row) {
      final k = row.readTable(db.kanji);
      return '${k.char} (${joinCleanMeanings(k.meaningsRu)})';
    });
    return parts.join(' + ');
  }

  /// Слова-примеры, где встречается конкретный знак каны — чтобы символ
  /// был виден не абстрактно, а в реальном слове. С чтением и ромадзи —
  /// слово может содержать кану, которую пользователь ещё не проходил.
  Future<String?> _kanaExamples(int kanaContentItemId) async {
    final query = db.select(db.wordKana).join([
      innerJoin(db.words, db.words.contentItemId.equalsExp(db.wordKana.wordContentItemId)),
    ])
      ..where(db.wordKana.kanaContentItemId.equals(kanaContentItemId))
      ..limit(2);
    final rows = await query.get();
    if (rows.isEmpty) return null;

    final lines = rows.map((row) {
      final w = row.readTable(db.words);
      return '${w.surfaceForm} (${kanaToRomaji(w.reading)}) — ${primaryCleanMeaning(w.meaningsRu)}';
    });
    return lines.join('\n');
  }

  /// Какие из этих элементов уже есть в SRS у пользователя — то есть уже
  /// были реально показаны в практике раньше (в этой или предыдущей,
  /// прерванной на середине, сессии урока). Нужно, чтобы при повторном
  /// открытии юнита не показывать заново то, что уже видели.
  Future<Set<int>> loadEnrolledContentIds(String userId, List<int> contentItemIds) async {
    if (contentItemIds.isEmpty) return {};
    final rows = await (db.select(db.srsCards)
          ..where((t) => t.userId.equals(userId) & t.contentItemId.isIn(contentItemIds)))
        .get();
    return rows.map((r) => r.contentItemId).toSet();
  }

  Future<List<String>> loadPrerequisiteTitles(int unitId) async {
    final query = db.select(db.unitPrerequisites).join([
      innerJoin(
        db.units,
        db.units.id.equalsExp(db.unitPrerequisites.requiresUnitId),
      ),
    ])
      ..where(db.unitPrerequisites.unitId.equals(unitId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(db.units).title).toList();
  }

  /// Сколько карточек SRS уже просрочено/готово к повторению сейчас.
  /// `kanjiOnly`: null — все; true — только трек кандзи; false — всё,
  /// кроме кандзи (та же граница, что и в переключателе на Карте).
  Future<int> countDueReviews(String userId, {bool? kanjiOnly}) async {
    final nowIso = DateTime.now().toIso8601String();
    var rows = await (db.select(db.srsCards)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.dueAt.isSmallerOrEqualValue(nowIso),
          ))
        .get();

    if (kanjiOnly != null) {
      final query = db.select(db.unitItems).join([
        innerJoin(db.units, db.units.id.equalsExp(db.unitItems.unitId)),
      ])
        ..where(db.units.kind.equals('kanji_vocab'));
      final kanjiRows = await query.get();
      final kanjiIds = kanjiRows.map((r) => r.readTable(db.unitItems).contentItemId).toSet();
      rows = rows.where((r) => kanjiIds.contains(r.contentItemId) == kanjiOnly).toList();
    }

    return rows.length;
  }

  /// Серия дней подряд с активностью (повторение / новый элемент /
  /// минуты). Если сегодня ещё не занимались, но вчера — да, серия не
  /// прервана и считается от вчера.
  Future<int> currentStreakDays(String userId) async {
    final rows = await (db.select(db.dailyActivity)
          ..where((t) => t.userId.equals(userId)))
        .get();
    return currentStreak({
      for (final d in rows)
        if (d.reviewsDone > 0 || d.newItemsLearned > 0 || d.minutesSpent > 0)
          d.activityDate,
    });
  }

  /// Доля пройденных не-вехальных юнитов заданного уровня JLPT (0..1).
  Future<double> jlptProgressPct(String userId, String level) async {
    final levelUnits = await (db.select(db.units)
          ..where((t) => t.jlptLevel.equals(level) & t.kind.equals('milestone').not()))
        .get();
    if (levelUnits.isEmpty) return 0;
    final idsAtLevel = levelUnits.map((u) => u.id).toSet();

    final completed = await (db.select(db.unitProgress)
          ..where((t) => t.userId.equals(userId) & t.status.equals('completed')))
        .get();
    final completedAtLevel = completed.where((p) => idsAtLevel.contains(p.unitId)).length;

    return completedAtLevel / levelUnits.length;
  }
}
