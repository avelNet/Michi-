import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:michi/app/providers.dart';
import 'package:michi/data/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Регрессия на CircularDependencyError: регистрация → вход → чтение
/// профиля и пользователя должны отработать без цикла провайдеров.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('register → signIn → профиль и пользователь резолвятся', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(overrides: [
      dbProvider.overrideWithValue(db),
    ]);
    addTearDown(container.dispose);

    final id = await container
        .read(authRepositoryProvider)
        .register(name: 'Тест', pin: null);

    await container.read(sessionProvider.notifier).signIn(id);

    expect(container.read(sessionProvider).value, id);

    final user = await container.read(currentUserProvider.future);
    expect(user, isNotNull);
    expect(user!.id, id);
    expect(user.onboardedAt, isNull); // онбординг ещё впереди

    final profile = await container.read(profileProvider.future);
    expect(profile, isNotNull);
    expect(profile!.userId, id);

    // Выход — сессия очищается, зависимые провайдеры возвращают null.
    await container.read(sessionProvider.notifier).signOut();
    expect(container.read(sessionProvider).value, isNull);
    expect(await container.read(currentUserProvider.future), isNull);
    expect(await container.read(profileProvider.future), isNull);
  });

  test('вход по PIN: верный проходит, неверный — нет', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    final repo = container.read(authRepositoryProvider);
    final id = await repo.register(name: 'Пин', pin: '1234');

    expect(await repo.verifyPin(id, '1234'), isTrue);
    expect(await repo.verifyPin(id, '0000'), isFalse);
  });
}
