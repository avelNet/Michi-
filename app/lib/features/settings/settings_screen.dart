import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hint_banner.dart';
import '../hints/hint_repository.dart';

class SettingsScreen extends ConsumerWidget {
  final String userId;
  const SettingsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (p) {
        if (p == null) return const Center(child: Text('Профиль не найден'));
        return _Body(userId: userId, p: p, colors: colors);
      },
    );
  }
}

class _Body extends ConsumerWidget {
  final String userId;
  final UserProfileData p;
  final AppColors colors;
  const _Body({required this.userId, required this.p, required this.colors});

  SettingsRepositoryActions _actions(WidgetRef ref) =>
      SettingsRepositoryActions(ref, userId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = _actions(ref);
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
      children: [
        Text('Настройки', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: colors.ink)),
        const SizedBox(height: 16),
        const HintBanner(
          hintKey: HintKeys.settings,
          title: 'Всё настраивается под вас',
          body: 'Тема, дневная цель, баланс навыков и напоминания. Изменения '
              'сохраняются сразу. Внизу — сброс прогресса и удаление профиля.',
        ),
        const SizedBox(height: 8),

        _Section(colors: colors, title: 'ВНЕШНИЙ ВИД', children: [
          _Row(
            colors: colors,
            label: 'Тема',
            hint: 'Системная следует за оформлением Windows',
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'light', label: Text('Светлая')),
                ButtonSegment(value: 'dark', label: Text('Тёмная')),
                ButtonSegment(value: 'system', label: Text('Система')),
              ],
              selected: {p.themeMode},
              onSelectionChanged: (s) => a.themeMode(s.first),
            ),
          ),
          _SwitchRow(
            colors: colors,
            label: 'Ромадзи-подсказки',
            hint: 'Показывать латинскую транскрипцию рядом с каной',
            value: p.romajiHints == 1,
            onChanged: a.romajiHints,
          ),
        ]),

        _Section(colors: colors, title: 'ЦЕЛИ', children: [
          _Row(
            colors: colors,
            label: 'Минут в день',
            hint: 'На этом строится серия дней',
            trailing: _NumberStepper(
              value: p.dailyMinutesGoal,
              min: 5,
              max: 120,
              step: 5,
              suffix: 'мин',
              onChanged: a.dailyGoal,
            ),
          ),
          _Row(
            colors: colors,
            label: 'Целевой уровень JLPT',
            hint: null,
            trailing: DropdownButton<String>(
              value: p.targetJlptLevel ?? 'N5',
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'N5', child: Text('N5')),
                DropdownMenuItem(value: 'N4', child: Text('N4')),
                DropdownMenuItem(value: 'N3', child: Text('N3')),
                DropdownMenuItem(value: 'N2', child: Text('N2')),
                DropdownMenuItem(value: 'N1', child: Text('N1')),
              ],
              onChanged: (v) => v == null ? null : a.targetJlpt(v),
            ),
          ),
          _Row(
            colors: colors,
            label: 'Кандзи-юнитов в день',
            hint: 'Осознанное ограничение: больше за раз не усваивается',
            trailing: _NumberStepper(
              value: p.kanjiDailyLimit,
              min: 1,
              max: 5,
              step: 1,
              suffix: 'юнит',
              onChanged: a.kanjiLimit,
            ),
          ),
        ]),

        _Section(colors: colors, title: 'БАЛАНС НАВЫКОВ', children: [
          _WeightsEditor(
            colors: colors,
            listening: p.weightListening,
            speaking: p.weightSpeaking,
            reading: p.weightReading,
            writing: p.weightWriting,
            onCommit: a.weights,
          ),
        ]),

        _Section(colors: colors, title: 'УВЕДОМЛЕНИЯ', children: [
          _SwitchRow(
            colors: colors,
            label: 'Напоминания',
            hint: 'Тост на рабочем столе, пока приложение открыто',
            value: p.remindersEnabled == 1,
            onChanged: (v) => a.reminder(enabled: v, hour: p.reminderHour, minute: p.reminderMinute),
          ),
          if (p.remindersEnabled == 1) ...[
            _Row(
              colors: colors,
              label: 'Время напоминания',
              hint: null,
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: p.reminderHour, minute: p.reminderMinute),
                  );
                  if (picked != null) {
                    a.reminder(enabled: true, hour: picked.hour, minute: picked.minute);
                  }
                },
                child: Text(
                  '${p.reminderHour.toString().padLeft(2, '0')}:${p.reminderMinute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            _SwitchRow(
              colors: colors,
              label: 'Есть карты к повторению',
              hint: null,
              value: p.notifyDueReviews == 1,
              onChanged: (v) => a.notify(dueReviews: v),
            ),
            _SwitchRow(
              colors: colors,
              label: 'Серия под угрозой',
              hint: 'Вечером, если сегодня ещё не занимались',
              value: p.notifyStreakRisk == 1,
              onChanged: (v) => a.notify(streakRisk: v),
            ),
            _SwitchRow(
              colors: colors,
              label: 'Дневная цель достигнута',
              hint: null,
              value: p.notifyDailyGoal == 1,
              onChanged: (v) => a.notify(dailyGoal: v),
            ),
          ],
        ]),

        _Section(colors: colors, title: 'ОБУЧЕНИЕ И ДАННЫЕ', children: [
          _ActionRow(
            colors: colors,
            icon: Icons.lightbulb_outline,
            label: 'Показать подсказки заново',
            hint: 'Обучающие пояснения появятся снова во всех разделах',
            onTap: () async {
              await ref.read(hintRepositoryProvider).resetAll(userId);
              ref.invalidate(seenHintsProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Подсказки снова включены')),
                );
              }
            },
          ),
          _ActionRow(
            colors: colors,
            icon: Icons.download_outlined,
            label: 'Экспортировать мои данные',
            hint: 'Сохранить прогресс и настройки в JSON-файл',
            onTap: () => _exportData(context, ref),
          ),
          _ActionRow(
            colors: colors,
            icon: Icons.restart_alt,
            label: 'Начать обучение сначала',
            hint: 'Сбросить прогресс и повторения. Профиль и настройки останутся',
            danger: true,
            onTap: () => _confirmResetProgress(context, ref),
          ),
          _ActionRow(
            colors: colors,
            icon: Icons.person_off_outlined,
            label: 'Удалить этот профиль',
            hint: 'Полностью, без возможности отмены',
            danger: true,
            onTap: () => _confirmDeleteProfile(context, ref),
          ),
        ]),
      ],
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final data = await ref.read(authRepositoryProvider).exportData(userId);
      final dir = await getApplicationDocumentsDirectory();
      final stamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File('${dir.path}${Platform.pathSeparator}michi-export-$stamp.json');
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено: ${file.path}'), duration: const Duration(seconds: 6)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось: $e')));
      }
    }
  }

  Future<void> _confirmResetProgress(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Начать сначала?'),
        content: const Text('Весь прогресс по карте, серия дней и очередь повторения обнулятся. Отменить нельзя.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authRepositoryProvider).resetProgress(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Прогресс сброшен')));
    }
  }

  Future<void> _confirmDeleteProfile(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить профиль?'),
        content: const Text('Профиль и все его данные будут удалены. Общий словарь останется.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authRepositoryProvider).deleteProfile(userId);
    ref.invalidate(profilesProvider);
    await ref.read(sessionProvider.notifier).signOut();
  }
}

