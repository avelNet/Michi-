import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../domain/srs/srs_scheduler.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hint_banner.dart';
import '../hints/hint_repository.dart';
import '../stats/activity_tracker.dart';
import 'review_repository.dart';

class ReviewScreen extends StatefulWidget {
  final AppDatabase db;
  final String userId;

  /// null — все карточки; true — только трек кандзи; false — только
  /// основной путь (без кандзи). Одна и та же граница, что и переключатель
  /// треков на Карте — «повторение» из вкладки кандзи не должно
  /// подсовывать частицы, и наоборот.
  final bool? kanjiOnly;

  const ReviewScreen({super.key, required this.db, required this.userId, this.kanjiOnly});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final ReviewRepository _repo;
  late Future<List<ReviewCard>> _future;
  final List<ReviewCard> _queue = [];
  bool _revealed = false;
  int _doneCount = 0;
  DateTime _lastRateAt = DateTime.now();
  int _secAccum = 0;

  @override
  void initState() {
    super.initState();
    _repo = ReviewRepository(widget.db);
    _future = _load();
  }

  Future<List<ReviewCard>> _load() async {
    final cards = await _repo.loadDueCards(widget.userId, kanjiOnly: widget.kanjiOnly);
    _queue
      ..clear()
      ..addAll(cards);
    return cards;
  }

  Future<void> _rate(ReviewRating rating) async {
    final card = _queue.first;
    await _repo.recordReview(userId: widget.userId, card: card, rating: rating);

    // Живой учёт времени: реальная пауза между оценками, но не больше
    // 2 минут за карточку (иначе «отошёл и вернулся» раздует статистику).
    final delta = DateTime.now().difference(_lastRateAt).inSeconds.clamp(0, 120);
    _lastRateAt = DateTime.now();
    _secAccum += delta;
    if (_secAccum >= 60) {
      final mins = _secAccum ~/ 60;
      _secAccum %= 60;
      await bumpActivity(widget.db, widget.userId, minutes: mins);
    }

    setState(() {
      _queue.removeAt(0);
      _revealed = false;
      _doneCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.kanjiOnly == true
              ? 'Повторение — кандзи'
              : widget.kanjiOnly == false
                  ? 'Повторение — основной путь'
                  : 'Повторение',
        ),
      ),
      body: FutureBuilder<List<ReviewCard>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (_queue.isEmpty) {
            return _EmptyState(doneCount: _doneCount);
          }
          final card = _queue.first;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: const HintBanner(
                    hintKey: HintKeys.review,
                    title: 'Интервальное повторение',
                    body: 'Вспомните ответ, нажмите на карточку — и честно '
                        'оцените себя. От оценки зависит, когда карточка '
                        'вернётся:',
                    bullets: [
                      '«Забыл» — заново, через несколько минут',
                      '«Трудно» — скоро, интервал почти не растёт',
                      '«Хорошо» — обычный рост интервала',
                      '«Легко» — большой скачок вперёд',
                    ],
                  ),
                ),
                Text('Осталось: ${_queue.length}', style: TextStyle(color: Theme.of(context).colors.inkSoft)),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _revealed = !_revealed),
                      child: Container(
                        width: 480,
                        constraints: const BoxConstraints(minHeight: 220),
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 22),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                card.front,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFonts.jp,
                                  fontSize: card.front.runes.length > 8 ? 30 : 56,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colors.ink,
                                ),
                              ),
                            ),
                            if (_revealed) ...[
                              const Divider(height: 40),
                              () {
                                final lines = card.back.split('\n');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      lines.first,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colors.ink,
                                      ),
                                    ),
                                    if (lines.length > 1) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colors.surface2,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for (final line in lines.skip(1))
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                child: Text(
                                                  line,
                                                  style: TextStyle(fontSize: 14.5, height: 1.4, color: Theme.of(context).colors.inkSoft),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              }(),
                            ] else ...[
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Нажми, чтобы увидеть ответ',
                                  style: TextStyle(color: Theme.of(context).hintColor),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_revealed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ratingButton('Забыл', Colors.red, ReviewRating.again),
                      _ratingButton('Трудно', Colors.orange, ReviewRating.hard),
                      _ratingButton('Хорошо', Colors.green, ReviewRating.good),
                      _ratingButton('Легко', Colors.blue, ReviewRating.easy),
                    ],
                  )
                else
                  const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _ratingButton(String label, Color color, ReviewRating rating) {
    return ElevatedButton(
      onPressed: () => _rate(rating),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      child: Text(label),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int doneCount;
  const _EmptyState({required this.doneCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 56),
          const SizedBox(height: 12),
          Text(
            doneCount > 0 ? 'Готово! Повторено карточек: $doneCount' : 'Пока нечего повторять',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Theme.of(context).colors.ink),
          ),
        ],
      ),
    );
  }
}
