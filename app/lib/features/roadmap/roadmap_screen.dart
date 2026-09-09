import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../data/seed/content_seed.dart';
import '../../theme/app_theme.dart';
import '../lesson/lesson_screen.dart';
import '../review/review_screen.dart';
import 'roadmap_repository.dart';

class RoadmapScreen extends StatefulWidget {
  final AppDatabase db;
  final bool isDark;
  final VoidCallback onToggleTheme;

  const RoadmapScreen({super.key, required this.db, required this.isDark, required this.onToggleTheme});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late final RoadmapRepository _repo;
  late Future<_RoadmapData> _future;
  int? _selectedUnitId;

  static const _pathWidth = 600.0;
  static const _startY = 90.0;
  static const _stepY = 150.0;
  static const _dxSequence = [
    0.0, 130.0, -110.0, 90.0, -140.0, 60.0, -100.0, 140.0, -70.0, 20.0,
  ];

  @override
  void initState() {
    super.initState();
    _repo = RoadmapRepository(widget.db);
    _future = _load();
  }

  Future<_RoadmapData> _load() async {
    final units = await _repo.loadUnits(localUserId);
    final due = await _repo.countDueReviews(localUserId);
    final streak = await _repo.currentStreakDays(localUserId);
    final n5 = await _repo.jlptProgressPct(localUserId, 'N5');
    return _RoadmapData(units: units, dueReviews: due, streakDays: streak, n5Progress: n5);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: FutureBuilder<_RoadmapData>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return Row(
            children: [
              _NavRail(colors: colors, onOpenReview: _openReview),
              Expanded(child: _buildPathArea(colors, data)),
              _Sidebar(colors: colors, data: data, onOpenReview: _openReview),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openReview() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReviewScreen(db: widget.db)),
    );
    setState(() => _future = _load());
  }

  Future<void> _openLesson(RoadmapUnit unit) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreen(db: widget.db, userId: localUserId, unit: unit),
      ),
    );
    setState(() {
      _selectedUnitId = null;
      _future = _load();
    });
  }

  Widget _buildPathArea(AppColors colors, _RoadmapData data) {
    final units = data.units;
    final points = <Offset>[];
    for (var i = 0; i < units.length; i++) {
      final dx = i < _dxSequence.length ? _dxSequence[i] : 0.0;
      points.add(Offset(_pathWidth / 2 + dx, _startY + i * _stepY));
    }

    var doneUpTo = units.indexWhere((u) => u.status == 'in_progress');
    if (doneUpTo < 0) {
      final lastCompleted = units.lastIndexWhere((u) => u.status == 'completed');
      doneUpTo = lastCompleted;
    }
    if (doneUpTo < 0) doneUpTo = -1;

    final pathHeight = points.isEmpty ? 400.0 : points.last.dy + 140;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 28, 40, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'あなたの道 — ваш путь',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: colors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Каждый узел приближает к пониманию живого текста',
                      style: TextStyle(color: colors.muted, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(widget.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined),
                color: colors.inkSoft,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surface,
                  side: BorderSide(color: colors.line),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: _pathWidth,
                height: pathHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PathPainter(
                          points: points,
                          doneUpToIndex: doneUpTo,
                          doneColor: colors.accent,
                          lockedColor: colors.pathLineLocked,
                        ),
                      ),
                    ),
                    for (var i = 0; i < units.length; i++)
                      _buildNode(colors, units[i], points[i]),
                    if (_selectedUnitId != null)
                      _buildPopover(colors, units, points),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNode(AppColors colors, RoadmapUnit unit, Offset point) {
    const size = 72.0;
    final isMilestone = unit.kind == 'milestone';
    final nodeSize = isMilestone ? 92.0 : size;
    final selected = _selectedUnitId == unit.id;

    return Positioned(
      left: point.dx - 70,
      top: point.dy - nodeSize / 2,
      width: 140,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedUnitId = selected ? null : unit.id),
            child: _NodeCircle(
              colors: colors,
              unit: unit,
              size: nodeSize,
              isMilestone: isMilestone,
              selected: selected,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            isMilestone ? 'Веха N5' : unit.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: unit.status == 'locked'
                  ? colors.lockedText
                  : (unit.status == 'in_progress' ? colors.accent : colors.inkSoft),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopover(AppColors colors, List<RoadmapUnit> units, List<Offset> points) {
    final index = units.indexWhere((u) => u.id == _selectedUnitId);
    if (index < 0) return const SizedBox.shrink();
    final unit = units[index];
    final point = points[index];
    final dx = index < _dxSequence.length ? _dxSequence[index] : 0.0;

    var left = dx >= 0 ? point.dx - 300 : point.dx + 56;
    left = left.clamp(16.0, _pathWidth - 300);
    final top = math.max(16.0, point.dy - 74);

    return Positioned(
      left: left,
      top: top,
      width: 284,
      child: _UnitPopover(
        colors: colors,
        unit: unit,
        repo: _repo,
        onClose: () => setState(() => _selectedUnitId = null),
        onOpen: () => _openLesson(unit),
        onOpenReview: unit.status == 'completed' ? _openReview : null,
      ),
    );
  }
}

class _RoadmapData {
  final List<RoadmapUnit> units;
  final int dueReviews;
  final int streakDays;
  final double n5Progress;

  _RoadmapData({
    required this.units,
    required this.dueReviews,
    required this.streakDays,
    required this.n5Progress,
  });
}

class _PathPainter extends CustomPainter {
  final List<Offset> points;
  final int doneUpToIndex;
  final Color doneColor;
  final Color lockedColor;

  _PathPainter({
    required this.points,
    required this.doneUpToIndex,
    required this.doneColor,
    required this.lockedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final splitAt = doneUpToIndex.clamp(0, points.length - 1);
    final donePts = points.sublist(0, splitAt + 1);
    final lockedPts = points.sublist(splitAt);

    final lockedPaint = Paint()
      ..color = lockedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    _drawDashed(canvas, _smoothPath(lockedPts), lockedPaint);

    if (donePts.length >= 2) {
      final donePaint = Paint()
        ..color = doneColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_smoothPath(donePts), donePaint);
    }
  }

  Path _smoothPath(List<Offset> pts) {
    final path = Path();
    if (pts.isEmpty) return path;
    path.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length - 1; i++) {
      final mid = Offset((pts[i].dx + pts[i + 1].dx) / 2, (pts[i].dy + pts[i + 1].dy) / 2);
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    return path;
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 2.0;
    const dashGap = 11.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, math.min(distance + dashWidth, metric.length)),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.doneUpToIndex != doneUpToIndex || oldDelegate.points != points;
  }
}

