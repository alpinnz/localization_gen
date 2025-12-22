import 'dart:io';
import 'package:args/args.dart';
import 'base_command.dart';

/// Command to initialize localization setup in a Flutter project.
class InitCommand extends BaseCommand {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize localization setup in your project';

  @override
  Future<int> execute(List<String> args) async {
    final parser = ArgParser()
      ..addOption(
        'input-dir',
        abbr: 'i',
        help: 'Input directory for localization files',
        defaultsTo: 'assets/localizations',
      )
      ..addOption(
        'output-dir',
        abbr: 'o',
        help: 'Output directory for generated files',
        defaultsTo: 'lib/assets',
      )
      ..addOption(
        'class-name',
        abbr: 'n',
        help: 'Name for the generated localization class',
        defaultsTo: 'AppLocalizations',
      )
      ..addOption(
        'locales',
        abbr: 'l',
        help: 'Comma-separated list of locales (e.g., en,es,id)',
        defaultsTo: 'en',
      )
      ..addFlag(
        'modular',
        abbr: 'm',
        help: 'Enable modular organization',
        negatable: false,
      )
      ..addFlag(
        'strict',
        abbr: 's',
        help: 'Enable strict validation',
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

      final inputDir = results['input-dir'] as String;
      final outputDir = results['output-dir'] as String;
      final className = results['class-name'] as String;
      final localesString = results['locales'] as String;
      final modular = results['modular'] as bool;
      final strict = results['strict'] as bool;

      final locales = localesString.split(',').map((e) => e.trim()).toList();

      printInfo('Initializing localization setup...\n');

      // Step 1: Create directories
      final inputDirectory = Directory(inputDir);
      if (!inputDirectory.existsSync()) {
        inputDirectory.createSync(recursive: true);
        printSuccess('Created input directory: $inputDir');
      } else {
        printInfo('Input directory already exists: $inputDir');
      }

      final outputDirectory = Directory(outputDir);
      if (!outputDirectory.existsSync()) {
        outputDirectory.createSync(recursive: true);
        printSuccess('Created output directory: $outputDir');
      } else {
        printInfo('Output directory already exists: $outputDir');
      }

      // Step 2: Create sample JSON files
      for (final locale in locales) {
        final fileName = modular ? 'app_main_$locale.json' : 'app_$locale.json';
        final file = File('$inputDir/$fileName');

        if (!file.existsSync()) {
          final sampleContent = _generateSampleJson(locale);
          file.writeAsStringSync(sampleContent);
          printSuccess('Created sample file: $fileName');
        } else {
          printInfo('File already exists: $fileName');
        }
      }

      // Step 3: Add/update pubspec.yaml configuration
      final pubspecFile = File('pubspec.yaml');
      if (pubspecFile.existsSync()) {
        final content = pubspecFile.readAsStringSync();

        if (!content.contains('localization_gen:')) {
          final config = _generatePubspecConfig(
            inputDir: inputDir,
            outputDir: outputDir,
            className: className,
            modular: modular,
            strict: strict,
          );

          pubspecFile.writeAsStringSync('$content\n$config');
          printSuccess('Added localization_gen configuration to pubspec.yaml');
        } else {
          printInfo(
              'localization_gen configuration already exists in pubspec.yaml');
        }
      }

      // Step 4: Add assets to pubspec.yaml
      _updatePubspecAssets(inputDir);

      print('\n' + '=' * 60);
      printSuccess('Initialization complete!');
      print('=' * 60);
      print('\nNext steps:');
      print('  1. Edit your JSON files in $inputDir/');
      print('  2. Run: dart run localization_gen');
      print('  3. Add to your MaterialApp:');
      print('     localizationsDelegates: [');
      print('       ${className}Extension.delegate,');
      print('       GlobalMaterialLocalizations.delegate,');
      print('     ],');
      print('     supportedLocales: $className.supportedLocales,');

      return 0;
    } catch (e) {
      exitWithError(e.toString());
      return 1;
    }
  }

  String _generateSampleJson(String locale) {
    final samples = {
      'en': '''
{
  "@@locale": "en",
  "app": {
    "title": "My App",
    "welcome": "Welcome, {name}!"
  },
  "common": {
    "ok": "OK",
    "cancel": "Cancel",
    "save": "Save"
  }
}
''',
      'es': '''
{
  "@@locale": "es",
  "app": {
    "title": "Mi Aplicación",
    "welcome": "¡Bienvenido, {name}!"
  },
  "common": {
    "ok": "Aceptar",
    "cancel": "Cancelar",
    "save": "Guardar"
  }
}
''',
      'id': '''
{
  "@@locale": "id",
  "app": {
    "title": "Aplikasi Saya",
    "welcome": "Selamat datang, {name}!"
  },
  "common": {
    "ok": "OK",
    "cancel": "Batal",
    "save": "Simpan"
  }
}
''',
    };

    return samples[locale] ?? samples['en']!.replaceAll('"en"', '"$locale"');
  }

  String _generatePubspecConfig({
    required String inputDir,
    required String outputDir,
    required String className,
    required bool modular,
    required bool strict,
  }) {
    return '''
# Localization configuration
localization_gen:
  input_dir: $inputDir
  output_dir: $outputDir
  class_name: $className${modular ? '\n  modular: true' : ''}${strict ? '\n  strict_validation: true' : ''}
''';
  }

  void _updatePubspecAssets(String inputDir) {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) return;

    final content = pubspecFile.readAsStringSync();

    if (content.contains('flutter:') && !content.contains('assets:')) {
      // Add assets section
      final updatedContent = content.replaceFirst(
        'flutter:',
        'flutter:\n  assets:\n    - $inputDir/',
      );
      pubspecFile.writeAsStringSync(updatedContent);
      printSuccess('Added assets configuration to pubspec.yaml');
    } else if (content.contains('assets:') &&
        !content.contains('- $inputDir/')) {
      printInfo(
          'Please manually add "- $inputDir/" to your assets in pubspec.yaml');
    }
  }

  /// Prints help information for the init command.
  ///
  /// The [parser] parameter provides the argument parser configuration.
  ///
  /// Displays usage, options, and examples for initializing localization.
  void _printHelp(ArgParser parser) {
    print('Initialize localization setup in your Flutter project\n');
    print('Usage: $usage\n');
    print('Options:');
    print(parser.usage);
    print('\nExamples:');
    print('  dart run localization_gen init');
    print('  dart run localization_gen init --locales=en,es,id');
    print('  dart run localization_gen init --modular --strict');
  }
}
