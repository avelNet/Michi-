import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';

/// Экран статистики. Подробные графики (календарь активности, точность
/// по столпам, кривая повторений) — следующий коммит; пока — заглушка,
/// чтобы раздел был на месте и по нему можно было ходить.
class StatsScreen extends ConsumerWidget {
  final String userId;
  const StatsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insights_outlined, size: 48, color: colors.muted),
          const SizedBox(height: 12),
          Text('Статистика скоро', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colors.ink)),
          const SizedBox(height: 6),
          Text('Календарь активности, точность и прогресс по навыкам', style: TextStyle(color: colors.muted)),
        ],
      ),
    );
  }
}
