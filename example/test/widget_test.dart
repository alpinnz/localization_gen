import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_gen_example/main.dart';

void main() {
  testWidgets('Example app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalizationExampleApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(ExampleHomePage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Keep this as a pure smoke test. Text expectations are covered in main_test.dart.
  });
}