/// Тонкая обёртка: вызвать репозиторий и инвалидировать профиль, чтобы
/// экран и тема сразу перерисовались.
class SettingsRepositoryActions {
  final WidgetRef ref;
  final String userId;
  SettingsRepositoryActions(this.ref, this.userId);

  Future<void> _after() async => ref.invalidate(profileProvider);

  Future<void> themeMode(String v) async {
    await ref.read(settingsRepositoryProvider).setThemeMode(userId, v);
    await _after();
  }

  Future<void> romajiHints(bool v) async {
    await ref.read(settingsRepositoryProvider).setRomajiHints(userId, v);
    await _after();
  }

  Future<void> dailyGoal(int v) async {
    await ref.read(settingsRepositoryProvider).setDailyGoal(userId, v);
    await _after();
  }

  Future<void> targetJlpt(String v) async {
    await ref.read(settingsRepositoryProvider).setTargetJlpt(userId, v);
    await _after();
  }

  Future<void> kanjiLimit(int v) async {
    await ref.read(settingsRepositoryProvider).setKanjiDailyLimit(userId, v);
    await _after();
  }

  Future<void> weights({required int l, required int s, required int r, required int w}) async {
    await ref.read(settingsRepositoryProvider).setWeights(userId, listening: l, speaking: s, reading: r, writing: w);
    await _after();
  }

