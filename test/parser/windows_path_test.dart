import 'dart:io';

import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Windows path handling', () {
    test('parseDirectory accepts .JSON extension (case-insensitive)', () {
      final dir = Directory.systemTemp.createTempSync('localization_gen_win_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file =
          File('${dir.path}${Platform.pathSeparator}app_common_en.JSON');
      file.writeAsStringSync(
          '{"@@locale":"en","@@module":"common","hello":"Hi"}');

      final locales = JsonLocalizationParser.parseDirectory(
        dir.path,
        filePrefix: 'app',
      );
      expect(locales.first.locale, equals('en'));
      expect(locales.first.items['hello']?.value, equals('Hi'));
    });

    test('locale extraction is separator-independent', () {
      final dir = Directory.systemTemp.createTempSync('localization_gen_sep_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file =
          File('${dir.path}${Platform.pathSeparator}app_common_en.JSON');
      file.writeAsStringSync(
          '{"@@locale":"en","@@module":"common","hello":"Hi"}');

      final localeData = JsonLocalizationParser.parse(file);
      expect(localeData.locale, equals('en'));
      expect(localeData.items['hello']?.value, equals('Hi'));
    });
  });
}
