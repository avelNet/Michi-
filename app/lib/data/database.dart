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
