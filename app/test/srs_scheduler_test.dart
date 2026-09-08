import 'package:flutter_test/flutter_test.dart';
import 'package:michi/domain/srs/srs_scheduler.dart';

void main() {
  final now = DateTime(2026, 1, 1, 12, 0);

  group('новая карточка', () {
    test('again -> остаётся в заучивании, короткий шаг', () {
      final r = SrsScheduler.schedule(
        card: SrsCardState.fresh(),
        rating: ReviewRating.again,
        now: now,
      );
      expect(r.state, 'relearning');
      expect(r.lapses, 1);
      expect(r.dueAt, now.add(learningSteps.first));
    });

    test('good -> good доводит до выпуска в review', () {
      var card = SrsCardState.fresh();
      final r1 = SrsScheduler.schedule(card: card, rating: ReviewRating.good, now: now);
      expect(r1.state, 'learning');
      expect(r1.reps, 1);

      card = SrsCardState(state: r1.state, stability: r1.stability, difficulty: r1.difficulty, reps: r1.reps, lapses: r1.lapses);
      final r2 = SrsScheduler.schedule(card: card, rating: ReviewRating.good, now: now);
      expect(r2.state, 'review');
      expect(r2.reps, 1);
      expect(r2.stability, 1);
    });

    test('easy -> сразу выпускает в review с интервалом 4 дня', () {
      final r = SrsScheduler.schedule(card: SrsCardState.fresh(), rating: ReviewRating.easy, now: now);
      expect(r.state, 'review');
      expect(r.stability, 4);
      expect(r.dueAt, now.add(const Duration(days: 4)));
    });
  });

  group('карточка в review', () {
    const reviewCard = SrsCardState(state: 'review', stability: 6, difficulty: 2.5, reps: 3, lapses: 0);

    test('good -> интервал растёт как stability*ease', () {
      final r = SrsScheduler.schedule(card: reviewCard, rating: ReviewRating.good, now: now);
      expect(r.state, 'review');
      expect(r.stability, 15); // 6*2.5=15
      expect(r.reps, 4);
    });

    test('hard -> интервал растёт медленнее, ease падает', () {
      final r = SrsScheduler.schedule(card: reviewCard, rating: ReviewRating.hard, now: now);
      expect(r.stability, (6 * 1.2).round()); // округляется до целых дней
      expect(r.difficulty, closeTo(2.35, 0.001));
    });

    test('easy -> интервал растёт быстрее, ease растёт', () {
      final r = SrsScheduler.schedule(card: reviewCard, rating: ReviewRating.easy, now: now);
      expect(r.stability, ((6 * 2.5) * 1.3).round());
      expect(r.difficulty, closeTo(2.65, 0.001));
    });

    test('again -> откатывает в relearning независимо от текущего интервала', () {
      final r = SrsScheduler.schedule(card: reviewCard, rating: ReviewRating.again, now: now);
      expect(r.state, 'relearning');
      expect(r.lapses, 1);
      expect(r.stability, 0);
    });

    test('ease не опускается ниже 1.3', () {
      const lowEase = SrsCardState(state: 'review', stability: 3, difficulty: 1.35, reps: 5, lapses: 2);
      final r = SrsScheduler.schedule(card: lowEase, rating: ReviewRating.hard, now: now);
      expect(r.difficulty, greaterThanOrEqualTo(1.3));
    });
  });
}