  Future<void> reminder({required bool enabled, required int hour, required int minute}) async {
    await ref.read(settingsRepositoryProvider).setReminder(userId, enabled: enabled, hour: hour, minute: minute);
    await _after();
  }

  Future<void> notify({bool? dueReviews, bool? streakRisk, bool? dailyGoal}) async {
    await ref.read(settingsRepositoryProvider).setNotifyFlags(
          userId,
          dueReviews: dueReviews,
          streakRisk: streakRisk,
          dailyGoal: dailyGoal,
        );
    await _after();
  }
}

class _Section extends StatelessWidget {
  final AppColors colors;
  final String title;
  final List<Widget> children;
  const _Section({required this.colors, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.muted)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.line),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final AppColors colors;
  final String label;
  final String? hint;
  final Widget trailing;
  const _Row({required this.colors, required this.label, required this.hint, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14.5, color: colors.ink, fontWeight: FontWeight.w600)),
                if (hint != null) ...[
                  const SizedBox(height: 2),
                  Text(hint!, style: TextStyle(fontSize: 12, color: colors.muted)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final AppColors colors;
  final String label;
  final String? hint;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.colors,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Row(
      colors: colors,
      label: label,
      hint: hint,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final AppColors colors;
  final IconData icon;
  final String label;
  final String? hint;
  final bool danger;
  final VoidCallback onTap;
  const _ActionRow({
    required this.colors,
    required this.icon,
    required this.label,
    required this.hint,
    this.danger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = danger ? Colors.red : colors.ink;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: c),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14.5, color: c, fontWeight: FontWeight.w600)),
                  if (hint != null) ...[
                    const SizedBox(height: 2),
                    Text(hint!, style: TextStyle(fontSize: 12, color: colors.muted)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final String suffix;
  final ValueChanged<int> onChanged;
  const _NumberStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: value > min ? () => onChanged(value - step) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 64,
          child: Text('$value $suffix', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        IconButton(
          onPressed: value < max ? () => onChanged(value + step) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _WeightsEditor extends StatefulWidget {
  final AppColors colors;
  final int listening, speaking, reading, writing;
  final void Function({required int l, required int s, required int r, required int w}) onCommit;
  const _WeightsEditor({
    required this.colors,
    required this.listening,
    required this.speaking,
    required this.reading,
    required this.writing,
    required this.onCommit,
  });

  @override
  State<_WeightsEditor> createState() => _WeightsEditorState();
}

class _WeightsEditorState extends State<_WeightsEditor> {
  late double _l = widget.listening.toDouble();
  late double _s = widget.speaking.toDouble();
  late double _r = widget.reading.toDouble();
  late double _w = widget.writing.toDouble();

  int get _total => (_l + _s + _r + _w).round().clamp(1, 1 << 30);
  int _pct(double v) => (v / _total * 100).round();

  Widget _slider(String label, double v, ValueChanged<double> set) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: widget.colors.ink, fontWeight: FontWeight.w600))),
            Text('${_pct(v)}%', style: TextStyle(color: widget.colors.muted, fontWeight: FontWeight.w700)),
          ],
        ),
        Slider(
          value: v,
          min: 1,
          max: 40,
          activeColor: widget.colors.accent,
          onChanged: set,
          onChangeEnd: (_) => widget.onCommit(
            l: _pct(_l), s: _pct(_s), r: _pct(_r), w: _pct(_w),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Column(
        children: [
          _slider('👂 Понимание речи', _l, (x) => setState(() => _l = x)),
          _slider('🗣️ Речь', _s, (x) => setState(() => _s = x)),
          _slider('📖 Чтение', _r, (x) => setState(() => _r = x)),
          _slider('✍️ Письмо', _w, (x) => setState(() => _w = x)),
        ],
      ),
    );
  }
}

