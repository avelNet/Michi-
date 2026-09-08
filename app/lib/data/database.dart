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
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'michi.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
