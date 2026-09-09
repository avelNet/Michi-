import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../profile/profile_repository.dart';

/// Сводка «что ждёт пользователя сейчас» — для баннера-напоминания в
/// оболочке, бейджа на разделе Повторение и системного тоста.
class DueSummary {
  final int dueNow;
  final bool activeToday;
  final int streakDays;

  DueSummary({required this.dueNow, required this.activeToday, required this.streakDays});

  /// Вечер и сегодня ещё не занимались, а серия есть — её жаль потерять.
  bool streakAtRisk(DateTime now) =>
      !activeToday && streakDays > 0 && now.hour >= 17;
}

final dueSummaryProvider = FutureProvider<DueSummary>((ref) async {
  final userId = ref.watch(sessionProvider).value;
  final db = ref.watch(dbProvider);
  if (userId == null) {
    return DueSummary(dueNow: 0, activeToday: true, streakDays: 0);
  }

  final nowIso = DateTime.now().toIso8601String();
  final due = await db
      .customSelect(
        'SELECT COUNT(*) AS n FROM srs_cards WHERE user_id = ? AND due_at IS NOT NULL AND due_at <= ?',
        variables: [Variable<String>(userId), Variable<String>(nowIso)],
      )
      .getSingle();

  final today = DateTime.now().toIso8601String().substring(0, 10);
  final todayRow = await (db.select(db.dailyActivity)
        ..where((t) => t.userId.equals(userId) & t.activityDate.equals(today)))
      .getSingleOrNull();
  final activeToday = todayRow != null &&
      (todayRow.reviewsDone > 0 || todayRow.newItemsLearned > 0 || todayRow.minutesSpent > 0);

  final stats = await ProfileRepository(db).load(userId);

  return DueSummary(
    dueNow: due.data['n'] as int? ?? 0,
    activeToday: activeToday,
    streakDays: stats.streakDays,
  );
});
