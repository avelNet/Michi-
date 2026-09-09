import 'package:drift/drift.dart';

import '../../data/database.dart';

class DayCount {
  final DateTime date;
  final int reviews;
  final int newItems;
  final int minutes;
  DayCount(this.date, this.reviews, this.newItems, this.minutes);

  bool get active => reviews > 0 || newItems > 0 || minutes > 0;
}

class StatsData {
  final int todayReviews;
  final int todayNew;
  final int todayMinutes;
  final int goalMinutes;
  final int streakDays;
  final int longestStreak;
  final int totalReviews;
  final int activeDays;
  final double? accuracy30; // доля good+easy за 30 дней, null — не было повторений
  final Map<String, int> cardsByState;
  final List<DayCount> last14;
  final List<DayCount> last84; // для теплокарты

  StatsData({
    required this.todayReviews,
    required this.todayNew,
    required this.todayMinutes,
    required this.goalMinutes,
    required this.streakDays,
    required this.longestStreak,
    required this.totalReviews,
    required this.activeDays,
    required this.accuracy30,
    required this.cardsByState,
    required this.last14,
    required this.last84,
  });
}

class StatsRepository {
  final AppDatabase db;
  StatsRepository(this.db);

  static String _key(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<StatsData> load(String userId) async {
    final activity = await (db.select(db.dailyActivity)
          ..where((t) => t.userId.equals(userId)))
        .get();
    final byDate = {for (final a in activity) a.activityDate: a};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayRow = byDate[_key(today)];

    List<DayCount> window(int days) => List.generate(days, (i) {
          final d = today.subtract(Duration(days: days - 1 - i));
          final row = byDate[_key(d)];
          return DayCount(
            d,
            row?.reviewsDone ?? 0,
            row?.newItemsLearned ?? 0,
            row?.minutesSpent ?? 0,
          );
        });

    final profile = await (db.select(db.userProfile)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();

    final cards = await (db.select(db.srsCards)..where((t) => t.userId.equals(userId))).get();
    final byState = <String, int>{};
    for (final c in cards) {
      byState[c.state] = (byState[c.state] ?? 0) + 1;
    }

    final totalReviews = await db
        .customSelect('SELECT COUNT(*) AS n FROM review_log WHERE user_id = ?',
            variables: [Variable<String>(userId)])
        .getSingle();

    final cutoff = today.subtract(const Duration(days: 30)).toIso8601String();
    final acc = await db.customSelect(
      "SELECT "
      "SUM(CASE WHEN rating IN ('good','easy') THEN 1 ELSE 0 END) AS good, "
      "COUNT(*) AS total "
      "FROM review_log WHERE user_id = ? AND reviewed_at >= ?",
      variables: [Variable<String>(userId), Variable<String>(cutoff)],
    ).getSingle();
    final accTotal = acc.data['total'] as int? ?? 0;
    final accGood = acc.data['good'] as int? ?? 0;

    final activeKeys = {
      for (final a in activity)
        if (a.reviewsDone > 0 || a.newItemsLearned > 0 || a.minutesSpent > 0) a.activityDate,
    };

    return StatsData(
      todayReviews: todayRow?.reviewsDone ?? 0,
      todayNew: todayRow?.newItemsLearned ?? 0,
      todayMinutes: todayRow?.minutesSpent ?? 0,
      goalMinutes: profile?.dailyMinutesGoal ?? 15,
      streakDays: _currentStreak(activeKeys, today),
      longestStreak: _longestStreak(activeKeys),
      totalReviews: totalReviews.data['n'] as int? ?? 0,
      activeDays: activeKeys.length,
      accuracy30: accTotal == 0 ? null : accGood / accTotal,
      cardsByState: byState,
      last14: window(14),
      last84: window(84),
    );
  }

  static int _currentStreak(Set<String> active, DateTime today) {
    if (active.isEmpty) return 0;
    var cursor = today;
    if (!active.contains(_key(today))) {
      final y = today.subtract(const Duration(days: 1));
      if (!active.contains(_key(y))) return 0;
      cursor = y;
    }
    var n = 0;
    while (active.contains(_key(cursor))) {
      n++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return n;
  }

  static int _longestStreak(Set<String> active) {
    if (active.isEmpty) return 0;
    final dates = active.map(DateTime.parse).toList()..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        run++;
        if (run > best) best = run;
      } else {
        run = 1;
      }
    }
    return best;
  }
}
