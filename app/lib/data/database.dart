import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Локальная база устройства: и контент (кана/кандзи/слова/частицы/
/// грамматика/юниты), и пользовательские данные (профиль, SRS, прогресс)
/// пока лежат в одном файле — разделение на content.db + user.db как
/// отдельные физические файлы отложено до Фазы 2/3, когда появится
/// обновляемый контент-пак. Схема — см. schema.drift и db/schema.sql.
@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // v1 -> v2: локальные аккаунты, настройки в профиле, флаги
          // обучающих подсказок. Всё аддитивно — существующие данные
          // (контент, SRS, прогресс) не трогаем.
          if (from < 2) {
            await m.addColumn(users, users.email);
            await m.addColumn(users, users.pinHash);
            await m.addColumn(users, users.pinSalt);
            await m.addColumn(users, users.avatarEmoji);
            await m.addColumn(users, users.onboardedAt);
            await m.addColumn(users, users.lastActiveAt);

            await m.addColumn(userProfile, userProfile.themeMode);
            await m.addColumn(userProfile, userProfile.remindersEnabled);
            await m.addColumn(userProfile, userProfile.reminderHour);
            await m.addColumn(userProfile, userProfile.reminderMinute);
            await m.addColumn(userProfile, userProfile.notifyDueReviews);
            await m.addColumn(userProfile, userProfile.notifyStreakRisk);
            await m.addColumn(userProfile, userProfile.notifyDailyGoal);
            await m.addColumn(userProfile, userProfile.kanjiDailyLimit);
            await m.addColumn(userProfile, userProfile.romajiHints);

            await m.createTable(uiHintSeen);

            // Старый единственный профиль 'local': если им реально
            // пользовались — оставляем как выбираемый профиль с именем;
            // если это пустой сид-профиль — убираем, чтобы не мозолил
            // глаза на экране выбора при первом запуске v2.
            final localUser = await customSelect(
              "SELECT id FROM users WHERE id = 'local'",
            ).getSingleOrNull();
            if (localUser != null) {
              final used = await customSelect(
                "SELECT "
                "(SELECT COUNT(*) FROM review_log WHERE user_id='local') + "
                "(SELECT COUNT(*) FROM unit_progress WHERE user_id='local') AS n",
              ).getSingle();
              final n = used.data['n'] as int? ?? 0;
              if (n > 0) {
                await customStatement(
                  "UPDATE users SET display_name = COALESCE(display_name, 'Мой профиль'), "
                  "avatar_emoji = COALESCE(avatar_emoji, '🌸') WHERE id = 'local'",
                );
              } else {
                await customStatement("DELETE FROM srs_cards WHERE user_id='local'");
                await customStatement("DELETE FROM user_profile WHERE user_id='local'");
                await customStatement("DELETE FROM users WHERE id='local'");
              }
            }
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'michi.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