class _NodeCircle extends StatefulWidget {
  final AppColors colors;
  final RoadmapUnit unit;
  final double size;
  final bool isMilestone;
  final bool selected;

  const _NodeCircle({
    required this.colors,
    required this.unit,
    required this.size,
    required this.isMilestone,
    required this.selected,
  });

  @override
  State<_NodeCircle> createState() => _NodeCircleState();
}

class _NodeCircleState extends State<_NodeCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final unit = widget.unit;
    final isCompleted = unit.status == 'completed';
    final isCurrent = unit.status == 'in_progress';
    final isLocked = unit.status == 'locked';

    Color bg = colors.surface;
    Color border = colors.line;
    if (isCurrent) {
      border = colors.accent;
      bg = Color.alphaBlend(colors.accent.withValues(alpha: 0.09), colors.surface);
    } else if (isLocked) {
      bg = colors.lockedFill;
      border = colors.lockedFill;
    } else if (isCompleted) {
      border = Color.alphaBlend(colors.accent.withValues(alpha: 0.55), colors.line);
    }

    final glyph = _glyphFor(unit);
    final glyphColor = isLocked ? colors.lockedText : (isCurrent ? colors.accent : colors.ink);

    return SizedBox(
      width: widget.size + 12,
      height: widget.size + 12,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (isCurrent)
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = _pulse.value;
                return Container(
                  width: widget.size + t * 26,
                  height: widget.size + t * 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.accent.withValues(alpha: (1 - t) * 0.45),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: bg,
              shape: widget.isMilestone ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: widget.isMilestone ? BorderRadius.circular(22) : null,
              border: Border.all(color: border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: unit.kind == 'listening'
                ? Icon(Icons.graphic_eq, size: 26, color: glyphColor)
                : widget.isMilestone
                    ? Icon(Icons.account_balance_outlined, size: 34, color: glyphColor)
                    : Text(
                        glyph,
                        style: TextStyle(fontFamily: AppFonts.jp, fontSize: 27, color: glyphColor),
                      ),
          ),
          if (isCompleted)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: colors.bg, width: 1.5),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
            ),
          if (isLocked)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.line),
                ),
                child: Icon(Icons.lock_outline, size: 11, color: colors.lockedText),
              ),
            ),
        ],
      ),
    );
  }

  String _glyphFor(RoadmapUnit unit) {
    switch (unit.kind) {
      case 'kana':
        return unit.title.startsWith('Хирагана') ? 'あ' : 'カ';
      case 'kanji_vocab':
        return '語';
      case 'particle':
        return 'は';
      case 'grammar':
        return '文';
      default:
        return '道';
    }
  }
}

