import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/seed/srs_enrollment.dart';
import '../features/kana_reference/kana_reference_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/reminders/due_summary.dart';
import '../features/review/review_screen.dart';
import '../features/roadmap/roadmap_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/stats/stats_screen.dart';
import '../services/desktop_toast.dart';
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
  Timer? _reminderTimer;

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
    // Догоняем очередь повторения: контент из уже начатых/пройденных
    // юнитов должен быть доступен для повторения (идемпотентно).
    enrollAccessibleContentInSrs(ref.read(dbProvider), widget.userId);

    // Проверка напоминаний — раз в минуту, пока приложение открыто.
    // Windows не умеет фоновое расписание уведомлений, поэтому канал —
    // баннер в приложении + «лучшая попытка» системного тоста.
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) => _maybeNotify());
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeNotify());
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  Future<void> _maybeNotify() async {
    if (!mounted) return;
    // Свежие цифры для баннера/бейджа — раз в минуту достаточно.
    ref.invalidate(dueSummaryProvider);

    final profile = ref.read(profileProvider).value;
    if (profile == null || profile.remindersEnabled != 1) return;

    final now = DateTime.now();
    final reminderPassed = now.hour > profile.reminderHour ||
        (now.hour == profile.reminderHour && now.minute >= profile.reminderMinute);
    if (!reminderPassed) return;

    final DueSummary summary;
    try {
      summary = await ref.read(dueSummaryProvider.future);
    } catch (_) {
      return;
    }

    final wantDue = profile.notifyDueReviews == 1 && summary.dueNow > 0;
    final wantStreak = profile.notifyStreakRisk == 1 && summary.streakAtRisk(now);
    if (!wantDue && !wantStreak) return;

    final prefs = await SharedPreferences.getInstance();
    final dayKey = 'michi.notif.${widget.userId}.${now.toIso8601String().substring(0, 10)}';
    if (prefs.getBool(dayKey) ?? false) return;
    await prefs.setBool(dayKey, true);

    final title = wantStreak ? 'Серия ${summary.streakDays} дн. под угрозой' : 'Пора повторить';
    final body = wantStreak
        ? 'Сегодня ещё не занимались. Несколько минут — и серия сохранена.'
        : '${summary.dueNow} карточек ждут повторения в Michi.';
    await DesktopToast.show(title, body);
  }

  void _go(int i) {
    setState(() => _index = i);
    // Возврат из Повторения/Урока — обновить бейдж и напоминание.
    ref.invalidate(dueSummaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final db = ref.watch(dbProvider);
    final summary = ref.watch(dueSummaryProvider).value;
    final dueBadge = summary?.dueNow ?? 0;

    return Scaffold(
      backgroundColor: colors.bg,
      body: Row(
        children: [
          _Rail(
            colors: colors,
            index: _index,
            destinations: _dests,
            dueBadge: dueBadge,
            onSelect: _go,
          ),
          Expanded(
            child: Column(
              children: [
                if (_index != 1 && summary != null)
                  _ReminderBanner(
                    colors: colors,
                    summary: summary,
                    onOpenReview: () => _go(1),
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
          ),
        ],
      ),
    );
  }
}

class _ReminderBanner extends StatelessWidget {
  final AppColors colors;
  final DueSummary summary;
  final VoidCallback onOpenReview;
  const _ReminderBanner({required this.colors, required this.summary, required this.onOpenReview});

  @override
  Widget build(BuildContext context) {
    final atRisk = summary.streakAtRisk(DateTime.now());
    if (summary.dueNow == 0 && !atRisk) return const SizedBox.shrink();

    final text = atRisk
        ? 'Серия ${summary.streakDays} дн. под угрозой — сегодня вы ещё не занимались'
        : '${summary.dueNow} ${_plural(summary.dueNow)} к повторению';

    return Material(
      color: colors.accent.withValues(alpha: 0.10),
      child: InkWell(
        onTap: onOpenReview,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Row(
            children: [
              Icon(atRisk ? Icons.local_fire_department : Icons.style_outlined, size: 18, color: colors.accent),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: TextStyle(color: colors.ink, fontWeight: FontWeight.w600, fontSize: 13))),
              Text('Открыть повторение →', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ],
          ),
        ),
      ),
    );
  }

  String _plural(int n) {
    final m10 = n % 10, m100 = n % 100;
    if (m10 == 1 && m100 != 11) return 'карточка';
    if (m10 >= 2 && m10 <= 4 && (m100 < 10 || m100 >= 20)) return 'карточки';
    return 'карточек';
  }
}

class _Rail extends StatelessWidget {
  final AppColors colors;
  final int index;
  final List<(IconData, IconData, String)> destinations;
  final int dueBadge;
  final ValueChanged<int> onSelect;

  const _Rail({
    required this.colors,
    required this.index,
    required this.destinations,
    required this.dueBadge,
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
              badge: i == 1 ? dueBadge : 0,
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
  final int badge;
  final VoidCallback onTap;

  const _RailItem({
    required this.colors,
    required this.icon,
    required this.label,
    required this.selected,
    required this.badge,
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 22, color: selected ? colors.accent : colors.inkSoft),
                  if (badge > 0)
                    Positioned(
                      right: -8,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 15),
                        decoration: BoxDecoration(
                          color: colors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : '$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
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
