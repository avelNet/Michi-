import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../theme/app_theme.dart';
import 'auth_repository.dart';
import 'register_screen.dart';

class ProfilePickerScreen extends ConsumerWidget {
  const ProfilePickerScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref, ProfileSummary p) async {
    if (p.hasPin) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => _PinDialog(userId: p.id, name: p.displayName),
      );
      if (ok != true) return;
    }
    await ref.read(sessionProvider.notifier).signIn(p.id);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, ProfileSummary p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Удалить профиль «${p.displayName}»?'),
        content: const Text(
          'Исчезнут весь прогресс, серия дней и повторения этого профиля. '
          'Общий словарь (кана, кандзи, слова) останется. Отменить нельзя.',
        ),
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
    await ref.read(authRepositoryProvider).deleteProfile(p.id);
    ref.invalidate(profilesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    final profiles = ref.watch(profilesProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('道', style: TextStyle(fontFamily: AppFonts.jp, fontSize: 44, color: colors.accent), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('С возвращением', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.ink), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text('Выберите профиль', style: TextStyle(color: colors.muted), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                profiles.when(
                  loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => Text('Ошибка: $e', style: const TextStyle(color: Colors.red)),
                  data: (list) => Column(
                    children: [
                      for (final p in list)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ProfileCard(
                            colors: colors,
                            profile: p,
                            onTap: () => _pick(context, ref, p),
                            onDelete: () => _delete(context, ref, p),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить профиль'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: colors.accent,
                    side: BorderSide(color: colors.accent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AppColors colors;
  final ProfileSummary profile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProfileCard({
    required this.colors,
    required this.profile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              Text(profile.avatarEmoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.displayName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.ink)),
                    const SizedBox(height: 2),
                    Text(
                      profile.onboarded ? (profile.hasPin ? 'Защищён PIN' : 'Готов к занятиям') : 'Не завершил настройку',
                      style: TextStyle(fontSize: 12.5, color: colors.muted),
                    ),
                  ],
                ),
              ),
              if (profile.hasPin) Icon(Icons.lock_outline, size: 16, color: colors.muted),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colors.muted),
                onSelected: (v) {
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'delete', child: Text('Удалить профиль')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDialog extends ConsumerStatefulWidget {
  final String userId;
  final String name;
  const _PinDialog({required this.userId, required this.name});

  @override
  ConsumerState<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends ConsumerState<_PinDialog> {
  final _pin = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref.read(authRepositoryProvider).verifyPin(widget.userId, _pin.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _busy = false;
        _error = 'Неверный PIN';
        _pin.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('PIN для «${widget.name}»'),
      content: TextField(
        controller: _pin,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
        onSubmitted: (_) => _check(),
        decoration: InputDecoration(labelText: 'PIN', errorText: _error),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
        FilledButton(onPressed: _busy ? null : _check, child: const Text('Войти')),
      ],
    );
  }
}
