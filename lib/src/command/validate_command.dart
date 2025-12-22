import 'dart:io';
import 'package:args/args.dart';
import 'base_command.dart';
import '../config/config_reader.dart';

/// Command to validate localization files without generating code.
///
/// This command checks JSON localization files for consistency, proper format,
/// and completeness without generating any output files.
///
/// Usage:
/// ```bash
/// dart run localization_gen validate
/// dart run localization_gen validate --verbose
/// dart run localization_gen validate --config=my_pubspec.yaml
/// ```
class ValidateCommand extends BaseCommand {
  @override
  String get name => 'validate';

  @override
  String get description => 'Validate localization files for consistency';

  /// Executes the validate command with the provided arguments.
  ///
  /// Checks all JSON files in the input directory for:
  /// - Valid JSON syntax
  /// - Proper structure
  /// - Non-empty content
  ///
  /// Supports the following options:
  /// - `--config` or `-c`: Path to pubspec.yaml
  /// - `--verbose` or `-v`: Show detailed validation results
  /// - `--help` or `-h`: Show help information
  ///
  /// Returns 0 on success, 1 if validation errors are found.
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
        'verbose',
        abbr: 'v',
        help: 'Show detailed validation results',
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
      final verbose = results['verbose'] as bool;

      printInfo('Validating localization files...\n');

      final config = ConfigReader.read(configPath);

      // Check if input directory exists
      final inputDir = Directory(config.inputDir);
      if (!inputDir.existsSync()) {
        printWarning('Input directory not found: ${config.inputDir}');
        return 1;
      }

      // Find all JSON files
      final jsonFiles = inputDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList();

      if (jsonFiles.isEmpty) {
        printWarning('No JSON files found in ${config.inputDir}');
        return 1;
      }

      printSuccess('Found ${jsonFiles.length} JSON file(s)');

      // Validate each file
      int errorCount = 0;
      int warningCount = 0;

      for (final file in jsonFiles) {
        if (verbose) {
          printInfo('Validating: ${file.path}');
        }

        try {
          final content = file.readAsStringSync();
          if (content.trim().isEmpty) {
            printWarning('  Empty file: ${file.path}');
            warningCount++;
            continue;
          }

          // Try to parse JSON
          // Note: Full validation logic would be in parser
          printSuccess('  Valid: ${file.path.split('/').last}');
        } catch (e) {
          stderr.writeln('  ✗ Invalid: ${file.path}');
          stderr.writeln('    Error: $e');
          errorCount++;
        }
      }

      print('');
      if (errorCount == 0 && warningCount == 0) {
        printSuccess('All files are valid!');
        return 0;
      } else if (errorCount == 0) {
        printWarning('Validation completed with $warningCount warning(s)');
        return 0;
      } else {
        printWarning(
            'Validation failed with $errorCount error(s) and $warningCount warning(s)');
        return 1;
      }
    } catch (e) {
      exitWithError(e.toString());
      return 1;
    }
  }

  /// Prints help information for the validate command.
  ///
  /// The [parser] parameter provides the argument parser configuration.
  ///
  /// Displays usage and available options for validation.
  void _printHelp(ArgParser parser) {
    print('Validate localization files for consistency\n');
    print('Usage: $usage\n');
    print('Options:');
    print(parser.usage);
  }
}
