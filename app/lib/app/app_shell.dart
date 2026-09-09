import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seed/srs_enrollment.dart';
import '../features/kana_reference/kana_reference_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/review/review_screen.dart';
import '../features/roadmap/roadmap_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/stats/stats_screen.dart';
import '../theme/app_theme.dart';
import 'providers.dart';

/// Постоянная оболочка приложения: слева — навигация по разделам, справа
/// — активный раздел. Разделы держатся живыми через IndexedStack, чтобы
/// не терять состояние (прокрутку карты, наполовину пройденное
/// повторение) при переключении.
class AppShell extends ConsumerStatefulWidget {
  final String userId;
  const AppShell({super.key, required this.userId});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  static const _dests = [
    (Icons.map_outlined, Icons.map, 'Карта'),
    (Icons.style_outlined, Icons.style, 'Повторение'),
    (Icons.grid_view_outlined, Icons.grid_view, 'Словарь'),
    (Icons.insights_outlined, Icons.insights, 'Статистика'),
    (Icons.person_outline, Icons.person, 'Профиль'),
    (Icons.settings_outlined, Icons.settings, 'Настройки'),
  ];

  @override
  void initState() {
    super.initState();
    // Догоняем очередь повторения: любой контент из уже начатых/пройденных
    // юнитов должен быть доступен для повторения (идемпотентно).
    final db = ref.read(dbProvider);
    enrollAccessibleContentInSrs(db, widget.userId);
  }

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final db = ref.watch(dbProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: Row(
        children: [
          _Rail(
            colors: colors,
            index: _index,
            destinations: _dests,
            onSelect: _go,
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                RoadmapScreen(db: db, userId: widget.userId),
                ReviewScreen(db: db, userId: widget.userId),
                KanaReferenceScreen(db: db),
                StatsScreen(userId: widget.userId),
                ProfileScreen(userId: widget.userId, onOpenSettings: () => _go(5)),
                SettingsScreen(userId: widget.userId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  final AppColors colors;
  final int index;
  final List<(IconData, IconData, String)> destinations;
  final ValueChanged<int> onSelect;

  const _Rail({
    required this.colors,
    required this.index,
    required this.destinations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      color: colors.surface2,
      child: Column(
        children: [
          const SizedBox(height: 22),
          Text('道', style: TextStyle(fontFamily: AppFonts.jp, fontSize: 26, color: colors.accent)),
          const SizedBox(height: 20),
          for (var i = 0; i < destinations.length; i++)
            _RailItem(
              colors: colors,
              icon: index == i ? destinations[i].$2 : destinations[i].$1,
              label: destinations[i].$3,
              selected: index == i,
              onTap: () => onSelect(i),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final AppColors colors;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RailItem({
    required this.colors,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? colors.accent.withValues(alpha: 0.14) : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: selected ? colors.accent : colors.inkSoft),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? colors.accent : colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
