import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:core/assets/core_localizations.dart';

void main() {
  group('CoreLocalizations Tests', () {
    testWidgets('CoreLocalizations can be accessed', (
      WidgetTester tester,
    ) async {
      CoreLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            CoreLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: CoreLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = CoreLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n, isNotNull);
    });

    test('Supported locales includes en and id', () {
      expect(
        CoreLocalizations.supportedLocales.length,
        greaterThanOrEqualTo(2),
      );
      final languageCodes = CoreLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .toList();
      expect(languageCodes, containsAll(['en', 'id']));
    });
  });

  group('Buttons Module Tests', () {
    testWidgets('English button texts are correct', (
      WidgetTester tester,
    ) async {
      CoreLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            CoreLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: CoreLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = CoreLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n!.save, 'Save');
      expect(l10n!.cancel, 'Cancel');
      expect(l10n!.delete, 'Delete');
      expect(l10n!.confirm, 'Confirm');
    });

    testWidgets('Indonesian button texts are correct', (
      WidgetTester tester,
    ) async {
      CoreLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: const [
            CoreLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: CoreLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = CoreLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n!.save, 'Simpan');
      expect(l10n!.cancel, 'Batal');
      expect(l10n!.delete, 'Hapus');
      expect(l10n!.confirm, 'Konfirmasi');
    });
  });

  group('Widgets Module Tests', () {
    testWidgets('English widget texts are correct', (
      WidgetTester tester,
    ) async {
      CoreLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            CoreLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: CoreLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = CoreLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n!.loading, 'Loading...');
      expect(l10n!.error, 'An error occurred');
      expect(l10n!.retry, 'Retry');
      expect(l10n!.no_data, 'No data available');
    });

    testWidgets('Indonesian widget texts are correct', (
      WidgetTester tester,
    ) async {
      CoreLocalizations? l10n;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: const [
            CoreLocalizationsExtension.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: CoreLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = CoreLocalizations.of(context);
              return const Scaffold();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n!.loading, 'Memuat...');
      expect(l10n!.error, 'Terjadi kesalahan');
      expect(l10n!.retry, 'Coba Lagi');
      expect(l10n!.no_data, 'Tidak ada data');
    });
  });
}
