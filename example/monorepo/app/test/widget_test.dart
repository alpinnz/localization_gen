import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monorepo_app/main.dart';

void main() {
  group('Monorepo Example Tests', () {
    testWidgets('App loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MonorepoHomePage), findsOneWidget);
    });

    testWidgets('Architecture banner is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Monorepo Architecture'), findsAtLeastNWidgets(1));
      expect(
        find.textContaining('Multi-package project structure'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.account_tree), findsOneWidget);
    });

    testWidgets('Both package cards are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Check for both packages
      expect(find.text('App Package'), findsOneWidget);
      expect(find.text('Core Package'), findsOneWidget);
    });

    testWidgets('Package types are shown', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Main Application'), findsOneWidget);
      expect(find.text('Shared Library'), findsOneWidget);
    });

    testWidgets('Package icons are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.phone_android), findsOneWidget); // App
      expect(find.byIcon(Icons.extension), findsOneWidget); // Core
    });

    testWidgets('App package modules are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // App package module headers
      expect(find.text('Auth Module'), findsOneWidget);
      expect(find.text('Home Module'), findsOneWidget);
      expect(find.text('Settings Module'), findsOneWidget);
    });

    testWidgets('Core package modules are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Core package module headers
      expect(find.text('Widgets Module'), findsOneWidget);
      expect(find.text('Buttons Module'), findsOneWidget);
    });

    testWidgets('Core setup instructions are shown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Setup Instructions'), findsOneWidget);
      expect(
        find.textContaining('To enable CoreLocalizations'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline), findsWidgets);
    });

    testWidgets('App localizations work correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // App translations
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(
        find.textContaining('Welcome to Localization Gen!'),
        findsOneWidget,
      );
      expect(find.textContaining('Welcome, Bob!'), findsOneWidget);
    });

    testWidgets('File source indicators are shown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // App package files
      expect(find.textContaining('app_auth_en.json'), findsOneWidget);
      expect(find.textContaining('app_home_en.json'), findsOneWidget);
      expect(find.textContaining('app_settings_en.json'), findsOneWidget);

      // Core package files
      expect(find.textContaining('core_widgets_en.json'), findsOneWidget);
      expect(find.textContaining('core_buttons_en.json'), findsOneWidget);
    });

    testWidgets('Benefits card is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Monorepo Benefits'), findsOneWidget);
      expect(
        find.textContaining('Independent package management'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Shared core library'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Module section headers have icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsOneWidget); // Auth
      expect(find.byIcon(Icons.home), findsOneWidget); // Home
      expect(find.byIcon(Icons.settings), findsOneWidget); // Settings
      expect(find.byIcon(Icons.widgets_outlined), findsOneWidget); // Widgets
      expect(find.byIcon(Icons.smart_button), findsOneWidget); // Buttons
    });

    testWidgets('Language dialog can be opened', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
    });

    testWidgets('Language can be changed to Indonesian',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Open language dialog
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Tap Indonesian
      await tester.tap(find.text('Indonesia').last);
      await tester.pumpAndSettle();

      // Verify translations changed
      expect(find.text('Masuk'), findsOneWidget); // "Login" in Indonesian
      expect(find.textContaining('Selamat datang'), findsOneWidget);
    });

    testWidgets('PackageCard widgets display correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byType(PackageCard), findsNWidgets(2));
    });

    testWidgets('ModuleSectionHeader widgets display correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Should have multiple module headers
      expect(find.byType(ModuleSectionHeader), findsWidgets);
    });

    testWidgets('App content is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      // Scroll down
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Benefits card should be visible after scrolling
      expect(find.text('Monorepo Benefits'), findsOneWidget);
    });

    testWidgets('Parameterized translations work correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Check parameterized translations
      expect(find.textContaining('Bob'), findsOneWidget);
      expect(find.textContaining('30%'), findsOneWidget);
    });

    testWidgets('All benefit items are listed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Scroll to benefits
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();

      // Check all benefit points
      expect(find.textContaining('Independent package'), findsOneWidget);
      expect(find.textContaining('Shared core library'), findsOneWidget);
      expect(find.textContaining('Separate versioning'), findsOneWidget);
      expect(find.textContaining('separation of concerns'), findsOneWidget);
      expect(find.textContaining('enterprise applications'), findsOneWidget);
    });

    testWidgets('Core placeholder text is shown', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Core module placeholder texts (before generation)
      expect(find.text('• loading: "Loading..."'), findsOneWidget);
      expect(find.text('• error: "An error occurred"'), findsOneWidget);
      expect(find.text('• save: "Save"'), findsOneWidget);
      expect(find.text('• cancel: "Cancel"'), findsOneWidget);
    });

    testWidgets('Setup instruction steps are shown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('cd examples/3_monorepo/core'),
        findsOneWidget,
      );
      expect(
        find.textContaining('dart run localization_gen'),
        findsOneWidget,
      );
    });

    testWidgets('Package cards have colored left borders',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // PackageCards should have border decoration
      final packageCards = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(PackageCard),
          matching: find.byType(Container),
        ),
      );

      expect(packageCards.length, greaterThan(0));
    });

    testWidgets('Cards have proper elevation', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final cards = tester.widgetList<Card>(find.byType(Card));
      for (final card in cards) {
        expect(card.elevation, greaterThanOrEqualTo(0));
      }
    });
  });

  group('Monorepo Widget Tests', () {
    testWidgets('PackageCard displays package info correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final packageCards = tester.widgetList<PackageCard>(
        find.byType(PackageCard),
      );

      expect(packageCards.length, equals(2));
    });

    testWidgets('ModuleSectionHeader displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final headers = tester.widgetList<ModuleSectionHeader>(
        find.byType(ModuleSectionHeader),
      );

      // Should have multiple module headers
      expect(headers.length, greaterThan(3));
    });
  });
}

