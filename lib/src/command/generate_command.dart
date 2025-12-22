import 'dart:io';
import 'package:args/args.dart';
import 'base_command.dart';
import '../generator/localization_generator.dart';
import '../watcher/file_watcher.dart';
import '../config/config_reader.dart';

/// Command to generate localization code from JSON files.
///
/// This command reads JSON localization files and generates type-safe Dart code
/// for accessing translations. Supports watch mode for automatic regeneration
/// during development.
///
/// Usage:
/// ```bash
/// dart run localization_gen generate
/// dart run localization_gen generate --watch
/// dart run localization_gen generate --config=my_pubspec.yaml
/// ```
class GenerateCommand extends BaseCommand {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate localization code from JSON files';

  /// Executes the generate command with the provided arguments.
  ///
  /// Supports the following options:
  /// - `--help` or `-h`: Display help information
  /// - `--watch` or `-w`: Enable watch mode for auto-regeneration
  /// - `--config` or `-c`: Specify path to pubspec.yaml
  /// - `--debounce` or `-d`: Set debounce delay in milliseconds for watch mode
  ///
  /// Returns 0 on success, 1 on error.
  @override
  Future<int> execute(List<String> args) async {
    final parser = ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Show usage information',
      )
      ..addFlag(
        'watch',
        abbr: 'w',
        negatable: false,
        help: 'Watch for changes and regenerate automatically',
      )
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to pubspec.yaml',
        defaultsTo: 'pubspec.yaml',
      )
      ..addOption(
        'debounce',
        abbr: 'd',
        help: 'Debounce delay in milliseconds for watch mode',
        defaultsTo: '300',
      );

    try {
      final results = parser.parse(args);

      if (results['help'] as bool) {
        _printUsage(parser);
        return 0;
      }

      final configPath = results['config'] as String;
      final watchMode = results['watch'] as bool;
      final debounceMs = int.parse(results['debounce'] as String);

      final generator = LocalizationGenerator(
        watch: watchMode,
        configPath: configPath,
      );

      // Initial generation
      generator.generate();

      // Start watch mode if requested
      if (watchMode) {
        final config = ConfigReader.read(configPath);
        final watcher = FileWatcher(
          watchDir: config.inputDir,
          debounceDuration: Duration(milliseconds: debounceMs),
          generator: generator,
        );

        // Set up signal handlers for graceful shutdown
        ProcessSignal.sigint.watch().listen((_) {
          print('\n\nStopping watch mode...');
          watcher.stop();
          exit(0);
        });

        await watcher.start();
      }

      return 0;
    } catch (e) {
      stderr.writeln('Error: $e\n');
      _printUsage(parser);
      return 1;
    }
  }

  /// Prints help information for the generate command.
  ///
  /// Displays usage examples and available options.
  void _printHelp(ArgParser parser) {
    _printUsage(parser);
  }

  /// Prints usage information for the generate command.
  ///
  /// The [parser] parameter provides the argument parser configuration.
  void _printUsage(ArgParser parser) {
    print('localization_gen - Strongly-typed localization generator\n');
    print('Usage: dart run localization_gen [options]\n');
    print('Options:');
    print(parser.usage);
    print('\nExamples:');
    print('  dart run localization_gen');
    print('  dart run localization_gen --watch');
    print('  dart run localization_gen --watch --debounce=500');
    print('  dart run localization_gen --config=my_pubspec.yaml');
  }
}
