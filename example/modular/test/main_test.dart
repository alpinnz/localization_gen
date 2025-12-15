import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:modular_example/main.dart';
import 'package:modular_example/assets/app_localizations.dart';

void main() {
  group('Modular App Basic Tests', () {
    testWidgets('App loads with default English locale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ModularHomePage), findsOneWidget);
      expect(find.text('Modular Organization'), findsOneWidget);
    });

    testWidgets('Language can be changed to Indonesian', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(find.text('Modular Organization'), findsOneWidget);
    });

    testWidgets('Language menu shows checkmark', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
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

  group('Module Cards Tests', () {
    testWidgets('All module cards are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Auth Module'), findsOneWidget);
      expect(find.text('Home Module'), findsOneWidget);
      expect(find.text('Common Module'), findsOneWidget);
      expect(find.text('Settings Module'), findsOneWidget);
    });

    testWidgets('Module cards show file names', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('📁 app_auth_en.json'), findsOneWidget);
      expect(find.text('📁 app_home_en.json'), findsOneWidget);
      expect(find.text('📁 app_common_en.json'), findsOneWidget);
      expect(find.text('📁 app_settings_en.json'), findsOneWidget);
    });
  });

  group('Auth Module Tests', () {
    testWidgets('Auth module displays login form', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsAtLeastNWidgets(1));
      expect(find.text('Password'), findsAtLeastNWidgets(1));
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Auth module shows error messages', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Invalid email address'), findsOneWidget);
      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('Auth module in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
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
      expect(find.text('Alamat email tidak valid'), findsOneWidget);
    });
  });

  group('Home Module Tests', () {
    testWidgets('Home module displays content', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Localization Gen!'), findsOneWidget);
      expect(find.text('Welcome, Alice!'), findsOneWidget);
      expect(find.text('You have 15 items'), findsOneWidget);
      expect(find.text('Discount 25%'), findsOneWidget);
    });

    testWidgets('Home module in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(find.text('Selamat datang di Localization Gen!'), findsOneWidget);
      expect(find.text('Selamat datang, Alice!'), findsOneWidget);
      expect(find.text('Anda memiliki 15 item'), findsOneWidget);
      expect(find.text('Diskon 25%'), findsOneWidget);
    });
  });

  group('Common Module Tests', () {
    testWidgets('Common module displays chips', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Common module in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(find.text('Halo'), findsOneWidget);
      expect(find.text('Ya'), findsOneWidget);
      expect(find.text('Tidak'), findsOneWidget);
      expect(find.text('Simpan'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);
    });
  });

  group('Settings Module Tests', () {
    testWidgets('Settings module displays options', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Profile'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsAtLeastNWidgets(1));
    });

    testWidgets('Settings module in Indonesian', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Profil'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Edit Profil'), findsOneWidget);
      expect(find.text('Tema'), findsOneWidget);
      expect(find.text('Bahasa'), findsAtLeastNWidgets(1));
    });
  });

  group('UI Tests', () {
    testWidgets('Can scroll through content', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      await tester.drag(scrollView, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byType(ModuleCard), findsWidgets);
    });

    testWidgets('AppBar displays title', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AppBar, 'Modular Localization'),
        findsOneWidget,
      );
    });

    testWidgets('Module cards show icons', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.widgets), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('AppLocalizations Tests', () {
    testWidgets('AppLocalizations works correctly', (
      WidgetTester tester,
    ) async {
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
      expect(l10n!.hello, 'Hello');
      expect(l10n!.login.title, 'Login');
      expect(l10n!.welcome, 'Welcome to Localization Gen!');
    });

    test('Supported locales includes en and id', () {
      expect(AppLocalizations.supportedLocales.length, greaterThanOrEqualTo(2));
      final languageCodes = AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .toList();
      expect(languageCodes, containsAll(['en', 'id']));
    });
  });
}
