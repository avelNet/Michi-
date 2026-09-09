import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_shell.dart';
import 'app/providers.dart';
import 'features/auth/profile_picker_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MichiApp()));
}

class MichiApp extends ConsumerWidget {
  const MichiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Michi',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ref.watch(themeModeProvider),
      home: const _Router(),
    );
  }
}

/// Единая точка маршрутизации: контент засеян? кто-то вошёл? онбординг
/// пройден? — и показывает соответствующий экран. Никаких именованных
/// маршрутов пока не нужно, состояний немного.
class _Router extends ConsumerWidget {
  const _Router();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentReadyProvider);

    return content.when(
      loading: () => const _Splash(),
      error: (e, _) => _FatalError('Не удалось подготовить контент:\n$e'),
      data: (_) {
        final session = ref.watch(sessionProvider);
        return session.when(
          loading: () => const _Splash(),
          error: (e, _) => _FatalError('Ошибка сессии:\n$e'),
          data: (userId) {
            if (userId == null) return const _LoggedOut();

            final user = ref.watch(currentUserProvider);
            return user.when(
              loading: () => const _Splash(),
              error: (e, _) => _FatalError('Ошибка профиля:\n$e'),
              data: (row) {
                if (row == null) return const _LoggedOut();
                if (row.onboardedAt == null) {
                  return OnboardingScreen(userId: row.id);
                }
                return AppShell(userId: row.id);
              },
            );
          },
        );
      },
    );
  }
}

class _LoggedOut extends ConsumerWidget {
  const _LoggedOut();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider);
    return profiles.when(
      loading: () => const _Splash(),
      error: (e, _) => _FatalError('Не удалось загрузить профили:\n$e'),
      data: (list) =>
          list.isEmpty ? const RegisterScreen(firstRun: true) : const ProfilePickerScreen(),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _FatalError extends StatelessWidget {
  final String message;
  const _FatalError(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
