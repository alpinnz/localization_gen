import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_example/main.dart';

void main() {
  group('Modular Example Tests', () {
    testWidgets('App loads successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ModularHomePage), findsOneWidget);
    });

    testWidgets('Architecture banner is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.text('Modular Organization'), findsOneWidget);
      expect(
        find.textContaining('Translations organized by feature modules'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.account_tree), findsOneWidget);
    });

    testWidgets('All module cards are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Check for all 4 modules
      expect(find.text('Auth Module'), findsOneWidget);
      expect(find.text('Home Module'), findsOneWidget);
      expect(find.text('Common Module'), findsOneWidget);
      expect(find.text('Settings Module'), findsOneWidget);
    });

    testWidgets('Module file names are shown', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Check for file indicators
      expect(find.text('📁 app_auth_en.json'), findsOneWidget);
      expect(find.text('📁 app_home_en.json'), findsOneWidget);
      expect(find.text('📁 app_common_en.json'), findsOneWidget);
      expect(find.text('📁 app_settings_en.json'), findsOneWidget);
    });

    testWidgets('Module icons are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Check for module-specific icons
      expect(find.byIcon(Icons.lock), findsOneWidget); // Auth
      expect(find.byIcon(Icons.home), findsOneWidget); // Home
      expect(find.byIcon(Icons.widgets), findsOneWidget); // Common
      expect(find.byIcon(Icons.settings), findsOneWidget); // Settings
    });

    testWidgets('Auth module content is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Auth module translations
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Auth error messages are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Error messages from auth module
      expect(find.text('Invalid email address'), findsOneWidget);
      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('Home module content is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Home module translations with parameters
      expect(
        find.textContaining('Welcome to Localization Gen!'),
        findsOneWidget,
      );
      expect(find.textContaining('Welcome, Alice!'), findsOneWidget);
      expect(find.textContaining('15 items'), findsOneWidget);
      expect(find.textContaining('Discount 25%'), findsOneWidget);
    });

    testWidgets('Common module chips are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Common module chips
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Settings module content is displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Settings module translations
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('Language dialog can be opened', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Tap language icon
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
    });

    testWidgets('Language can be changed to Indonesian',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Open language dialog
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Tap Indonesian
      await tester.tap(find.text('Indonesia').last);
      await tester.pumpAndSettle();

      // Verify translations changed to Indonesian
      expect(find.text('Masuk'), findsOneWidget); // "Login" in Indonesian
      expect(find.text('Halo'), findsOneWidget); // "Hello" in Indonesian
    });

    testWidgets('ModuleCard widget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Check ModuleCard structure
      expect(find.byType(ModuleCard), findsNWidgets(4));
    });

    testWidgets('Error chips have correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Error icon should be present
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('All modules are scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Should have ListView
      expect(find.byType(ListView), findsOneWidget);

      // Scroll to bottom
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Settings module should still be visible
      expect(find.text('Settings Module'), findsOneWidget);
    });

    testWidgets('Parameterized translations work in home module',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      // Check parameterized translations
      expect(find.textContaining('Alice'), findsOneWidget);
      expect(find.textContaining('15'), findsOneWidget);
      expect(find.textContaining('25%'), findsOneWidget);
    });

    testWidgets('Cards have proper elevation', (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      final cards = tester.widgetList<Card>(find.byType(Card));
      for (final card in cards) {
        expect(card.elevation, greaterThan(0));
      }
    });
  });

  group('Modular Widgets Tests', () {
    testWidgets('AuthModuleWidget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(AuthModuleWidget), findsOneWidget);
    });

    testWidgets('HomeModuleWidget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeModuleWidget), findsOneWidget);
    });

    testWidgets('CommonModuleWidget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(CommonModuleWidget), findsOneWidget);
    });

    testWidgets('SettingsModuleWidget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ModularLocalizationApp());
      await tester.pumpAndSettle();

      expect(find.byType(SettingsModuleWidget), findsOneWidget);
    });
  });
}

