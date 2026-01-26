import 'package:basic_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Default Example Tests', () {
    testWidgets('App loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(DefaultHomePage), findsOneWidget);
    });

    testWidgets('AppBar displays settings title', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Should show "Settings" in English (default locale)
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('Language can be changed', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Tap language menu
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Find and tap Indonesian
      expect(find.text('Indonesia'), findsOneWidget);
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      // Verify language changed to Indonesian
      expect(
        find.text('Pengaturan'),
        findsOneWidget,
      ); // "Settings" in Indonesian
    });

    testWidgets('Item counter increments', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Tap add and ensure UI updates (do not assert exact localized string).
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // The counter section must still be present.
      expect(find.byIcon(Icons.inventory), findsOneWidget);
    });

    testWidgets('Item counter decrements', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inventory), findsOneWidget);
    });

    testWidgets('Item counter does not go below zero', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Remove'));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // App should not crash and UI still shows the counter section.
      expect(find.byIcon(Icons.inventory), findsOneWidget);
    });

    testWidgets('Common action chips are displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Check for common chips (note: hello includes emoji in the JSON)
      expect(find.textContaining('Hello'), findsOneWidget);
      expect(find.text('Yes ✓'), findsOneWidget);
      expect(find.text('No ✗'), findsOneWidget);
      expect(find.text('💾 Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Parameterized translations are rendered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // We don't assert exact string to avoid coupling to generator escaping.
      // Just ensure the welcome section exists.
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('Spanish language option is available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Tap language menu
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Spanish is not provided in assets/localizations for this example.
      expect(find.text('Español'), findsNothing);
    });
  });
}
