import 'package:test/test.dart';

import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';

void main() {
  group('Newline semantics', () {
    test('keeps newline escape as \\n in generated Dart source when input contains a newline character', () {
      final writer = DartWriter(className: 'TestLocalizations');

      // This string contains a real newline character.
      const valueWithNewlineChar = 'Line1\nLine2';

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'msg': LocalizationItem(key: 'msg', value: valueWithNewlineChar, parameters: []),
          },
        ),
      ];

      final output = writer.generate(locales);
      // The generated Dart source must contain a single-line literal with \n escape.
      expect(output, contains("return 'Line1\\nLine2';"));
    });

    test('keeps literal backslash-n as \\\\n in generated Dart source when input contains two characters \\\\ + n', () {
      final writer = DartWriter(className: 'TestLocalizations');

      // This string contains two characters: backslash and n.
      const valueWithLiteralBackslashN = r'Line1\\nLine2';

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'msg': LocalizationItem(key: 'msg', value: valueWithLiteralBackslashN, parameters: []),
          },
        ),
      ];

      final output = writer.generate(locales);
      // In Dart source, a single backslash must be escaped, so it becomes \\n      // and because the value already contains a backslash, it becomes \\\\n in source.
      expect(output, contains(r"return 'Line1\\\\nLine2';"));
    });

    test('example string with security lock message preserves \\n exactly', () {
      final writer = DartWriter(className: 'TestLocalizations');

      // Real-world example from the report.
      const message =
          'Your account is temporarily locked for 15 minutes for security reasons.\\nYou can try again in.';

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'locked': LocalizationItem(key: 'locked', value: message, parameters: []),
          },
        ),
      ];

      final output = writer.generate(locales);
      // The output must contain the literal \n sequence in the Dart source.
      expect(
        output,
        contains(
          r"return 'Your account is temporarily locked for 15 minutes for security reasons.\\nYou can try again in.';",
        ),
      );
    });
  });
}
