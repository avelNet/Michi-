// Смоук-тест: дерево приложения собирается. Полный путь (открытие БД,
// онбординг, оболочка) проверяется `flutter run` на Windows — в юнит-
// тесте нет плагина path_provider, поэтому контент-провайдер тут
// ожидаемо падает в ошибку, а не грузится.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:michi/main.dart';

void main() {
  testWidgets('App builds a MaterialApp', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MichiApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
