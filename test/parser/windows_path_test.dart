import 'dart:io';

import 'package:test/test.dart';

import 'package:localization_gen/src/parser/json_parser.dart';

void main() {
  group('Windows path handling', () {
    test('parseDirectory accepts .JSON extension (case-insensitive)', () {
      final dir = Directory.systemTemp.createTempSync('localization_gen_win_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file = File('${dir.path}${Platform.pathSeparator}app_en.JSON');
      file.writeAsStringSync('{"hello":"Hi"}');

      final locales = JsonLocalizationParser.parseDirectory(dir.path, modular: false);
      expect(locales, hasLength(1));
      expect(locales.first.locale, equals('en'));
      expect(locales.first.items['hello']?.value, equals('Hi'));
    });

    test('locale extraction is separator-independent', () {
      // We can't call the private extractor directly, so validate via parse().
      final dir = Directory.systemTemp.createTempSync('localization_gen_sep_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file = File('${dir.path}${Platform.pathSeparator}app_id.json');
      file.writeAsStringSync('{"hello":"Halo"}');

      final locale = JsonLocalizationParser.parse(file);
      expect(locale.locale, equals('id'));
    });
  });
}
