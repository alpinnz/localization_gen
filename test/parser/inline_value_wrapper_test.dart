/// Tests for inline-only string metadata via the `@value` wrapper.
///
/// This verifies the new, non-legacy way to attach per-key metadata to simple
/// string translations.
library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';

import '../utils/test_helper.dart';

void main() {
  group('Inline @value wrapper', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('inline_value_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    test('parses wrapped string into LocalizationItem + metadata', () {
      final file = TestHelper.createJsonFile(
        tempDir,
        'app_common_en.json',
        '''
{
  "@@locale": "en",
  "@@module": "common",
  "placeholders": {
    "welcome_user": {
      "@value": "Welcome, {name}.",
      "@description": "Greets a user by name.",
      "@example": "Welcome, John.",
      "@placeholders": { "name": "User display name" },
      "@since": "1.4.1",
      "@deprecated": false
    }
  }
}
''',
      );

      final result = JsonLocalizationParser.parse(file);

      final item = result.items['placeholders.welcome_user'];
      expect(item, isNotNull);
      expect(item!.value, equals('Welcome, {name}.'));
      expect(item.parameters, equals(['name']));
      expect(item.description, equals('Greets a user by name.'));
      expect(item.example, equals('Welcome, John.'));
      expect(item.placeholderDocs, equals({'name': 'User display name'}));
      expect(item.metadata, isNotNull);
      expect(item.metadata!['since'], equals('1.4.1'));
      expect(item.metadata!['deprecated'], equals(false));
    });

    test(
        'ignores wrapper when @value is not a String (treats as nested object)',
        () {
      final file = TestHelper.createJsonFile(
        tempDir,
        'app_common_en.json',
        '''
{
  "@@locale": "en",
  "@@module": "common",
  "x": {
    "y": {
      "@value": {"not": "a string"},
      "title": "Hello"
    }
  }
}
''',
      );

      final result = JsonLocalizationParser.parse(file);
      // Should parse x.y.title as a nested value.
      expect(result.items['x.y.title']?.value, equals('Hello'));
      // Should NOT create x.y as a translation item.
      expect(result.items.containsKey('x.y'), isFalse);
    });
  });
}
