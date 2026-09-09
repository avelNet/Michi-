import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hint_banner.dart';
import '../auth/register_screen.dart' show kAvatarChoices;
import '../hints/hint_repository.dart';
import 'profile_repository.dart';

final _statsProvider = FutureProvider.family<ProfileStats, String>((ref, userId) {
  // Пересчитывается при возврате на вкладку (autoDispose семьи нет — но
  // ProfileScreen сам инвалидирует при открытии).
  return ProfileRepository(ref.watch(dbProvider)).load(userId);
});

class ProfileScreen extends ConsumerWidget {
  final String userId;
  final VoidCallback onOpenSettings;
  const ProfileScreen({super.key, required this.userId, required this.onOpenSettings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    final user = ref.watch(currentUserProvider).value;
    final profile = ref.watch(profileProvider).value;
    final stats = ref.watch(_statsProvider(userId));

    if (user == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
      children: [
        Row(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: colors.line),
              ),
              child: Text(user.avatarEmoji ?? '🌸', style: const TextStyle(fontSize: 34)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName ?? 'Профиль', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.ink)),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (user.email != null && user.email!.isNotEmpty) user.email!,
                      'Цель: ${profile?.targetJlptLevel ?? 'N5'}',
                    ].join('  ·  '),
                    style: TextStyle(color: colors.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _edit(context, ref, user),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Изменить'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const HintBanner(
          hintKey: HintKeys.profile,
          title: 'Ваш личный кабинет',
          body: 'Здесь видно всю картину: серия дней, сколько карточек в работе '
              'и закреплено, пройденные юниты и достижения. Кнопка «Изменить» — '
              'имя, аватар, e-mail и PIN.',
        ),
        const SizedBox(height: 8),
        stats.when(
          loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('Не удалось посчитать статистику: $e', style: const TextStyle(color: Colors.red)),
          data: (s) => _StatsGrid(colors: colors, s: s),
        ),
        const SizedBox(height: 24),
        _Achievements(colors: colors, stats: stats.value),
        const SizedBox(height: 28),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onOpenSettings,
              icon: const Icon(Icons.settings_outlined, size: 16),
              label: const Text('Настройки'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => ref.read(sessionProvider.notifier).signOut(),
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Выйти из профиля'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, User user) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _EditProfileDialog(user: user),
    );
    if (saved == true) {
      ref.invalidate(currentUserProvider);
      ref.invalidate(profilesProvider);
    }
  }
}

class _StatsGrid extends StatelessWidget {
  final AppColors colors;
  final ProfileStats s;
  const _StatsGrid({required this.colors, required this.s});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ('🔥', '${s.streakDays}', 'дней подряд'),
      ('🃏', '${s.totalCards}', 'карточек в работе'),
      ('✅', '${s.learnedCards}', 'закреплено'),
      ('🔁', '${s.reviewsAllTime}', 'повторений всего'),
      ('🗺️', '${s.unitsCompleted}/${s.unitsTotal}', 'юнитов пройдено'),
      ('📅', '${s.activeDays}', 'дней с занятиями'),
    ];
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth > 720 ? 3 : 2;
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
        children: [
          for (final (emoji, value, label) in tiles)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.ink)),
                        Text(label, style: TextStyle(fontSize: 11.5, color: colors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _Achievements extends StatelessWidget {
  final AppColors colors;
  final ProfileStats? stats;
  const _Achievements({required this.colors, required this.stats});

  @override
  Widget build(BuildContext context) {
    final s = stats;
    final items = <(String, String, bool)>[
      ('🌱', 'Первый шаг', (s?.reviewsAllTime ?? 0) >= 1),
      ('🔥', 'Серия 3 дня', (s?.streakDays ?? 0) >= 3),
      ('💪', 'Серия 7 дней', (s?.streakDays ?? 0) >= 7),
      ('💯', '100 повторений', (s?.reviewsAllTime ?? 0) >= 100),
      ('📚', '50 закреплено', (s?.learnedCards ?? 0) >= 50),
      ('🎌', 'N5 наполовину', (s?.n5Pct ?? 0) >= 0.5),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ДОСТИЖЕНИЯ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.muted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final (emoji, label, earned) in items)
                Opacity(
                  opacity: earned ? 1 : 0.35,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: earned ? colors.accent.withValues(alpha: 0.12) : colors.surface2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: earned ? colors.accent : colors.line),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.ink)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends ConsumerStatefulWidget {
  final User user;
  const _EditProfileDialog({required this.user});

  @override
  ConsumerState<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<_EditProfileDialog> {
  late final _name = TextEditingController(text: widget.user.displayName ?? '');
  late final _email = TextEditingController(text: widget.user.email ?? '');
  late String _avatar = widget.user.avatarEmoji ?? kAvatarChoices.first;
  final _pin = TextEditingController();
  late bool _hasPin = widget.user.pinHash != null;
  bool _changePin = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Имя не может быть пустым');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.updateProfileBasics(
        widget.user.id,
        name: _name.text,
        email: _email.text,
        avatarEmoji: _avatar,
      );
      if (_changePin) {
        if (_hasPin && _pin.text.length < 4) {
          setState(() {
            _busy = false;
            _error = 'PIN — минимум 4 цифры';
          });
          return;
        }
        await repo.setPin(widget.user.id, _hasPin ? _pin.text : null);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Не удалось сохранить: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Профиль'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final e in kAvatarChoices)
                    InkWell(
                      onTap: () => setState(() => _avatar = e),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _avatar == e ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
                            width: _avatar == e ? 2 : 1,
                          ),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Имя')),
              const SizedBox(height: 10),
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'E-mail (необязательно)')),
              const SizedBox(height: 6),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _changePin,
                onChanged: (v) => setState(() => _changePin = v ?? false),
                title: const Text('Изменить PIN'),
              ),
              if (_changePin) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _hasPin,
                  onChanged: (v) => setState(() => _hasPin = v),
                  title: Text(_hasPin ? 'PIN включён' : 'Без PIN'),
                ),
                if (_hasPin)
                  TextField(
                    controller: _pin,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                    decoration: const InputDecoration(labelText: 'Новый PIN (4–6 цифр)'),
                  ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context, false), child: const Text('Отмена')),
        FilledButton(onPressed: _busy ? null : _save, child: const Text('Сохранить')),
      ],
    );
  }
}
