import 'package:drift/drift.dart';

import '../../data/database.dart';

/// Пишет поля user_profile — общий слой для мастера онбординга и экрана
/// настроек (они меняют одни и те же строки, просто в разное время).
class SettingsRepository {
  final AppDatabase db;
  SettingsRepository(this.db);

  Future<UserProfileData?> load(String userId) {
    return (db.select(db.userProfile)..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> _patch(String userId, UserProfileCompanion patch) async {
    final withStamp = patch.copyWith(
      updatedAt: Value(DateTime.now().toIso8601String()),
    );
    final changed = await (db.update(db.userProfile)
          ..where((t) => t.userId.equals(userId)))
        .write(withStamp);
    if (changed == 0) {
      await db.into(db.userProfile).insert(
            UserProfileCompanion.insert(userId: userId).copyWith(
              weightListening: withStamp.weightListening,
              weightSpeaking: withStamp.weightSpeaking,
              weightReading: withStamp.weightReading,
              weightWriting: withStamp.weightWriting,
              dailyMinutesGoal: withStamp.dailyMinutesGoal,
              comprehensionGoalPct: withStamp.comprehensionGoalPct,
              targetJlptLevel: withStamp.targetJlptLevel,
              placementLevel: withStamp.placementLevel,
              themeMode: withStamp.themeMode,
              remindersEnabled: withStamp.remindersEnabled,
              reminderHour: withStamp.reminderHour,
              reminderMinute: withStamp.reminderMinute,
              notifyDueReviews: withStamp.notifyDueReviews,
              notifyStreakRisk: withStamp.notifyStreakRisk,
              notifyDailyGoal: withStamp.notifyDailyGoal,
              kanjiDailyLimit: withStamp.kanjiDailyLimit,
              romajiHints: withStamp.romajiHints,
            ),
          );
    }
  }

  Future<void> saveOnboarding(
    String userId, {
    required int weightListening,
    required int weightSpeaking,
    required int weightReading,
    required int weightWriting,
    required int dailyMinutesGoal,
    required String targetJlptLevel,
    required String placementLevel,
    int? comprehensionGoalPct,
  }) {
    return _patch(
      userId,
      UserProfileCompanion(
        weightListening: Value(weightListening),
        weightSpeaking: Value(weightSpeaking),
        weightReading: Value(weightReading),
        weightWriting: Value(weightWriting),
        dailyMinutesGoal: Value(dailyMinutesGoal),
        targetJlptLevel: Value(targetJlptLevel),
        placementLevel: Value(placementLevel),
        comprehensionGoalPct: Value(comprehensionGoalPct),
      ),
    );
  }

  Future<void> setThemeMode(String userId, String mode) =>
      _patch(userId, UserProfileCompanion(themeMode: Value(mode)));

  Future<void> setDailyGoal(String userId, int minutes) =>
      _patch(userId, UserProfileCompanion(dailyMinutesGoal: Value(minutes)));

  Future<void> setTargetJlpt(String userId, String level) =>
      _patch(userId, UserProfileCompanion(targetJlptLevel: Value(level)));

  Future<void> setWeights(
    String userId, {
    required int listening,
    required int speaking,
    required int reading,
    required int writing,
  }) =>
      _patch(
        userId,
        UserProfileCompanion(
          weightListening: Value(listening),
          weightSpeaking: Value(speaking),
          weightReading: Value(reading),
          weightWriting: Value(writing),
        ),
      );

  Future<void> setReminder(
    String userId, {
    required bool enabled,
    required int hour,
    required int minute,
  }) =>
      _patch(
        userId,
        UserProfileCompanion(
          remindersEnabled: Value(enabled ? 1 : 0),
          reminderHour: Value(hour),
          reminderMinute: Value(minute),
        ),
      );

  Future<void> setNotifyFlags(
    String userId, {
    bool? dueReviews,
    bool? streakRisk,
    bool? dailyGoal,
  }) =>
      _patch(
        userId,
        UserProfileCompanion(
          notifyDueReviews:
              dueReviews == null ? const Value.absent() : Value(dueReviews ? 1 : 0),
          notifyStreakRisk:
              streakRisk == null ? const Value.absent() : Value(streakRisk ? 1 : 0),
          notifyDailyGoal:
              dailyGoal == null ? const Value.absent() : Value(dailyGoal ? 1 : 0),
        ),
      );

  Future<void> setKanjiDailyLimit(String userId, int units) =>
      _patch(userId, UserProfileCompanion(kanjiDailyLimit: Value(units)));

  Future<void> setRomajiHints(String userId, bool on) =>
      _patch(userId, UserProfileCompanion(romajiHints: Value(on ? 1 : 0)));
}
