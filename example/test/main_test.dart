import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_gen_example/main.dart';

Future<void> _scrollUntilVisible(
  WidgetTester tester, {
  required Finder scrollable,
  required Finder target,
  double delta = 300,
  int maxScrolls = 30,
}) async {
  for (var i = 0; i < maxScrolls; i++) {
    if (target.evaluate().isNotEmpty) {
      return;
    }
    await tester.drag(scrollable, Offset(0, -delta));
    await tester.pumpAndSettle();
  }

  // Final check with a clearer failure.
  expect(target, findsWidgets,
      reason: 'Target widget not found after scrolling.');
}

void main() {
  group('Example app', () {
    testWidgets('renders main UI', (WidgetTester tester) async {
      await tester.pumpWidget(const LocalizationExampleApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ExampleHomePage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets(
      'can switch locale to Indonesian and shows Indonesian strings',
      (WidgetTester tester) async {
        await tester.pumpWidget(const LocalizationExampleApp());
        await tester.pumpAndSettle();

        final languageButton = find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(PopupMenuButton<Locale>),
        );
        await tester.tap(languageButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Indonesia'));
        await tester.pumpAndSettle();

        // Text widgets in the list include these substrings after switching.
        expect(find.textContaining('Aplikasi Demo'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Halo'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('shows resolveByKey and multi-variant error cases',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LocalizationExampleApp());
      await tester.pumpAndSettle();

      final list = find.byType(Scrollable);

      // Scroll to the runtime lookup section (ListView is long; items may be lazy).
      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Runtime key lookup (resolveByKey)'),
      );

      // EN: resolveByKey should return the English title.
      expect(
        find.textContaining("resolveByKey('strings.app_title'):"),
        findsAtLeastNWidgets(1),
      );

      // Scroll to the multi-variant errors section.
      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Multi-variant errors (context: register/verification)'),
      );

      // EN: multi-variant error strings
      expect(
        find.textContaining('Wrong Register Code'),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.textContaining('Verification OTP expired'),
        findsAtLeastNWidgets(1),
      );

      // Switch to Indonesian
      final languageButton = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(PopupMenuButton<Locale>),
      );
      await tester.tap(languageButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      // Scroll again (content might have shifted).
      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Runtime key lookup (resolveByKey)'),
      );

      // ID: resolveByKey should return the Indonesian title.
      expect(find.textContaining('Aplikasi Demo'), findsAtLeastNWidgets(1));

      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Multi-variant errors (context: register/verification)'),
      );

      // ID: multi-variant error strings (register/verification)
      expect(find.textContaining('Kode registrasi salah'),
          findsAtLeastNWidgets(1));
      expect(find.textContaining('Kadarluasa verifikasi OTP'),
          findsAtLeastNWidgets(1));
    });
  });
}
