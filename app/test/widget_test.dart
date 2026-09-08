// Смоук-тест: приложение стартует и первый кадр рендерится
// (полный путь с открытием БД проверяется `flutter build windows` +
// реальным запуском — см. docs/environment-setup.md).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:michi/main.dart';

void main() {
  testWidgets('App starts and shows the loading indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MichiApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
