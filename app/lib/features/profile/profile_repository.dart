import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../domain/streak.dart';

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
      streakDays: currentStreak({
        for (final d in activity)
          if (_hadActivity(d)) d.activityDate,
      }),
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
}
