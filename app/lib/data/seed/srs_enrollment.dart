import 'package:drift/drift.dart';

import '../database.dart';

/// Зачисляет в очередь повторения (создаёт srs_cards) весь контент из
/// юнитов, к которым пользователь уже прикасался (`in_progress` или
/// `completed`) — то, чему учили, должно быть доступно для повторения.
/// Вызывается при каждом запуске приложения (идемпотентно за счёт
/// уникального индекса user+content_item+exercise_type), а не только
/// при первом — по мере прохождения новых юнитов очередь пополняется.
Future<void> enrollAccessibleContentInSrs(AppDatabase db, String userId) async {
  final accessibleUnits = await (db.select(db.unitProgress)
        ..where((t) =>
            t.userId.equals(userId) &
            (t.status.equals('in_progress') | t.status.equals('completed'))))
      .get();
  if (accessibleUnits.isEmpty) return;

  final unitIds = accessibleUnits.map((u) => u.unitId).toList();

  final itemRows = await (db.select(db.unitItems)
        ..where((t) => t.unitId.isIn(unitIds)))
      .get();
  final contentIds = itemRows.map((r) => r.contentItemId).toSet();
  if (contentIds.isEmpty) return;

  await db.batch((batch) {
    final now = DateTime.now().toIso8601String();
    for (final contentId in contentIds) {
      batch.insert(
        db.srsCards,
        SrsCardsCompanion.insert(
          id: 'srs-$userId-$contentId-flip_recall',
          userId: userId,
          contentItemId: contentId,
          exerciseType: 'flip_recall',
          state: const Value('new'),
          dueAt: Value(now),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });
}
