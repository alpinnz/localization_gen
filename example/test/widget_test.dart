import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_gen_example/main.dart';

void main() {
  testWidgets('Example app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalizationExampleApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(ExampleHomePage), findsOneWidget);

    // Smoke-check: app title exists in the AppBar.
    expect(find.byType(AppBar), findsOneWidget);
  });
}
