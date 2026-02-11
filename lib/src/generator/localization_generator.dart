import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:localization_gen/src/config/config_reader.dart';
import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/model/field_rename.dart';

/// Main generator that orchestrates the entire process
class LocalizationGenerator {
  /// Whether to run in watch mode (reserved for future use)
  final bool watch;

  /// Creates a new LocalizationGenerator instance
  ///
  /// The [watch] parameter is reserved for future watch mode functionality.
  ///
  /// Example:
  /// ```dart
  /// final generator = LocalizationGenerator(watch: false);
  /// generator.generate();
  /// ```
  LocalizationGenerator({
    this.watch = false,
  });

  /// Runs the localization generation process
  ///
  /// This method performs the following steps:
  /// 1. Reads configuration from pubspec.yaml
  /// 2. Parses JSON localization files
  /// 3. Generates type-safe Dart code
  /// 4. Writes the output to the specified directory
  ///
  /// Throws an [Exception] if generation fails.
  ///
  /// Example:
  /// ```dart
  /// final generator = LocalizationGenerator();
  /// generator.generate();
  /// ```
  void generate() {
    try {
      print('Starting localization generation...\n');

      // Step 1: Read config
      final config = ConfigReader.read();
      print('Config:');
      print('   Input:  ${config.inputDir}');
      print('   Output: ${config.outputDir}');
      print('   Class:  ${config.className}');
      print('   Pattern: ${config.filePattern}');
      print('   Prefix:  ${config.filePrefix}');
      print('');

      // Step 2: Parse JSON files
      print('Scanning JSON localization files...');
      final locales = JsonLocalizationParser.parseDirectory(
        config.inputDir,
        filePrefix: config.filePrefix,
      );
      print(
          'Found ${locales.length} locale(s): ${locales.map((l) => l.locale).join(', ')}\n');

      if (locales.isEmpty) {
        print('No locales found!');
        return;
      }

      // Step 3: Generate Dart code
      print('Generating Dart code...');
      final writer = DartWriter(
        className: config.className,
        fieldRename: FieldRename.fromString(config.fieldRename),
      );

      final dartCode = writer.generate(locales);

      // Step 4: Write output
      final outputDir = Directory(config.outputDir);
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      final outputFile = File(
        p.join(
          config.outputDir,
          '${_toSnakeCase(config.className)}${LocalizationConfig.outputFileSuffix}',
        ),
      );
      outputFile.writeAsStringSync(dartCode);

      print('Generated: ${outputFile.path}');
      print('\nDone! Generated ${locales.first.items.length} translations.');
      print('\nAdd this to your MaterialApp:');
      print('   localizationsDelegates: [');
      print('     ${config.className}Extension.delegate,');
      print('     GlobalMaterialLocalizations.delegate,');
      print('   ],');
      print('   supportedLocales: ${config.className}.supportedLocales,');
      print('\nAccess translations using:');
      print('   final appLocalizations = ${config.className}.of(context);');
      print('   final text = appLocalizations.yourKey;');
    } catch (e, stack) {
      print('Error: $e');
      if (watch) {
        print('Stack trace: $stack');
      }

      // Important: don't call exit(1) here.
      // - Library users (and tests) expect an exception.
      // - The CLI is responsible for turning failures into process exit codes.
      throw Exception(e.toString());
    }
  }

  /// Converts a PascalCase string to snake_case.
  ///
  /// Used to generate file names from class names.
  ///
  /// Example:
  /// ```dart
  /// _toSnakeCase('AppLocalizations'); // Returns 'app_localizations'
  /// ```
  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .substring(1); // Remove leading underscore
  }
}
