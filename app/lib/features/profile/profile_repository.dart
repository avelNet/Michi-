import 'package:drift/drift.dart';

import '../../data/database.dart';

class ProfileStats {
  final int streakDays;
  final int totalCards;
  final int learnedCards; // в состоянии review (вышли из заучивания)
  final int dueNow;
  final int reviewsAllTime;
  final int unitsCompleted;
  final int unitsTotal;
  final double n5Pct; // 0..1 по завершённым не-вехальным юнитам N5
  final int activeDays; // всего дней с активностью

  ProfileStats({
    required this.streakDays,
    required this.totalCards,
    required this.learnedCards,
    required this.dueNow,
    required this.reviewsAllTime,
    required this.unitsCompleted,
    required this.unitsTotal,
    required this.n5Pct,
    required this.activeDays,
  });
}

class ProfileRepository {
  final AppDatabase db;
  ProfileRepository(this.db);

  Future<ProfileStats> load(String userId) async {
    final cards = await (db.select(db.srsCards)..where((t) => t.userId.equals(userId))).get();
    final nowIso = DateTime.now().toIso8601String();
    final due = cards.where((c) => (c.dueAt ?? '') != '' && c.dueAt!.compareTo(nowIso) <= 0).length;
    final learned = cards.where((c) => c.state == 'review').length;

    final reviews = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM review_log WHERE user_id = ?',
          variables: [Variable<String>(userId)],
        )
        .getSingle();

    final units = await db.select(db.units).get();
    final progress = await (db.select(db.unitProgress)
          ..where((t) => t.userId.equals(userId) & t.status.equals('completed')))
        .get();
    final completedIds = progress.map((p) => p.unitId).toSet();

    final n5Units = units.where((u) => u.jlptLevel == 'N5' && u.kind != 'milestone').toList();
    final n5Done = n5Units.where((u) => completedIds.contains(u.id)).length;

    final activity = await (db.select(db.dailyActivity)..where((t) => t.userId.equals(userId))).get();

    return ProfileStats(
      streakDays: _streak(activity),
      totalCards: cards.length,
      learnedCards: learned,
      dueNow: due,
      reviewsAllTime: reviews.data['n'] as int? ?? 0,
      unitsCompleted: completedIds.length,
      unitsTotal: units.length,
      n5Pct: n5Units.isEmpty ? 0 : n5Done / n5Units.length,
      activeDays: activity.where(_hadActivity).length,
    );
  }

  static bool _hadActivity(DailyActivityData d) =>
      d.reviewsDone > 0 || d.newItemsLearned > 0 || d.minutesSpent > 0;

  /// Серия дней подряд с активностью, считая назад от сегодня. Если
  /// сегодня ещё не занимались, но вчера — да, серия не прервана и
  /// считается от вчера.
  static int _streak(List<DailyActivityData> activity) {
    final active = {
      for (final d in activity)
        if (_hadActivity(d)) d.activityDate,
    };
    if (active.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    String key(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    var cursor = today;
    if (!active.contains(key(today))) {
      final yesterday = today.subtract(const Duration(days: 1));
      if (!active.contains(key(yesterday))) return 0;
      cursor = yesterday;
    }

    var count = 0;
    while (active.contains(key(cursor))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }
}
