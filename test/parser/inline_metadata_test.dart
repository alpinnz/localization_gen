import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';

void main() {
  group('Inline metadata', () {
    test(
        'parse() reads inline @description/@example/@placeholders and extra @ fields into LocalizationItem.metadata',
        () {
      final dir = Directory.systemTemp.createTempSync('inline_metadata_test_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file = File('${dir.path}/app_common_en.json');
      file.writeAsStringSync(jsonEncode({
        '@@locale': 'en',
        '@@module': 'common',
        'structured': {
          'invalid_code_errors': {
            '@context': {
              'register': 'Wrong Register Code',
              'verification': 'Verification OTP expired',
            },
            '@description': 'Invalid code error variants.',
            '@example': 'Wrong Register Code',
            '@placeholders': {},
            '@since': '1.4.1',
            '@deprecated': false,
            '@owner': 'design-system',
          },
        },
      }));

      final localeData = JsonLocalizationParser.parse(file);

      final item = localeData.items['structured.invalid_code_errors'];
      expect(item, isNotNull);
      expect(item!.description, equals('Invalid code error variants.'));
      expect(item.example, equals('Wrong Register Code'));
      expect(item.placeholderDocs, isEmpty);

      // Extra metadata fields (custom @ keys) go into metadata map.
      expect(item.metadata, isNotNull);
      expect(item.metadata!['since'], equals('1.4.1'));
      expect(item.metadata!['deprecated'], equals(false));
      expect(item.metadata!['owner'], equals('design-system'));
    });

    test('inline metadata wins over sibling @<key> when both exist', () {
      final dir =
          Directory.systemTemp.createTempSync('inline_metadata_priority_test_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });

      final file = File('${dir.path}/app_common_en.json');
      file.writeAsStringSync(jsonEncode({
        '@@locale': 'en',
        '@@module': 'common',
        'structured': {
          'invalid_code_errors': {
            '@context': {
              'register': 'Wrong Register Code',
              'verification': 'Verification OTP expired',
            },
            '@description': 'INLINE desc',
            '@example': 'INLINE ex',
            '@since': '1.4.1',
          },
          // Legacy sibling metadata blocks (e.g. "@invalid_code_errors") are
          // no longer supported and should NOT be treated as metadata.
          '@invalid_code_errors': {
            'description': 'SIBLING desc',
            'example': 'SIBLING ex',
            'placeholders': {'x': 'y'},
            'since': '0.0.1',
          },
        },
      }));

      final localeData = JsonLocalizationParser.parse(file);
      final item = localeData.items['structured.invalid_code_errors']!;

      expect(item.description, equals('INLINE desc'));
      expect(item.example, equals('INLINE ex'));

      // No @placeholders provided inline -> placeholder docs remain null.
      expect(item.placeholderDocs, isNull);

      // Extra inline fields go into metadata.
      expect(item.metadata, isNotNull);
      expect(item.metadata!['since'], equals('1.4.1'));

      // The legacy sibling entry is ignored and must not affect metadata parsing.
      expect(localeData.items.containsKey('structured.@invalid_code_errors'),
          isFalse);
    });
  });
}
