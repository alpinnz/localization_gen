import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'base_command.dart';
import '../config/config_reader.dart';

/// Command to clean generated localization files.
///
/// This command removes generated Dart files from the output directory,
/// useful for cleaning up before regeneration or when changing configuration.
///
/// Usage:
/// ```bash
/// dart run localization_gen clean
/// dart run localization_gen clean --dry-run
/// dart run localization_gen clean --config=my_pubspec.yaml
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
  /// - `--config` or `-c`: Path to pubspec.yaml
  /// - `--dry-run` or `-d`: Preview files to delete without actually deleting
  /// - `--help` or `-h`: Show help information
  ///
  /// Returns 0 on success, 1 on error.
  @override
  Future<int> execute(List<String> args) async {
    final parser = ArgParser()
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to pubspec.yaml',
        defaultsTo: 'pubspec.yaml',
      )
      ..addFlag(
        'dry-run',
        abbr: 'd',
        help: 'Show what would be deleted without actually deleting',
        negatable: false,
      )
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

      final configPath = results['config'] as String;
      final dryRun = results['dry-run'] as bool;

      if (dryRun) {
        printInfo('Running in dry-run mode (no files will be deleted)\n');
      } else {
        printInfo('Cleaning generated files...\n');
      }

      final config = ConfigReader.read(configPath);

      // Find generated file
      final outputDir = Directory(config.outputDir);
      if (!outputDir.existsSync()) {
        printInfo('Output directory does not exist: ${config.outputDir}');
        return 0;
      }

      final fileName = _toSnakeCase(config.className) + '.dart';
      final generatedFile = File(p.join(config.outputDir, fileName));

      int deletedCount = 0;

      if (generatedFile.existsSync()) {
        if (dryRun) {
          printInfo('Would delete: ${generatedFile.path}');
        } else {
          generatedFile.deleteSync();
          printSuccess('Deleted: ${generatedFile.path}');
        }
        deletedCount++;
      } else {
        printInfo('No generated file found at: ${generatedFile.path}');
      }

      print('');
      if (dryRun) {
        printInfo('Dry run complete. $deletedCount file(s) would be deleted.');
      } else {
        printSuccess('Clean complete. $deletedCount file(s) deleted.');
      }

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
    print('  dart run localization_gen clean --dry-run');
  }
}