class _UnitPopover extends StatelessWidget {
  final AppColors colors;
  final RoadmapUnit unit;
  final RoadmapRepository repo;
  final VoidCallback onClose;
  final VoidCallback onOpen;
  final VoidCallback? onOpenReview;

  const _UnitPopover({
    required this.colors,
    required this.unit,
    required this.repo,
    required this.onClose,
    required this.onOpen,
    required this.onOpenReview,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = unit.status == 'locked';
    final isCompleted = unit.status == 'completed';

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.line),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(unit.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: colors.ink)),
                ),
                InkWell(
                  onTap: onClose,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16, color: colors.muted),
                  ),
                ),
              ],
            ),
            if (unit.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(unit.subtitle!, style: TextStyle(fontSize: 12.5, color: colors.muted)),
            ],
            const SizedBox(height: 12),
            if (isLocked)
              FutureBuilder<List<String>>(
                future: repo.loadPrerequisiteTitles(unit.id),
                builder: (context, snapshot) {
                  final titles = snapshot.data ?? const [];
                  if (titles.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_outline, size: 13, color: colors.lockedText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Откроется после: ${titles.join(", ")}',
                            style: TextStyle(fontSize: 12, color: colors.lockedText),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLocked ? null : (isCompleted ? onOpenReview : onOpen),
                style: FilledButton.styleFrom(
                  backgroundColor: isCompleted ? colors.surface2 : colors.accent,
                  foregroundColor: isCompleted ? colors.inkSoft : Colors.white,
                  disabledBackgroundColor: colors.surface2,
                  disabledForegroundColor: colors.muted,
                  side: isCompleted ? BorderSide(color: colors.line) : null,
                ),
                child: Text(
                  isLocked
                      ? 'Заблокировано'
                      : isCompleted
                          ? 'Повторить пройденное'
                          : unit.status == 'in_progress'
                              ? 'Продолжить'
                              : 'Начать',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRail extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onOpenReview;
  const _NavRail({required this.colors, required this.onOpenReview});

  @override
  Widget build(BuildContext context) {
    final icons = [
      (Icons.map_outlined, 'Дорожная карта', true, null),
      (Icons.style_outlined, 'Повторение', false, onOpenReview),
      (Icons.menu_book_outlined, 'Библиотека (скоро)', false, null),
      (Icons.bar_chart_outlined, 'Статистика (скоро)', false, null),
    ];
    return Container(
      width: 76,
      color: colors.surface2,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(Icons.account_balance_outlined, color: colors.accent, size: 26),
          const SizedBox(height: 18),
          for (final item in icons)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Tooltip(
                message: item.$2,
                child: InkWell(
                  onTap: item.$4,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item.$3 ? Color.alphaBlend(colors.accent.withValues(alpha: 0.14), colors.surface) : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.$1, color: item.$3 ? colors.accent : colors.inkSoft, size: 22),
                  ),
                ),
              ),
            ),
          const Spacer(),
          Icon(Icons.settings_outlined, color: colors.inkSoft, size: 22),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final AppColors colors;
  final _RoadmapData data;
  final VoidCallback onOpenReview;
  const _Sidebar({required this.colors, required this.data, required this.onOpenReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(color: colors.surface, border: Border(left: BorderSide(color: colors.line))),
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          _card(
            label: 'СЕРИЯ ДНЕЙ',
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: colors.accent, size: 30),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.streakDays}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: colors.ink)),
                    Text('дней подряд', style: TextStyle(fontSize: 12, color: colors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            label: 'СЕГОДНЯ К ПОВТОРЕНИЮ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data.dueReviews}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: colors.ink)),
                const SizedBox(height: 4),
                Text(
                  data.dueReviews == 0 ? 'пока нечего повторять' : 'карточек ждут повторения',
                  style: TextStyle(fontSize: 12.5, color: colors.muted),
                ),
                if (data.dueReviews > 0) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onOpenReview,
                      style: OutlinedButton.styleFrom(foregroundColor: colors.accent, side: BorderSide(color: colors.accent)),
                      child: const Text('Начать повторение'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            label: 'ПРОГРЕСС ПО JLPT',
            child: Column(
              children: [
                _jlptRow('N5', data.n5Progress),
                _jlptRow('N4', 0),
                _jlptRow('N3', 0),
                _jlptRow('N2', 0),
                _jlptRow('N1', 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jlptRow(String level, double pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 28, child: Text(level, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: colors.inkSoft))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: colors.surface2,
                valueColor: AlwaysStoppedAnimation(colors.accent),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text('${(pct * 100).round()}%', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, color: colors.muted)),
          ),
        ],
      ),
    );
  }

  Widget _card({required String label, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.muted)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
