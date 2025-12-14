import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:monorepo_app/main.dart';
import 'package:monorepo_app/assets/app_localizations.dart';

void main() {
  group('Monorepo App Basic Tests', () {
    testWidgets('App loads with default English locale', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MonorepoHomePage), findsOneWidget);
      expect(find.text('Monorepo Architecture'), findsAtLeastNWidgets(1));
    });

    testWidgets('Language can be changed to Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(find.text('Monorepo Architecture'), findsAtLeastNWidgets(1));
    });

    testWidgets('Language menu shows checkmark', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsAtLeastNWidgets(1));
    });
  });

  group('Package Cards Tests', () {
    testWidgets('Both package cards are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('App Package'), findsOneWidget);
      expect(find.text('Core Package'), findsOneWidget);
      expect(find.byType(PackageCard), findsNWidgets(2));
    });

    testWidgets('Architecture banner is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Monorepo Architecture'), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.account_tree), findsOneWidget);
      expect(find.textContaining('Multi-package project structure'), findsOneWidget);
    });
  });

  group('App Package Tests', () {
    testWidgets('App Package displays auth module', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Auth Module'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsAtLeastNWidgets(1));
    });

    testWidgets('App Package displays home module', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Home Module'), findsOneWidget);
      expect(find.text('Welcome to Localization Gen!'), findsOneWidget);
      expect(find.text('Welcome, Bob!'), findsOneWidget);
    });

    testWidgets('App Package displays settings module', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('Settings Module'), findsOneWidget);
      expect(find.textContaining('Profile:'), findsOneWidget);
      expect(find.textContaining('Language:'), findsOneWidget);
    });

    testWidgets('App Package in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(find.text('Masuk'), findsAtLeastNWidgets(1));
      expect(find.text('Selamat datang di Localization Gen!'), findsOneWidget);
    });
  });

  group('Core Package Tests', () {
    testWidgets('Core Package is active and working', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Core Package Active!'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Core Package Active!'), findsOneWidget);
      expect(find.textContaining('CoreLocalizations generated and active'), findsOneWidget);
    });

    testWidgets('Core Package widgets module shown with actual localization', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Widgets Module'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Widgets Module'), findsOneWidget);
      expect(find.textContaining('loading: "Loading..."'), findsOneWidget);
      expect(find.textContaining('error: "An error occurred"'), findsOneWidget);
      expect(find.textContaining('retry: "Retry"'), findsOneWidget);
    });

    testWidgets('Core Package buttons module shown with Chips', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Buttons Module'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Buttons Module'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsAtLeastNWidgets(1)); // May appear in other places
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Core Package buttons in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      // Change to Indonesian
      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Simpan'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Simpan'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
    });
  });

  group('Benefits Card Tests', () {
    testWidgets('Benefits card is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Monorepo Benefits'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Monorepo Benefits'), findsOneWidget);
      expect(find.text('✓ Independent package management'), findsOneWidget);
      expect(find.text('✓ Scalable for enterprise applications'), findsOneWidget);
    });
  });

  group('UI Interaction Tests', () {
    testWidgets('Can scroll through content', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      await tester.drag(scrollView, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byType(PackageCard), findsWidgets);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Monorepo Architecture'), findsOneWidget);
    });

    testWidgets('Module section headers display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byType(ModuleSectionHeader), findsWidgets);
      expect(find.text('Auth Module'), findsOneWidget);
      expect(find.text('Home Module'), findsOneWidget);
      expect(find.text('Settings Module'), findsOneWidget);
    });

    testWidgets('Package cards show correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.phone_android), findsOneWidget);
      expect(find.byIcon(Icons.extension), findsOneWidget);
    });
  });

  group('AppLocalizations Tests', () {
    testWidgets('AppLocalizations works correctly', (WidgetTester tester) async {
      AppLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n, isNotNull);
      expect(l10n!.login.title, 'Login');
      expect(l10n!.welcome, 'Welcome to Localization Gen!');
      expect(l10n!.profile.title, 'Profile');
    });

    test('Supported locales includes en and id', () {
      expect(AppLocalizations.supportedLocales.length, greaterThanOrEqualTo(2));
      final languageCodes = AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .toList();
      expect(languageCodes, containsAll(['en', 'id']));
    });
  });

  group('Monorepo Structure Tests', () {
    testWidgets('App and Core packages are clearly separated', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.text('App Package'), findsOneWidget);
      expect(find.text('Main Application'), findsOneWidget);
      expect(find.text('Core Package'), findsOneWidget);
      expect(find.text('Shared Library'), findsOneWidget);
    });

    testWidgets('File structure is documented', (WidgetTester tester) async {
      await tester.pumpWidget(const MonorepoApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('app_auth_en.json'), findsOneWidget);
      expect(find.textContaining('core_widgets_en.json'), findsOneWidget);
    });
  });
}

