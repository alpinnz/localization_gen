/// Tests for ConfigReader.
///
/// Covers configuration reading from pubspec.yaml.

import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/config/config_reader.dart';
import '../utils/test_helper.dart';

void main() {
  group('ConfigReader', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('config_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    group('read()', () {
      test('reads all configuration options', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: TestLocalizations
  use_context: true
  nullable: false
  modular: true
  file_prefix: test
  strict_validation: true
''');

        final config = ConfigReader.read(configFile.path);

        expect(config.inputDir, equals('assets/localizations'));
        expect(config.outputDir, equals('lib/assets'));
        expect(config.className, equals('TestLocalizations'));
        expect(config.useContext, isTrue);
        expect(config.nullable, isFalse);
        expect(config.modular, isTrue);
        expect(config.filePrefix, equals('test'));
        expect(config.strictValidation, isTrue);
      });

      test('uses default values when options not specified', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: assets/localizations
''');

        final config = ConfigReader.read(configFile.path);

        expect(config.className, equals('AppLocalizations'));
        expect(config.outputDir, equals('lib/assets'));
        expect(config.useContext, isTrue);
        expect(config.nullable, isFalse);
        expect(config.modular, isFalse);
        expect(config.strictValidation, isFalse);
      });

      test('throws on missing input_dir', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  output_dir: lib
''');

        expect(
          () => ConfigReader.read(configFile.path),
          throwsException,
        );
      });

      test('throws on missing localization_gen section', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
dependencies:
  flutter:
    sdk: flutter
''');

        expect(
          () => ConfigReader.read(configFile.path),
          throwsException,
        );
      });

      test('throws on non-existent config file', () {
        expect(
          () => ConfigReader.read('${tempDir.path}/nonexistent.yaml'),
          throwsException,
        );
      });
    });
  });
}
