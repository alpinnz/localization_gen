import 'dart:io';
import 'package:args/args.dart';
import '../generator/localization_generator.dart';
import '../watcher/file_watcher.dart';
import '../config/config_reader.dart';

/// Command-line interface handler
class GenerateCommand {
  Future<void> run(List<String> args) async {
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
        return;
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
          print('\n\n👋 Stopping watch mode...');
          watcher.stop();
          exit(0);
        });

        await watcher.start();
      }
    } catch (e) {
      print('Error: $e\n');
      _printUsage(parser);
      exit(1);
    }
  }

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
