import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../data/seed/srs_enrollment.dart';
import '../../theme/app_theme.dart';
import '../review/review_screen.dart';
import '../roadmap/roadmap_repository.dart';

/// Урок одного юнита: сначала теория (текст), потом практика —
/// пролистать каждый элемент юнита лицом/изнанкой. По завершении юнит
/// отмечается пройденным и весь его контент зачисляется в Повторение.
class LessonScreen extends StatefulWidget {
  final AppDatabase db;
  final String userId;
  final RoadmapUnit unit;

  const LessonScreen({super.key, required this.db, required this.userId, required this.unit});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

enum _Stage { loading, theory, practice, done }

class _LessonScreenState extends State<LessonScreen> {
  late final RoadmapRepository _repo;
  _Stage _stage = _Stage.loading;
  List<LessonItem> _items = []; // только то, что ЕЩЁ не зачислено в SRS
  int _addedThisSession = 0;
  int _index = 0;
  bool _flipped = false;
  bool _alreadyFullyLearned = false;

  @override
  void initState() {
    super.initState();
    _repo = RoadmapRepository(widget.db);
    _load();
  }

  Future<void> _load() async {
    final allItems = await _repo.loadUnitLessonItems(widget.unit.id);
    await _repo.markUnitStarted(widget.userId, widget.unit.id);

    final enrolledIds = await _repo.loadEnrolledContentIds(
      widget.userId,
      allItems.map((i) => i.contentItemId).toList(),
    );
    final remaining = allItems.where((i) => !enrolledIds.contains(i.contentItemId)).toList();
    if (!mounted) return;

    // Всё содержимое юнита уже было показано раньше (сессия прервалась
    // ровно на последней карточке, либо юнит открыли повторно) —
    // просто закрепляем юнит как пройденный, не гоняя пустую практику.
    if (allItems.isNotEmpty && remaining.isEmpty) {
      await _repo.markUnitCompleted(widget.userId, widget.unit.id);
      if (!mounted) return;
      setState(() {
        _alreadyFullyLearned = true;
        _stage = _Stage.done;
      });
      return;
    }

    setState(() {
      _items = remaining;
      _stage = _Stage.theory;
    });
  }

  Future<void> _finish() async {
    await _repo.markUnitCompleted(widget.userId, widget.unit.id);
    if (!mounted) return;
    setState(() => _stage = _Stage.done);
  }

  Future<void> _nextPracticeItem() async {
    // Зачисляем карточку сразу, как только её увидели — если сессия
    // прервётся на середине, уже показанное всё равно попадёт
    // в Повторение, а не потеряется.
    await enrollOneInSrs(widget.db, widget.userId, _items[_index].contentItemId);
    _addedThisSession++;
    if (!mounted) return;
    if (_index + 1 >= _items.length) {
      await _finish();
      return;
    }
    setState(() {
      _index++;
      _flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.unit.title)),
      body: switch (_stage) {
        _Stage.loading => const Center(child: CircularProgressIndicator()),
        _Stage.theory => _buildTheory(),
        _Stage.practice => _items.isEmpty ? _buildNoContent() : _buildPractice(),
        _Stage.done => _buildDone(),
      },
    );
  }

  Widget _buildTheory() {
    final unit = widget.unit;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ТЕОРИЯ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                unit.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colors.ink),
              ),
              const SizedBox(height: 16),
              Text(
                _fallbackTheory(unit),
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => setState(() => _stage = _Stage.practice),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(_items.isEmpty ? 'Понятно' : 'К практике (${_items.length})'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fallbackTheory(RoadmapUnit unit) {
    return unit.description ??
        unit.subtitle ??
        'Материалы по этой теме появятся в одной из следующих сессий.';
  }

  Widget _buildNoContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Практика для этого юнита ещё не наполнена.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _finish, child: const Text('Понятно, закрыть')),
          ],
        ),
      ),
    );
  }

  Widget _buildPractice() {
    final item = _items[_index];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_index + 1) / _items.length,
                  minHeight: 6,
                  backgroundColor: Theme.of(context).colors.surface2,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colors.accent),
                ),
              ),
              const SizedBox(height: 8),
              Text('${_index + 1} / ${_items.length}'),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => setState(() => _flipped = !_flipped),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 320),
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(item.front, style: const TextStyle(fontFamily: AppFonts.jp, fontSize: 120, height: 1)),
                      ),
                      if (_flipped) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: Text(item.back, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center),
                        ),
                        if (item.theory != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colors.surface2,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final line in item.theory!.split('\n'))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      line,
                                      style: TextStyle(fontSize: 15, height: 1.4, color: Theme.of(context).colors.inkSoft),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ] else
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Center(
                            child: Text('нажми, чтобы перевернуть', style: TextStyle(color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _flipped ? _nextPracticeItem : () => setState(() => _flipped = true),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(!_flipped ? 'Показать ответ' : (_index + 1 >= _items.length ? 'Завершить' : 'Дальше')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDone() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 56, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Юнит «${widget.unit.title}» пройден',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              _alreadyFullyLearned
                  ? 'Все элементы уже были изучены раньше'
                  : '$_addedThisSession элементов добавлено в Повторение',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Для кандзи — явный призыв повторить сразу же, а не молча
            // надеяться, что до них дойдёт очередь в общем Повторении:
            // именно закрепление сразу после изучения и даёт запоминание,
            // просто пройти дальше по Карте для этого не достаточно.
            if (widget.unit.kind == 'kanji_vocab' && !_alreadyFullyLearned) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ReviewScreen(db: widget.db, userId: widget.userId, kanjiOnly: true)),
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop(true);
                  },
                  icon: const Icon(Icons.style_outlined, size: 18),
                  label: const Text('Повторить эти кандзи сейчас'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('На Дорожную карту'),
              ),
            ] else
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('На Дорожную карту'),
              ),
          ],
        ),
      ),
    );
  }
}
