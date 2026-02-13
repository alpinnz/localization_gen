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

  expect(
    target,
    findsWidgets,
    reason: 'Target widget not found after scrolling.',
  );
}

Finder _primaryScrollable() {
  // Prefer the main ListView's Scrollable over any nested/implicit Scrollables.
  return find.byType(Scrollable).first;
}

Finder _languageMenuButton() {
  return find.descendant(
    of: find.byType(AppBar),
    matching: find.byType(PopupMenuButton<Locale>),
  );
}

Future<void> _switchToIndonesian(WidgetTester tester) async {
  await tester.tap(_languageMenuButton());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Indonesia'));
  await tester.pumpAndSettle();
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

        // English baseline
        expect(find.textContaining('Demo App'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Hello'), findsAtLeastNWidgets(1));

        await _switchToIndonesian(tester);

        // Indonesian content should appear
        expect(find.textContaining('Aplikasi Demo'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Halo'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('shows resolveByKey and multi-variant error cases', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const LocalizationExampleApp());
      await tester.pumpAndSettle();

      final list = _primaryScrollable();

      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Runtime key lookup (resolveByKey)'),
      );

      expect(
        find.textContaining("resolveByKey('strings.app_title'):"),
        findsAtLeastNWidgets(1),
      );

      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text(
          'Multi-variant errors (context: register/verification)',
        ),
      );

      // EN texts
      expect(
        find.textContaining('Wrong Register Code'),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.textContaining('Verification OTP expired'),
        findsAtLeastNWidgets(1),
      );

      // Switch to Indonesian
      await _switchToIndonesian(tester);

      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text('Runtime key lookup (resolveByKey)'),
      );
      expect(find.textContaining('Aplikasi Demo'), findsAtLeastNWidgets(1));

      await _scrollUntilVisible(
        tester,
        scrollable: list,
        target: find.text(
          'Multi-variant errors (context: register/verification)',
        ),
      );

      // ID texts
      expect(
        find.textContaining('Kode registrasi salah'),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.textContaining('Kadarluasa verifikasi OTP'),
        findsAtLeastNWidgets(1),
      );
    });
  });
}
