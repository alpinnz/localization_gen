import 'package:test/test.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:localization_gen/src/model/localization_item.dart';

void main() {
  group('DartWriter Symbol Escaping', () {
    test('escapes single quotes correctly', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'test': LocalizationItem(
              key: 'test',
              value: "It's working",
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      // The generated Dart source includes an escaped apostrophe: It\\'s
      // and the test string needs to match the full generated output.
      expect(output, contains("'It\\\\\\\\'s working'"));
    });

    test('escapes dollar signs correctly', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'price': LocalizationItem(
              key: 'price',
              value: 'Price: \$100',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      // In encoded output text, this shows up as `\\$`.
      expect(output, contains(r"'Price: \\$100'"));
    });

    test('escapes backslashes correctly', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'path': LocalizationItem(
              key: 'path',
              value: 'Path: C:\\Users\\test',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'Path: C:\\\\Users\\\\test'"));
    });

    test('preserves emojis', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'emoji': LocalizationItem(
              key: 'emoji',
              value: 'Hello! 👋 🎉 ❤️',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'Hello! 👋 🎉 ❤️'"));
    });

    test('preserves special symbols', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'symbols': LocalizationItem(
              key: 'symbols',
              value: '© ® ™ € £ ¥ § ¶',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'© ® ™ € £ ¥ § ¶'"));
    });

    test('preserves unicode characters', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'chinese': LocalizationItem(
              key: 'chinese',
              value: '你好世界',
              parameters: [],
            ),
            'japanese': LocalizationItem(
              key: 'japanese',
              value: 'こんにちは',
              parameters: [],
            ),
            'korean': LocalizationItem(
              key: 'korean',
              value: '안녕하세요',
              parameters: [],
            ),
            'arabic': LocalizationItem(
              key: 'arabic',
              value: 'مرحبا',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'你好世界'"));
      expect(output, contains("'こんにちは'"));
      expect(output, contains("'안녕하세요'"));
      expect(output, contains("'مرحبا'"));
    });

    test('handles complex mixed content', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'complex': LocalizationItem(
              key: 'complex',
              value: "It's \$100 with C:\\path and emoji 👋",
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains(r"'It\\\\'s \\$100 with C:\\path and emoji 👋'"));
    });

    test('preserves special chars in nested structures', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'common.special': LocalizationItem(
              key: 'common.special',
              value: 'Special: @#\$%^&*()_+-=[]{}|;\':",./<>?',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);

      expect(output, contains("String get special"));
      // `$` is escaped in the generated output text as `\\$`.
      expect(output, contains(r"Special: @#\\$%"));
      expect(output, contains(",./<>?"));
    });

    test('preserves math symbols', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'math': LocalizationItem(
              key: 'math',
              value: '2 + 2 = 4, 10 × 5 = 50, π ≈ 3.14, ∞',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'2 + 2 = 4, 10 × 5 = 50, π ≈ 3.14, ∞'"));
    });

    test('preserves arrows and geometric symbols', () {
      final writer = DartWriter(className: 'TestLocalizations');
      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'arrows': LocalizationItem(
              key: 'arrows',
              value: '← → ↑ ↓ ↔ ↕ ⇐ ⇒',
              parameters: [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);
      expect(output, contains("'← → ↑ ↓ ↔ ↕ ⇐ ⇒'"));
    });
  });
}
