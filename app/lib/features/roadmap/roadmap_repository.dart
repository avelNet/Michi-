import 'package:drift/drift.dart';

import '../../data/database.dart';

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
          items.add(LessonItem(contentItemId: ci.id, front: k.char, back: k.romaji, theory: null));
        case 'kanji':
          final k = await (db.select(db.kanji)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          items.add(LessonItem(contentItemId: ci.id, front: k.char, back: k.meaningsRu, theory: k.mnemonic));
        case 'word':
          final w = await (db.select(db.words)..where((t) => t.contentItemId.equals(ci.id))).getSingle();
          items.add(LessonItem(contentItemId: ci.id, front: w.surfaceForm, back: '${w.reading} — ${w.meaningsRu}', theory: null));
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
  /// Пока карточек в базе нет (Повторение ещё не реализовано) — честно 0.
  Future<int> countDueReviews(String userId) async {
    final nowIso = DateTime.now().toIso8601String();
    final rows = await (db.select(db.srsCards)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.dueAt.isSmallerOrEqualValue(nowIso),
          ))
        .get();
    return rows.length;
  }

  /// Серия дней подряд — пока не реализована (нет ещё ни одной
  /// сессии повторения), честно возвращаем 0 вместо выдуманного числа.
  Future<int> currentStreakDays(String userId) async {
    return 0;
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
