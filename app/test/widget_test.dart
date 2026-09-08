// Смоук-тест Фазы 1: приложение стартует и показывает экран проверки БД.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:michi/main.dart';

void main() {
  // Полный путь (открытие БД через path_provider + Drift-изолят) требует
  // настоящей платформы и проверяется сборкой `flutter build windows` +
  // реальным запуском .exe, а не голым `flutter test` (там нет платформенного
  // канала path_provider). Здесь — только то, что честно тестируется в VM:
  // первый кадр рендерится и показывает индикатор загрузки.
  testWidgets('App starts and shows the loading screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MichiApp());

    expect(find.text('Проверка базы данных (Фаза 1)'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
