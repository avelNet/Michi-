import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../theme/app_theme.dart';

const kAvatarChoices = [
  '🌸', '🦊', '🐧', '🍵', '⛩️', '🗻', '🐼', '🌊', '🍜', '🎋', '🐉', '📚',
];

class RegisterScreen extends ConsumerStatefulWidget {
  /// Первый запуск приложения (ещё нет ни одного профиля) — тогда нет
  /// кнопки «назад» и другой заголовок.
  final bool firstRun;
  const RegisterScreen({super.key, this.firstRun = false});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();
  String _avatar = kAvatarChoices.first;
  bool _wantPin = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pin.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(authRepositoryProvider);
    if (await repo.nameTaken(_name.text)) {
      setState(() => _error = 'Профиль с таким именем уже есть');
      return;
    }

    setState(() => _busy = true);
    try {
      final id = await repo.register(
        name: _name.text,
        email: _email.text,
        pin: _wantPin ? _pin.text : null,
        avatarEmoji: _avatar,
      );
      ref.invalidate(profilesProvider);
      await ref.read(sessionProvider.notifier).signIn(id);
      // Если экран был открыт поверх выбора профиля — убрать его со
      // стека, иначе он останется поверх онбординга.
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // Дальше маршрутизатор сам покажет онбординг.
    } catch (e) {
      if (mounted) setState(() => _error = 'Не удалось создать профиль: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: widget.firstRun
          ? null
          : AppBar(backgroundColor: colors.bg, elevation: 0, title: const Text('Новый профиль')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.firstRun) ...[
                    Text('道', style: TextStyle(fontFamily: AppFonts.jp, fontSize: 56, color: colors.accent), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Michi', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: colors.ink), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('Ваш путь к японскому — шаг за шагом', style: TextStyle(color: colors.muted), textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                  ],
                  Text('ВЫБЕРИТЕ АВАТАР', style: _labelStyle(colors)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in kAvatarChoices)
                        InkWell(
                          onTap: () => setState(() => _avatar = e),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 46,
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _avatar == e ? colors.accent.withValues(alpha: 0.15) : colors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _avatar == e ? colors.accent : colors.line,
                                width: _avatar == e ? 2 : 1,
                              ),
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _name,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Имя *',
                      helperText: 'Как к вам обращаться в приложении',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail (необязательно)',
                      helperText: 'Не требуется для входа. Пригодится, когда появится облако',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                      return ok ? null : 'Похоже, адрес с опечаткой';
                    },
                  ),
                  const SizedBox(height: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _wantPin,
                    onChanged: (v) => setState(() => _wantPin = v),
                    title: const Text('Защитить профиль PIN-кодом'),
                    subtitle: Text(
                      'Спросим PIN при входе. Можно добавить позже в настройках',
                      style: TextStyle(color: colors.muted, fontSize: 12.5),
                    ),
                  ),
                  if (_wantPin) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pin,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                            decoration: const InputDecoration(labelText: 'PIN (4–6 цифр)'),
                            validator: (v) {
                              if (!_wantPin) return null;
                              if (v == null || v.length < 4) return 'Минимум 4 цифры';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _pin2,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                            decoration: const InputDecoration(labelText: 'Повторите PIN'),
                            validator: (v) {
                              if (!_wantPin) return null;
                              if (v != _pin.text) return 'PIN не совпадает';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _busy
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Создать и продолжить'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle(AppColors colors) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: colors.muted,
      );
}
