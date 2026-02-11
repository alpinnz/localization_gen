import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'package:localization_gen/src/config/config_reader.dart';
import 'package:localization_gen/src/model/localization_item.dart';

import 'base_command.dart';

/// Command to clean generated localization files.
///
/// This command removes generated Dart files from the output directory,
/// useful for cleaning up before regeneration or when changing configuration.
///
/// Usage:
/// ```bash
/// dart run localization_gen clean
/// ```
class CleanCommand extends BaseCommand {
  @override
  String get name => 'clean';

  @override
  String get description => 'Remove generated localization files';

  /// Executes the clean command with the provided arguments.
  ///
  /// Removes generated localization files based on configuration.
  ///
  /// Supports the following options:
  /// - `--help` or `-h`: Show help information
  ///
  /// Returns 0 on success, 1 on error.
  @override
  Future<int> execute(List<String> args) async {
    final parser = ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Show help information',
        negatable: false,
      );

    try {
      final results = parser.parse(args);

      if (results['help'] as bool) {
        _printHelp(parser);
        return 0;
      }

      printInfo('Cleaning generated files...\n');

      final config = ConfigReader.read();

      // Find generated file
      final outputDir = Directory(config.outputDir);
      if (!outputDir.existsSync()) {
        printInfo('Output directory does not exist: ${config.outputDir}');
        return 0;
      }

      final fileName =
          _toSnakeCase(config.className) + LocalizationConfig.outputFileSuffix;
      final generatedFile = File(p.join(config.outputDir, fileName));

      // Also clean legacy outputs that used ".dart" without ".gen".
      final legacyFileName = '${_toSnakeCase(config.className)}.dart';
      final legacyGeneratedFile =
          File(p.join(config.outputDir, legacyFileName));

      int deletedCount = 0;

      // Delete current configured output first.
      if (generatedFile.existsSync()) {
        generatedFile.deleteSync();
        printSuccess('Deleted: ${generatedFile.path}');
        deletedCount++;
      } else {
        printInfo('No generated file found at: ${generatedFile.path}');
      }

      // Delete legacy output if it exists and is different.
      if (legacyGeneratedFile.path != generatedFile.path &&
          legacyGeneratedFile.existsSync()) {
        legacyGeneratedFile.deleteSync();
        printSuccess('Deleted legacy: ${legacyGeneratedFile.path}');
        deletedCount++;
      }

      print('');
      printSuccess('Clean complete. $deletedCount file(s) deleted.');

      return 0;
    } catch (e) {
      exitWithError(e.toString());
      return 1;
    }
  }

  /// Converts a PascalCase string to snake_case.
  ///
  /// Used to determine the filename from the class name.
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
        .substring(1);
  }

  /// Prints help information for the clean command.
  ///
  /// The [parser] parameter provides the argument parser configuration.
  ///
  /// Displays usage, options, and examples for cleaning generated files.
  void _printHelp(ArgParser parser) {
    print('Remove generated localization files\n');
    print('Usage: $usage\n');
    print('Options:');
    print(parser.usage);
    print('\nExamples:');
    print('  dart run localization_gen clean');
  }
}
