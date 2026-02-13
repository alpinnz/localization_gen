import 'package:test/test.dart';

import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';

void main() {
  group('Writer regression: special chars', () {
    test(
        'emits valid Dart for strings containing apostrophe + double quote + backslash-dollar',
        () {
      final writer = DartWriter(className: 'TestLocalizations');

      const value = 'Special: @#\$%^&*()_+-=[]{}|;\'\\",./<>?';
      // Explanation of the value above:
      // - contains an apostrophe '
      // - contains a double quote "
      // - contains a dollar sign $

      final locales = [
        LocaleData(
          locale: 'en',
          items: {
            'special_chars': LocalizationItem(
              key: 'special_chars',
              value: value,
            ),
          },
        ),
      ];

      final output = writer.generate(locales);

      // Must be a single-quoted Dart literal (in the translations table and/or fallback).
      expect(output, contains("'Special:"));
      // Apostrophe should be escaped as \\' in Dart source.
      expect(output, contains(r"\\'"));
      // Dollar sign should be escaped as \$
      expect(output, contains(r"\$"));
      // Must still contain the double quote character in the resulting literal.
      expect(output, contains('"'));
    });
  });
}
