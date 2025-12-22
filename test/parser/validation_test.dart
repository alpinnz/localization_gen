/// Tests for strict validation functionality.
///
/// Covers locale consistency and validation.

import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/exceptions/exceptions.dart';
import '../utils/test_helper.dart';

void main() {
  group('Strict Validation', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('validation_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    group('Key Consistency', () {
      test('passes with identical keys across locales', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome": "Welcome"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "hello": "Halo",
  "welcome": "Selamat datang"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          returnsNormally,
        );
      });

      test('throws on missing keys in secondary locale', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome": "Welcome",
  "goodbye": "Goodbye"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "hello": "Halo",
  "welcome": "Selamat datang"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          throwsA(isA<LocaleValidationException>()),
        );
      });

      test('provides list of missing keys', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "key1": "Value 1",
  "key2": "Value 2",
  "key3": "Value 3"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "key1": "Nilai 1"
}
''');

        try {
          JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          );
          fail('Should throw LocaleValidationException');
        } on LocaleValidationException catch (e) {
          expect(e.locale, equals('id'));
          expect(e.missingKeys, isNotNull);
          expect(e.missingKeys, hasLength(greaterThanOrEqualTo(1)));
        }
      });

      test('throws on extra keys in secondary locale', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "hello": "Hello"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "hello": "Halo",
  "extra1": "Extra translation",
  "extra2": "Another extra"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          throwsA(isA<LocaleValidationException>()),
        );
      });
    });

    group('Parameter Consistency', () {
      test('throws on parameter mismatch between locales', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "greeting": "Halo, {name} dan {title}!"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          throwsA(isA<ParameterException>()),
        );
      });

      test('passes with matching parameters', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "greeting": "Halo, {name}!"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          returnsNormally,
        );
      });

      test('allows different parameter order', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "message": "{user} sent {count} messages"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "message": "{count} pesan dari {user}"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: true,
          ),
          returnsNormally,
        );
      });
    });

    group('Without Strict Validation', () {
      test('allows missing keys when strict validation disabled', () {
        TestHelper.createJsonFile(tempDir, 'app_en.json', '''
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome": "Welcome",
  "extra": "Extra"
}
''');

        TestHelper.createJsonFile(tempDir, 'app_id.json', '''
{
  "@@locale": "id",
  "hello": "Halo"
}
''');

        expect(
          () => JsonLocalizationParser.parseDirectory(
            tempDir.path,
            strictValidation: false,
          ),
          returnsNormally,
        );
      });
    });
  });
}
