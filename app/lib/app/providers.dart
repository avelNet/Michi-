import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database.dart';
import '../data/seed/content_seed.dart';
import '../data/seed/curriculum.dart';
import '../features/auth/auth_repository.dart';
import '../features/settings/settings_repository.dart';

/// Единственный экземпляр БД на всё приложение.
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dbProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(dbProvider)),
);

/// Подготовка контента на старте: базовое наполнение (кана/кандзи/слова)
/// при первом запуске + идемпотентная досборка полного курса N5
/// (грамматика, частицы, лексика, аудирование, граф дорожной карты) —
/// каждый запуск, чтобы старые установки догоняли новый контент.
final contentReadyProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(dbProvider);
  await seedContentIfEmpty(db);
  await ensureCurriculum(db);
});

/// Список всех локальных профилей (для экрана выбора профиля).
final profilesProvider = FutureProvider<List<ProfileSummary>>(
  (ref) => ref.watch(authRepositoryProvider).listProfiles(),
);

/// Полная строка `users` текущего пользователя (нужно поле onboarded_at,
/// которого нет в user_profile).
final currentUserProvider = FutureProvider<User?>((ref) async {
  final userId = ref.watch(sessionProvider).value;
  if (userId == null) return null;
  final db = ref.watch(dbProvider);
  return (db.select(db.users)..where((t) => t.id.equals(userId)))
      .getSingleOrNull();
});

/// Кто сейчас вошёл. `null` — никто (показываем экран входа/регистрации).
/// Последний профиль запоминается в SharedPreferences, чтобы при
/// перезапуске сразу открыть приложение, а не гонять через выбор.
class SessionController extends AsyncNotifier<String?> {
  static const _prefsKey = 'michi.lastUserId';

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_prefsKey);
    if (id == null) return null;
    final exists = await ref.read(authRepositoryProvider).profileExists(id);
    return exists ? id : null;
  }

  Future<void> signIn(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, userId);
    await ref.read(authRepositoryProvider).touchLastActive(userId);
    // profileProvider / currentUserProvider читают sessionProvider —
    // Riverpod пересоберёт их сам при смене состояния. Инвалидировать их
    // отсюда нельзя: получается цикл (sessionProvider зависит от себя).
    state = AsyncData(userId);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    state = const AsyncData(null);
  }
}

final sessionProvider =
    AsyncNotifierProvider<SessionController, String?>(SessionController.new);

/// Профиль (настройки) текущего пользователя. Пересобирается при смене
/// сессии; экран настроек инвалидирует его после каждого изменения.
final profileProvider = FutureProvider<UserProfileData?>((ref) async {
  final userId = ref.watch(sessionProvider).value;
  if (userId == null) return null;
  final db = ref.watch(dbProvider);
  return (db.select(db.userProfile)..where((t) => t.userId.equals(userId)))
      .getSingleOrNull();
});

/// Тема приложения из профиля (или системная, когда никто не вошёл).
final themeModeProvider = Provider<ThemeMode>((ref) {
  final profile = ref.watch(profileProvider).value;
  return switch (profile?.themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});
