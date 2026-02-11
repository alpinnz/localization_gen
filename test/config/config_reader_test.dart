/// Tests for ConfigReader.
///
/// Covers configuration reading from pubspec.yaml.
library;

import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/config/config_reader.dart';
import 'package:localization_gen/src/model/localization_item.dart';
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
  file_prefix: test
''');

        final config = ConfigReader.read(configFile.path);

        expect(LocalizationConfig.outputFileSuffix, equals('.gen.dart'));
        expect(config.inputDir, equals('assets/localizations'));
        expect(config.outputDir, equals('lib/assets'));
        expect(config.className, equals('TestLocalizations'));
        expect(config.filePrefix, equals('test'));
      });

      test('uses default values when options not specified', () {
        final configFile = File('${tempDir.path}/pubspec.yaml');
        configFile.writeAsStringSync('''
name: test_app
localization_gen:
  input_dir: assets/localizations
''');

        final config = ConfigReader.read(configFile.path);

        expect(LocalizationConfig.outputFileSuffix, equals('.gen.dart'));
        expect(config.className, equals('AppLocalizations'));
        expect(config.outputDir, equals('lib/assets'));
        expect(config.filePrefix, equals('app'));
        expect(config.filePattern, equals('app_{module}_{locale}.json'));
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
