import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../data/seed/content_seed.dart';
import '../../domain/srs/srs_scheduler.dart';
import '../../theme/app_theme.dart';
import 'review_repository.dart';

class ReviewScreen extends StatefulWidget {
  final AppDatabase db;
  /// null — все карточки; true — только трек кандзи; false — только
  /// основной путь (без кандзи). Одна и та же граница, что и переключатель
  /// треков на Карте — «повторение» из вкладки кандзи не должно
  /// подсовывать частицы, и наоборот.
  final bool? kanjiOnly;

  const ReviewScreen({super.key, required this.db, this.kanjiOnly});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late final ReviewRepository _repo;
  late Future<List<ReviewCard>> _future;
  final List<ReviewCard> _queue = [];
  bool _revealed = false;
  int _doneCount = 0;

  @override
  void initState() {
    super.initState();
    _repo = ReviewRepository(widget.db);
    _future = _load();
  }

  Future<List<ReviewCard>> _load() async {
    final cards = await _repo.loadDueCards(localUserId, kanjiOnly: widget.kanjiOnly);
    _queue
      ..clear()
      ..addAll(cards);
    return cards;
  }

  Future<void> _rate(ReviewRating rating) async {
    final card = _queue.first;
    await _repo.recordReview(userId: localUserId, card: card, rating: rating);
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
                Text('Осталось: ${_queue.length}', style: TextStyle(color: Theme.of(context).colors.inkSoft)),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _revealed = !_revealed),
                      child: Container(
                        width: 420,
                        constraints: const BoxConstraints(minHeight: 220),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              card.front,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.jp,
                                fontSize: 56,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colors.ink,
                              ),
                            ),
                            if (_revealed) ...[
                              const Divider(height: 40),
                              Text(
                                card.back,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Theme.of(context).colors.ink),
                              ),
                            ] else ...[
                              const SizedBox(height: 20),
                              Text(
                                'Нажми, чтобы увидеть ответ',
                                style: TextStyle(color: Theme.of(context).hintColor),
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
