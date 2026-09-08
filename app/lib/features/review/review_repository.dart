import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';
import '../../domain/srs/srs_scheduler.dart';

class ReviewCard {
  final String srsCardId;
  final int contentItemId;
  final String kind;
  final String front;
  final String back;

  ReviewCard({
    required this.srsCardId,
    required this.contentItemId,
    required this.kind,
    required this.front,
    required this.back,
  });
}

const _uuid = Uuid();

class ReviewRepository {
  final AppDatabase db;
  ReviewRepository(this.db);

  Future<List<ReviewCard>> loadDueCards(String userId) async {
    final nowIso = DateTime.now().toIso8601String();
    final dueRows = await (db.select(db.srsCards)
          ..where((t) => t.userId.equals(userId) & t.dueAt.isSmallerOrEqualValue(nowIso))
          ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
        .get();

    final cards = <ReviewCard>[];
    for (final row in dueRows) {
      final contentItem = await (db.select(db.contentItems)
            ..where((t) => t.id.equals(row.contentItemId)))
          .getSingleOrNull();
      if (contentItem == null) continue;

      final sides = await _sidesFor(contentItem.id, contentItem.kind);
      if (sides == null) continue;

      cards.add(ReviewCard(
        srsCardId: row.id,
        contentItemId: contentItem.id,
        kind: contentItem.kind,
        front: sides.$1,
        back: sides.$2,
      ));
    }
    return cards;
  }

  Future<(String, String)?> _sidesFor(int contentItemId, String kind) async {
    switch (kind) {
      case 'kana':
        final k = await (db.select(db.kana)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (k == null) return null;
        return (k.char, k.romaji);
      case 'kanji':
        final k = await (db.select(db.kanji)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (k == null) return null;
        final readings = [
          if (k.onYomi != null) 'он: ${_joinJsonArray(k.onYomi!)}',
          if (k.kunYomi != null) 'кун: ${_joinJsonArray(k.kunYomi!)}',
        ].join('\n');
        return (k.char, '${_joinJsonArray(k.meaningsRu)}\n$readings');
      case 'word':
        final w = await (db.select(db.words)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (w == null) return null;
        return (w.surfaceForm, '${w.reading}\n${_joinJsonArray(w.meaningsRu)}');
      case 'particle':
        final p = await (db.select(db.particles)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (p == null) return null;
        return (p.particle, p.shortDescription ?? p.longTheory ?? '');
      default:
        return null;
    }
  }

  String _joinJsonArray(String jsonArray) {
    // Значения хранятся как простой JSON-массив строк (см. db/schema.sql);
    // для карточки достаточно грубого разбора без зависимости от dart:convert-схемы.
    final inner = jsonArray.trim().replaceAll(RegExp(r'^\[|\]$'), '');
    return inner
        .split(',')
        .map((s) => s.trim().replaceAll('"', ''))
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  Future<void> recordReview({
    required String userId,
    required ReviewCard card,
    required ReviewRating rating,
  }) async {
    final now = DateTime.now();
    final existing = await (db.select(db.srsCards)..where((t) => t.id.equals(card.srsCardId)))
        .getSingle();

    final result = SrsScheduler.schedule(
      card: SrsCardState(
        state: existing.state,
        stability: existing.stability,
        difficulty: existing.difficulty,
        reps: existing.reps,
        lapses: existing.lapses,
      ),
      rating: rating,
      now: now,
    );

    await db.transaction(() async {
      await (db.update(db.srsCards)..where((t) => t.id.equals(card.srsCardId))).write(
        SrsCardsCompanion(
          state: Value(result.state),
          stability: Value(result.stability),
          difficulty: Value(result.difficulty),
          reps: Value(result.reps),
          lapses: Value(result.lapses),
          dueAt: Value(result.dueAt.toIso8601String()),
          lastReviewedAt: Value(now.toIso8601String()),
        ),
      );

      await db.into(db.reviewLog).insert(
            ReviewLogCompanion.insert(
              id: _uuid.v4(),
              userId: userId,
              cardId: card.srsCardId,
              rating: rating.name,
              reviewedAt: now.toIso8601String(),
              device: const Value('windows'),
            ),
          );

      final today = now.toIso8601String().substring(0, 10);
      final existingDay = await (db.select(db.dailyActivity)
            ..where((t) => t.userId.equals(userId) & t.activityDate.equals(today)))
          .getSingleOrNull();
      if (existingDay == null) {
        await db.into(db.dailyActivity).insert(
              DailyActivityCompanion.insert(
                userId: userId,
                activityDate: today,
                reviewsDone: const Value(1),
              ),
            );
      } else {
        await (db.update(db.dailyActivity)
              ..where((t) => t.userId.equals(userId) & t.activityDate.equals(today)))
            .write(DailyActivityCompanion(reviewsDone: Value(existingDay.reviewsDone + 1)));
      }
    });
  }
}
