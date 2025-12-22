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

      // Initial count should be 5
      expect(find.textContaining('5 items'), findsOneWidget);

      // Find add button by text
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Count should be 6
      expect(find.textContaining('6 items'), findsOneWidget);
    });

    testWidgets('Item counter decrements', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Initial count should be 5
      expect(find.textContaining('5 items'), findsOneWidget);

      // Find remove button by text
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Count should be 4
      expect(find.textContaining('4 items'), findsOneWidget);
    });

    testWidgets('Item counter does not go below zero', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Tap remove 10 times
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Remove'));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Should be 0, not negative
      expect(find.textContaining('0 items'), findsOneWidget);
    });

    testWidgets('All translation sections are displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Check for main sections
      expect(find.byIcon(Icons.home), findsOneWidget); // Welcome section
      expect(find.byIcon(Icons.inventory), findsOneWidget); // Item counter
      expect(find.byIcon(Icons.login), findsOneWidget); // Auth section
      expect(find.byIcon(Icons.apps), findsOneWidget); // Common actions
    });

    testWidgets('Login fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Should have email and password fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('Common action chips are displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Check for common chips
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Info banner is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Default (Monolithic) Approach'), findsOneWidget);
      expect(find.textContaining('One JSON file per locale'), findsOneWidget);
    });

    testWidgets('Parameterized translations work correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Check welcome_user with parameter
      expect(find.textContaining('Welcome, John Doe!'), findsOneWidget);

      // Check discount with parameter
      expect(find.textContaining('Discount 20%'), findsOneWidget);
    });

    testWidgets('Spanish language option is available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const DefaultLocalizationApp());
      await tester.pumpAndSettle();

      // Tap language menu
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Should have Spanish option
      expect(find.text('Español'), findsOneWidget);
    });
  });
}
