/// Планировщик интервалов повторения — чистая доменная логика,
/// без Flutter/БД-зависимостей (легко тестируется).
///
/// Реализация: упрощённый SM-2 с короткими шагами заучивания перед
/// переходом в обычный режим повторения. Поля схемы `stability`/
/// `difficulty` задуманы под полноценный FSRS (см. db/schema.sql) —
/// здесь они используются прагматично как «интервал в днях» и
/// «фактор лёгкости» соответственно; переход на настоящий FSRS позже
/// не потребует менять схему, только эту функцию.
library;

enum ReviewRating { again, hard, good, easy }

/// Шаги заучивания для новой/несданной карточки, прежде чем она
/// перейдёт в обычный режим повторения с растущим интервалом.
const learningSteps = [Duration(minutes: 10), Duration(days: 1)];

class SrsCardState {
  final String state; // new | learning | review | relearning | suspended
  final double? stability; // интервал в днях (после выпуска из заучивания)
  final double? difficulty; // фактор лёгкости, стартует с 2.5
  final int reps; // в 'learning' — номер пройденного шага; в 'review' — число успешных повторений
  final int lapses;

  const SrsCardState({
    required this.state,
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
  });

  factory SrsCardState.fresh() =>
      const SrsCardState(state: 'new', stability: null, difficulty: null, reps: 0, lapses: 0);
}

class SrsScheduleResult {
  final String state;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;

  const SrsScheduleResult({
    required this.state,
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
    required this.dueAt,
  });
}

class SrsScheduler {
  static const _minEase = 1.3;
  static const _startEase = 2.5;

  static SrsScheduleResult schedule({
    required SrsCardState card,
    required ReviewRating rating,
    required DateTime now,
  }) {
    final ease = card.difficulty ?? _startEase;
    final intervalDays = card.stability ?? 0.0;

    if (rating == ReviewRating.again) {
      return SrsScheduleResult(
        state: 'relearning',
        stability: 0,
        difficulty: (ease - 0.2).clamp(_minEase, 10.0),
        reps: 0,
        lapses: card.lapses + 1,
        dueAt: now.add(learningSteps.first),
      );
    }

    final stillLearning = card.state != 'review';

    if (stillLearning) {
      if (rating == ReviewRating.hard) {
        return SrsScheduleResult(
          state: 'learning',
          stability: 0,
          difficulty: ease,
          reps: card.reps,
          lapses: card.lapses,
          dueAt: now.add(learningSteps.first),
        );
      }
      if (rating == ReviewRating.easy) {
        return SrsScheduleResult(
          state: 'review',
          stability: 4,
          difficulty: (ease + 0.15).clamp(_minEase, 10.0),
          reps: 1,
          lapses: card.lapses,
          dueAt: now.add(const Duration(days: 4)),
        );
      }
      // good
      final nextStep = card.reps + 1;
      if (nextStep >= learningSteps.length) {
        return SrsScheduleResult(
          state: 'review',
          stability: 1,
          difficulty: ease,
          reps: 1,
          lapses: card.lapses,
          dueAt: now.add(const Duration(days: 1)),
        );
      }
      return SrsScheduleResult(
        state: 'learning',
        stability: 0,
        difficulty: ease,
        reps: nextStep,
        lapses: card.lapses,
        dueAt: now.add(learningSteps[nextStep]),
      );
    }

    // Обычный режим повторения (card.state == 'review').
    double newInterval;
    double newEase = ease;
    switch (rating) {
      case ReviewRating.hard:
        newInterval = (intervalDays <= 0 ? 1 : intervalDays * 1.2);
        newEase = (ease - 0.15).clamp(_minEase, 10.0);
      case ReviewRating.good:
        newInterval = (intervalDays <= 0 ? 1 : intervalDays * ease);
      case ReviewRating.easy:
        newInterval = (intervalDays <= 0 ? 1 : intervalDays * ease) * 1.3;
        newEase = (ease + 0.15).clamp(_minEase, 10.0);
      case ReviewRating.again:
        throw StateError('again handled above');
    }
    final clampedDays = newInterval.clamp(1, 365 * 5).round();
    return SrsScheduleResult(
      state: 'review',
      stability: clampedDays.toDouble(),
      difficulty: newEase,
      reps: card.reps + 1,
      lapses: card.lapses,
      dueAt: now.add(Duration(days: clampedDays)),
    );
  }
}
