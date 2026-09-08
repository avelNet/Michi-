import 'package:drift/drift.dart';

import '../../data/database.dart';

class RoadmapUnit {
  final int id;
  final String title;
  final String? subtitle;
  final String kind;
  final String? jlptLevel;
  final int sortOrder;
  final String status; // locked | unlocked | in_progress | completed

  RoadmapUnit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.jlptLevel,
    required this.sortOrder,
    required this.status,
  });
}

/// Запросы для экрана «Дорожная карта» — тонкий слой поверх Drift,
/// чтобы UI-виджет не знал про join'ы и таблицы напрямую.
class RoadmapRepository {
  final AppDatabase db;
  RoadmapRepository(this.db);

  Future<List<RoadmapUnit>> loadUnits(String userId) async {
    final query = db.select(db.units).join([
      leftOuterJoin(
        db.unitProgress,
        db.unitProgress.unitId.equalsExp(db.units.id) &
            db.unitProgress.userId.equals(userId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(db.units.sortOrder)]);

    final rows = await query.get();
    return rows.map((row) {
      final unit = row.readTable(db.units);
      final progress = row.readTableOrNull(db.unitProgress);
      return RoadmapUnit(
        id: unit.id,
        title: unit.title,
        subtitle: unit.subtitle,
        kind: unit.kind,
        jlptLevel: unit.jlptLevel,
        sortOrder: unit.sortOrder,
        status: progress?.status ?? 'locked',
      );
    }).toList();
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
