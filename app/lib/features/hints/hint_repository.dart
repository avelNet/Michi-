import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database.dart';

/// Ключи обучающих подсказок. Значение — текст в самой подсказке задаётся
/// на месте показа; здесь только идентификаторы для «показано / не
/// показано».
class HintKeys {
  static const roadmap = 'roadmap.intro';
  static const review = 'review.intro';
  static const lesson = 'lesson.intro';
  static const stats = 'stats.intro';
  static const profile = 'profile.intro';
  static const settings = 'settings.intro';
  static const kana = 'kana.intro';
}

class HintRepository {
  final AppDatabase db;
  HintRepository(this.db);

  Future<Set<String>> seenKeys(String userId) async {
    final rows =
        await (db.select(db.uiHintSeen)..where((t) => t.userId.equals(userId))).get();
    return rows.map((r) => r.hintKey).toSet();
  }

  Future<void> markSeen(String userId, String key) async {
    await db.into(db.uiHintSeen).insert(
          UiHintSeenCompanion.insert(
            userId: userId,
            hintKey: key,
            seenAt: Value(DateTime.now().toIso8601String()),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> resetAll(String userId) async {
    await (db.delete(db.uiHintSeen)..where((t) => t.userId.equals(userId))).go();
  }
}

final hintRepositoryProvider =
    Provider<HintRepository>((ref) => HintRepository(ref.watch(dbProvider)));

/// Множество уже показанных подсказок текущего пользователя. Инвалидируется
/// после отметки и после сброса из настроек.
final seenHintsProvider = FutureProvider<Set<String>>((ref) async {
  final userId = ref.watch(sessionProvider).value;
  if (userId == null) return {};
  return ref.watch(hintRepositoryProvider).seenKeys(userId);
});
