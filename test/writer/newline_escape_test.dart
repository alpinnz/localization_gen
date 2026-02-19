import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:test/test.dart';

void main() {
  group('Writer: newline escaping', () {
    test('preserves literal \\n sequence from JSON (backslash + n)', () {
      final writer = DartWriter(className: 'TestLocalizations');

      const value = r'Your account is temporarily locked.\nYou can try again.';

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'locked_message': LocalizationItem(
              key: 'locked_message',
              value: value,
              parameters: const [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);

      // The generated Dart source must contain a single escaped \n, not \\n.
      expect(output, contains(r"temporarily locked.\\nYou can try again."));
      expect(output,
          isNot(contains(r"temporarily locked.\\\\nYou can try again.")));
    });

    test('converts real newline characters to \\n escape in generated Dart',
        () {
      final writer = DartWriter(className: 'TestLocalizations');

      const value = 'Line1\nLine2'; // actual newline character

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'multiline': LocalizationItem(
              key: 'multiline',
              value: value,
              parameters: const [],
            ),
          },
        ),
      ];

      final output = writer.generate(locales);

      // In generated source it should be escaped as two chars: backslash+n
      expect(output, contains('"Line1\\nLine2"'));
    });
  });
}
