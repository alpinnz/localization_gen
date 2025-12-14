import 'package:args/args.dart';
import '../generator/localization_generator.dart';

/// Command-line interface handler
class GenerateCommand {
  void run(List<String> args) {
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
        help: 'Watch for changes and regenerate (not implemented yet)',
      )
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to pubspec.yaml',
        defaultsTo: 'pubspec.yaml',
      );

    try {
      final results = parser.parse(args);

      if (results['help'] as bool) {
        _printUsage(parser);
        return;
      }

      final generator = LocalizationGenerator(
        watch: results['watch'] as bool,
        configPath: results['config'] as String?,
      );

      generator.generate();

      if (results['watch'] as bool) {
        print('\n👀 Watch mode not implemented yet');
      }
    } catch (e) {
      print('Error parsing arguments: $e\n');
      _printUsage(parser);
    }
  }

  void _printUsage(ArgParser parser) {
    print('localization_gen - Strongly-typed localization generator\n');
    print('Usage: dart run localization_gen [options]\n');
    print('Options:');
    print(parser.usage);
    print('\nExample:');
    print('  dart run localization_gen');
    print('  dart run localization_gen --watch');
    print('  dart run localization_gen --config=my_pubspec.yaml');
  }
}

