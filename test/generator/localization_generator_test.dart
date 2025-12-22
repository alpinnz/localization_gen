/// Tests for LocalizationGenerator.
///
/// Covers end-to-end generation workflow.

import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/generator/localization_generator.dart';
import '../utils/test_helper.dart';

void main() {
  group('LocalizationGenerator', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('generator_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    group('generate()', () {
      test('generates complete localization code from JSON files', () {
        // Setup
        final localizationsDir = Directory('${tempDir.path}/localizations');
        localizationsDir.createSync();
        final outputDir = Directory('${tempDir.path}/lib');
        outputDir.createSync();

        TestHelper.createJsonFile(
          localizationsDir,
          'app_en.json',
          TestHelper.basicEnglishJson(),
        );
        TestHelper.createJsonFile(
          localizationsDir,
          'app_id.json',
          TestHelper.basicIndonesianJson(),
        );

        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: ${tempDir.path}/localizations
  output_dir: ${tempDir.path}/lib
  class_name: AppLocalizations
''');

        // Act
        final generator = LocalizationGenerator(
          configPath: configFile.path,
        );
        generator.generate();

        // Assert
        final outputFile = File('${tempDir.path}/lib/app_localizations.dart');
        expect(outputFile.existsSync(), isTrue);

        final content = outputFile.readAsStringSync();
        expect(content, contains('class AppLocalizations'));
        expect(content, contains('hello'));
        expect(content, contains('welcome'));
      });

      test('creates output directory if not exists', () {
        final localizationsDir = Directory('${tempDir.path}/localizations');
        localizationsDir.createSync();

        TestHelper.createJsonFile(
          localizationsDir,
          'app_en.json',
          TestHelper.basicEnglishJson(),
        );

        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: ${tempDir.path}/localizations
  output_dir: ${tempDir.path}/lib/generated
  class_name: AppLocalizations
''');

        final generator = LocalizationGenerator(
          configPath: configFile.path,
        );
        generator.generate();

        final outputDir = Directory('${tempDir.path}/lib/generated');
        expect(outputDir.existsSync(), isTrue);

        final outputFile =
            File('${tempDir.path}/lib/generated/app_localizations.dart');
        expect(outputFile.existsSync(), isTrue);
      });

      test('throws on non-existent input directory', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: ${tempDir.path}/nonexistent
  output_dir: ${tempDir.path}/lib
  class_name: AppLocalizations
''');

        final generator = LocalizationGenerator(
          configPath: configFile.path,
        );

        expect(() => generator.generate(), throwsException);
      });

      test('generates file with snake_case name', () {
        final localizationsDir = Directory('${tempDir.path}/localizations');
        localizationsDir.createSync();
        final outputDir = Directory('${tempDir.path}/lib');
        outputDir.createSync();

        TestHelper.createJsonFile(
          localizationsDir,
          'app_en.json',
          TestHelper.basicEnglishJson(),
        );

        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: ${tempDir.path}/localizations
  output_dir: ${tempDir.path}/lib
  class_name: MyCustomLocalizations
''');

        final generator = LocalizationGenerator(
          configPath: configFile.path,
        );
        generator.generate();

        final outputFile =
            File('${tempDir.path}/lib/my_custom_localizations.dart');
        expect(outputFile.existsSync(), isTrue);
      });
    });
  });
}
