/// Tests for JsonLocalizationParser.
///
/// Covers all JSON parsing functionality.

import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';
import '../utils/test_helper.dart';

void main() {
  group('JsonLocalizationParser', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('parser_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    group('parse()', () {
      test('parses simple flat JSON', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          '{"@@locale": "en", "hello": "Hello"}',
        );

        final result = JsonLocalizationParser.parse(file);

        expect(result.locale, equals('en'));
        expect(result.items.length, equals(1));
        expect(result.items['hello']?.value, equals('Hello'));
      });

      test('parses nested JSON structure', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          TestHelper.nestedJson(),
        );

        final result = JsonLocalizationParser.parse(file);

        expect(result.items.containsKey('app.auth.login.title'), isTrue);
        expect(result.items['app.auth.login.title']?.value, equals('Login'));
      });

      test('extracts locale from @@locale field', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          '{"@@locale": "en", "test": "Test"}',
        );

        final result = JsonLocalizationParser.parse(file);
        expect(result.locale, equals('en'));
      });

      test('extracts locale from filename when @@locale missing', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          '{"test": "Test"}',
        );

        final result = JsonLocalizationParser.parse(file);
        expect(result.locale, equals('en'));
      });

      test('extracts single parameter', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          '{"@@locale": "en", "greeting": "Hello, {name}!"}',
        );

        final result = JsonLocalizationParser.parse(file);
        expect(result.items['greeting']?.parameters, equals(['name']));
      });

      test('extracts multiple parameters', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          TestHelper.jsonWithParameters(),
        );

        final result = JsonLocalizationParser.parse(file);
        expect(
            result.items['multiParam']?.parameters, equals(['user', 'count']));
      });

      test('handles text without parameters', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'app_en.json',
          '{"@@locale": "en", "hello": "Hello"}',
        );

        final result = JsonLocalizationParser.parse(file);
        expect(result.items['hello']?.parameters, isEmpty);
      });
    });

    group('parseDirectory()', () {
      test('parses multiple JSON files', () {
        TestHelper.createJsonFile(
            tempDir, 'app_en.json', TestHelper.basicEnglishJson());
        TestHelper.createJsonFile(
            tempDir, 'app_id.json', TestHelper.basicIndonesianJson());

        final results = JsonLocalizationParser.parseDirectory(tempDir.path);

        expect(results.length, equals(2));
        expect(results.any((r) => r.locale == 'en'), isTrue);
        expect(results.any((r) => r.locale == 'id'), isTrue);
      });

      test('throws on empty directory', () {
        expect(
          () => JsonLocalizationParser.parseDirectory(tempDir.path),
          throwsException,
        );
      });

      test('ignores non-JSON files', () {
        TestHelper.createJsonFile(
            tempDir, 'app_en.json', TestHelper.basicEnglishJson());
        File('${tempDir.path}/readme.txt').writeAsStringSync('test');

        final results = JsonLocalizationParser.parseDirectory(tempDir.path);
        expect(results.length, equals(1));
      });
    });

    group('Modular Parsing', () {
      test('merges modular files by locale', () {
        TestHelper.createModularFiles(tempDir, 'app');

        final results = JsonLocalizationParser.parseDirectory(
          tempDir.path,
          modular: true,
          filePrefix: 'app',
        );

        expect(results.length, equals(2));

        final enLocale = results.firstWhere((r) => r.locale == 'en');
        expect(enLocale.items.containsKey('login'), isTrue);
        expect(enLocale.items.containsKey('welcome'), isTrue);
      });
    });

    group('Error Handling', () {
      test('throws on invalid JSON', () {
        final file = TestHelper.createJsonFile(
          tempDir,
          'invalid.json',
          TestHelper.invalidJson(),
        );

        expect(
          () => JsonLocalizationParser.parse(file),
          throwsException,
        );
      });

      test('throws on non-existent file', () {
        final file = File('${tempDir.path}/nonexistent.json');

        expect(
          () => JsonLocalizationParser.parse(file),
          throwsException,
        );
      });

      test('throws on non-existent directory', () {
        expect(
          () => JsonLocalizationParser.parseDirectory('/nonexistent/path'),
          throwsException,
        );
      });
    });
  });
}
