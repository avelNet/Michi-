import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:michi/app/providers.dart';
import 'package:michi/data/database.dart';
import 'package:michi/features/auth/register_screen.dart';
import 'package:michi/features/onboarding/onboarding_screen.dart';
import 'package:michi/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Прогон реального UI: первый запуск → регистрация → онбординг →
/// оболочка. Контент-сид отключён, БД — в памяти. Окно — как у реального
/// десктопа (иначе кнопки уходят за нижний край тест-поверхности).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final b = TestWidgetsFlutterBinding.instance;
    b.platformDispatcher.views.first.physicalSize = const Size(1400, 950);
    b.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
        .resetPhysicalSize();
  });

  Widget app(AppDatabase db) => ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          contentReadyProvider.overrideWith((ref) async {}),
        ],
        child: const MichiApp(),
      );

  testWidgets('первый запуск: регистрация ведёт в онбординг, оболочка после',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(app(db));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Авель');
    await tester.tap(find.text('Создать и продолжить'));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Дальше'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Начать учиться'));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('Статистика'), findsWidgets);
    expect(find.text('Повторение'), findsWidgets);
  });

  testWidgets('перезапуск с сохранённой сессией: сразу оболочка', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    final id = await c.read(authRepositoryProvider).register(name: 'Ре');
    await c.read(authRepositoryProvider).markOnboarded(id);
    c.dispose();

    SharedPreferences.setMockInitialValues({'michi.lastUserId': id});
    await tester.pumpWidget(app(db));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('Статистика'), findsWidgets);
  });
}
