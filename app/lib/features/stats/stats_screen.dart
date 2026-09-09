import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hint_banner.dart';
import '../hints/hint_repository.dart';
import 'stats_repository.dart';

final _statsDataProvider =
    FutureProvider.autoDispose.family<StatsData, String>((ref, userId) {
  return StatsRepository(ref.watch(dbProvider)).load(userId);
});

class StatsScreen extends ConsumerWidget {
  final String userId;
  const StatsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    final async = ref.watch(_statsDataProvider(userId));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(_statsDataProvider(userId)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
        children: [
          Text('Статистика', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: colors.ink)),
          const SizedBox(height: 16),
          const HintBanner(
            hintKey: HintKeys.stats,
            title: 'Как читать эту страницу',
            body: 'Всё считается из вашего журнала повторений и ежедневной '
                'активности — ничего выдуманного.',
            bullets: [
              'Серия дней растёт, если за день было хоть одно повторение или новый элемент',
              'Точность — доля ответов «Хорошо» и «Легко» за 30 дней',
              'Теплокарта — 12 недель: чем насыщеннее клетка, тем больше повторений в тот день',
            ],
          ),
          const SizedBox(height: 8),
          async.when(
            loading: () => const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('Не удалось загрузить: $e', style: const TextStyle(color: Colors.red)),
            data: (s) => _Content(colors: colors, s: s),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppColors colors;
  final StatsData s;
  const _Content({required this.colors, required this.s});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TodayCard(colors: colors, s: s),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _stat('Серия сейчас', '${s.streakDays}', 'дней подряд', '🔥')),
            const SizedBox(width: 12),
            Expanded(child: _stat('Рекорд серии', '${s.longestStreak}', 'дней', '🏅')),
            const SizedBox(width: 12),
            Expanded(child: _stat('Повторений всего', '${s.totalReviews}', 'за всё время', '🔁')),
            const SizedBox(width: 12),
            Expanded(
                child: _stat(
                    'Точность 30 дн.',
                    s.accuracy30 == null ? '—' : '${(s.accuracy30! * 100).round()}%',
                    'ответов «хорошо/легко»',
                    '🎯')),
          ],
        ),
        const SizedBox(height: 24),
        _Section(
          colors: colors,
          title: 'ПОВТОРЕНИЙ ПО ДНЯМ · 14 дней',
          child: _BarChart(colors: colors, data: s.last14),
        ),
        const SizedBox(height: 16),
        _Section(
          colors: colors,
          title: 'АКТИВНОСТЬ · 12 недель',
          child: _Heatmap(colors: colors, data: s.last84),
        ),
        const SizedBox(height: 16),
        _Section(
          colors: colors,
          title: 'КАРТОЧКИ ПО СОСТОЯНИЮ',
          child: _StateBars(colors: colors, byState: s.cardsByState),
        ),
      ],
    );
  }

  Widget _stat(String label, String value, String sub, String emoji) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji  $label', style: TextStyle(fontSize: 11, color: colors.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.ink)),
          Text(sub, style: TextStyle(fontSize: 11, color: colors.muted)),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final AppColors colors;
  final StatsData s;
  const _TodayCard({required this.colors, required this.s});

  @override
  Widget build(BuildContext context) {
    final goalMet = s.todayMinutes >= s.goalMinutes && s.goalMinutes > 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(child: _num('${s.todayReviews}', 'повторений сегодня')),
          Expanded(child: _num('${s.todayNew}', 'новых элементов')),
          Expanded(child: _num('${s.todayMinutes}/${s.goalMinutes}', 'минут (цель)')),
          Icon(
            goalMet ? Icons.check_circle : Icons.timelapse,
            color: goalMet ? Colors.green : colors.muted,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _num(String v, String l) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: colors.ink)),
          Text(l, style: TextStyle(fontSize: 11.5, color: colors.muted)),
        ],
      );
}

class _Section extends StatelessWidget {
  final AppColors colors;
  final String title;
  final Widget child;
  const _Section({required this.colors, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.muted)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final AppColors colors;
  final List<DayCount> data;
  const _BarChart({required this.colors, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxV = data.fold<int>(1, (m, d) => d.reviews > m ? d.reviews : m);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in data)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(d.reviews > 0 ? '${d.reviews}' : '', style: TextStyle(fontSize: 9, color: colors.muted)),
                    const SizedBox(height: 2),
                    Container(
                      height: (d.reviews / maxV * 84).clamp(3, 84).toDouble(),
                      decoration: BoxDecoration(
                        color: d.reviews > 0 ? colors.accent : colors.line,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${d.date.day}', style: TextStyle(fontSize: 8.5, color: colors.muted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  final AppColors colors;
  final List<DayCount> data; // 84 дня по возрастанию
  const _Heatmap({required this.colors, required this.data});

  @override
  Widget build(BuildContext context) {
    // 12 колонок-недель по 7 клеток. data.length == 84.
    final weeks = <List<DayCount>>[];
    for (var i = 0; i < data.length; i += 7) {
      weeks.add(data.sublist(i, (i + 7).clamp(0, data.length)));
    }
    final maxV = data.fold<int>(1, (m, d) => d.reviews > m ? d.reviews : m);

    Color cell(DayCount d) {
      if (d.reviews == 0) return d.active ? colors.accent.withValues(alpha: 0.25) : colors.surface2;
      final t = (d.reviews / maxV).clamp(0.15, 1.0);
      return Color.alphaBlend(colors.accent.withValues(alpha: t), colors.surface);
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final w in weeks)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  children: [
                    for (final d in w)
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: cell(d),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: colors.line, width: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('меньше', style: TextStyle(fontSize: 10, color: colors.muted)),
            const SizedBox(width: 6),
            for (final a in [0.15, 0.4, 0.7, 1.0])
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(colors.accent.withValues(alpha: a), colors.surface),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            const SizedBox(width: 6),
            Text('больше', style: TextStyle(fontSize: 10, color: colors.muted)),
          ],
        ),
      ],
    );
  }
}

class _StateBars extends StatelessWidget {
  final AppColors colors;
  final Map<String, int> byState;
  const _StateBars({required this.colors, required this.byState});

  @override
  Widget build(BuildContext context) {
    const labels = {
      'new': 'Новые',
      'learning': 'Заучиваются',
      'review': 'На повторении',
      'relearning': 'Переучиваются',
      'suspended': 'Отложены',
    };
    final total = byState.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return Text('Пока нет карточек — пройдите первый урок на Карте', style: TextStyle(color: colors.muted, fontSize: 13));
    }
    return Column(
      children: [
        for (final entry in labels.entries)
          if ((byState[entry.key] ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(width: 120, child: Text(entry.value, style: TextStyle(fontSize: 12.5, color: colors.inkSoft))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (byState[entry.key] ?? 0) / total,
                        minHeight: 10,
                        backgroundColor: colors.surface2,
                        valueColor: AlwaysStoppedAnimation(colors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(width: 36, child: Text('${byState[entry.key]}', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: colors.muted))),
                ],
              ),
            ),
      ],
    );
  }
}
