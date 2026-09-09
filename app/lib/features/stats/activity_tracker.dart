import 'package:drift/drift.dart';

import '../../data/database.dart';

/// Единая точка учёта ежедневной активности (daily_activity) — на неё
/// опираются серия дней, статистика и напоминания. Все инкременты идут
/// сюда, а не размазаны по экранам.
Future<void> bumpActivity(
  AppDatabase db,
  String userId, {
  int reviews = 0,
  int newItems = 0,
  int minutes = 0,
}) async {
  if (reviews == 0 && newItems == 0 && minutes == 0) return;
  final today = DateTime.now().toIso8601String().substring(0, 10);

  await db.transaction(() async {
    final existing = await (db.select(db.dailyActivity)
          ..where((t) => t.userId.equals(userId) & t.activityDate.equals(today)))
        .getSingleOrNull();

    final profile = await (db.select(db.userProfile)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
    final goal = profile?.dailyMinutesGoal ?? 15;

    if (existing == null) {
      await db.into(db.dailyActivity).insert(DailyActivityCompanion.insert(
            userId: userId,
            activityDate: today,
            reviewsDone: Value(reviews),
            newItemsLearned: Value(newItems),
            minutesSpent: Value(minutes),
            goalMet: Value(minutes >= goal && goal > 0 ? 1 : 0),
          ));
    } else {
      final newMinutes = existing.minutesSpent + minutes;
      await (db.update(db.dailyActivity)
            ..where((t) =>
                t.userId.equals(userId) & t.activityDate.equals(today)))
          .write(DailyActivityCompanion(
        reviewsDone: Value(existing.reviewsDone + reviews),
        newItemsLearned: Value(existing.newItemsLearned + newItems),
        minutesSpent: Value(newMinutes),
        goalMet: Value(newMinutes >= goal && goal > 0 ? 1 : existing.goalMet),
      ));
    }
  });
}
