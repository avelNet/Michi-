import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:michi/data/database.dart';
import 'package:michi/features/review/review_repository.dart';

/// Регрессия: карточки грамматики попадали в счётчик «к повторению», но
/// экран повторения их молча выкидывал (в _sidesFor не было ветки
/// grammar_point) — очередь получалась пустой.
void main() {
  test('due-карточка грамматики реально попадает в очередь повторения', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.into(db.users).insert(UsersCompanion.insert(id: 'u1'));
    await db.into(db.exerciseTypes).insert(ExerciseTypesCompanion.insert(
        code: 'flip_recall', pillar: 'reading', labelRu: 'Вспомнить'));

    final cid = await db.into(db.contentItems).insert(
        ContentItemsCompanion.insert(kind: 'grammar_point', jlptLevel: const Value('N5')));
    await db.into(db.grammarPoints).insert(GrammarPointsCompanion.insert(
          contentItemId: Value(cid),
          title: 'AはBです — «A есть B»',
          pattern: 'A は B です',
          explanation: 'Связка です. Пример: わたしは がくせいです。',
        ));

    await db.into(db.srsCards).insert(SrsCardsCompanion.insert(
          id: 's1',
          userId: 'u1',
          contentItemId: cid,
          exerciseType: 'flip_recall',
          state: const Value('new'),
          dueAt: Value(DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String()),
        ));

    final cards = await ReviewRepository(db).loadDueCards('u1');
    expect(cards, hasLength(1));
    expect(cards.first.kind, 'grammar_point');
    expect(cards.first.front.trim(), isNotEmpty);
    expect(cards.first.back, contains('A есть B'));
  });
}
