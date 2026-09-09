import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';
import '../../domain/japanese/dictionary_text.dart';
import '../../domain/japanese/romaji.dart';
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

  /// Все content_item_id, принадлежащие хотя бы одному юниту трека
  /// кандзи (unit.kind == 'kanji_vocab') — граница между "путь кандзи"
  /// и "основной путь" в Повторении проведена ровно там же, где и на
  /// самой Карте (переключатель треков), а не отдельной эвристикой.
  Future<Set<int>> _kanjiTrackContentIds() async {
    final query = db.select(db.unitItems).join([
      innerJoin(db.units, db.units.id.equalsExp(db.unitItems.unitId)),
    ])
      ..where(db.units.kind.equals('kanji_vocab'));
    final rows = await query.get();
    return rows.map((r) => r.readTable(db.unitItems).contentItemId).toSet();
  }

  /// `kanjiOnly`: null — все карточки; true — только трек кандзи;
  /// false — всё, КРОМЕ трека кандзи (основной путь).
  Future<List<ReviewCard>> loadDueCards(String userId, {bool? kanjiOnly}) async {
    final nowIso = DateTime.now().toIso8601String();
    var dueRows = await (db.select(db.srsCards)
          ..where((t) => t.userId.equals(userId) & t.dueAt.isSmallerOrEqualValue(nowIso))
          ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
        .get();

    if (kanjiOnly != null) {
      final kanjiIds = await _kanjiTrackContentIds();
      dueRows = dueRows.where((r) => kanjiIds.contains(r.contentItemId) == kanjiOnly).toList();
    }

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
        final example = await _kanaExample(contentItemId);
        return (k.char, example == null ? k.romaji : '${k.romaji}\n$example');
      case 'kanji':
        final k = await (db.select(db.kanji)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (k == null) return null;
        final readings = [
          if (k.onYomi != null) 'он: ${_readingsWithRomaji(k.onYomi!)}',
          if (k.kunYomi != null) 'кун: ${_readingsWithRomaji(k.kunYomi!)}',
        ].join('\n');
        return (k.char, '${joinCleanMeanings(k.meaningsRu)}\n$readings');
      case 'word':
        final w = await (db.select(db.words)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (w == null) return null;
        return (w.surfaceForm, '${w.reading} (${kanaToRomaji(w.reading)})\n${joinCleanMeanings(w.meaningsRu)}');
      case 'particle':
        final p = await (db.select(db.particles)..where((t) => t.contentItemId.equals(contentItemId)))
            .getSingleOrNull();
        if (p == null) return null;
        return (p.particle, p.shortDescription ?? p.longTheory ?? '');
      default:
        return null;
    }
  }

  Future<String?> _kanaExample(int kanaContentItemId) async {
    final query = db.select(db.wordKana).join([
      innerJoin(db.words, db.words.contentItemId.equalsExp(db.wordKana.wordContentItemId)),
    ])
      ..where(db.wordKana.kanaContentItemId.equals(kanaContentItemId))
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    final w = row.readTable(db.words);
    return '${w.surfaceForm} (${kanaToRomaji(w.reading)}) — ${primaryCleanMeaning(w.meaningsRu)}';
  }

  /// Каждое чтение из JSON-массива — с ромадзи рядом, для тех, кому пока
  /// проще ориентироваться по латинице, чем бегло читать кану.
  String _readingsWithRomaji(String jsonArray) {
    return parseMeaningsJson(jsonArray).map((r) => '$r (${kanaToRomaji(r)})').join(', ');
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
