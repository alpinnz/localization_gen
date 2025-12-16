import 'dart:io';
import '../config/config_reader.dart';
import '../parser/json_parser.dart';
import '../writer/dart_writer.dart';

/// Main generator that orchestrates the entire process
class LocalizationGenerator {
  /// Whether to run in watch mode (reserved for future use)
  final bool watch;

  /// Optional path to the pubspec.yaml configuration file
  final String? configPath;

  /// Creates a new LocalizationGenerator instance
  ///
  /// The [watch] parameter is reserved for future watch mode functionality.
  /// The [configPath] parameter specifies a custom path to pubspec.yaml.
  ///
  /// Example:
  /// ```dart
  /// final generator = LocalizationGenerator(
  ///   watch: false,
  ///   configPath: 'pubspec.yaml',
  /// );
  /// generator.generate();
  /// ```
  LocalizationGenerator({
    this.watch = false,
    this.configPath,
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
      final config = ConfigReader.read(configPath ?? 'pubspec.yaml');
      print('Config:');
      print('   Input:  ${config.inputDir}');
      print('   Output: ${config.outputDir}');
      print('   Class:  ${config.className}');
      print('   Modular: ${config.modular}');
      if (config.modular) {
        print('   Pattern: ${config.filePattern}');
        print('   Prefix:  ${config.filePrefix}');
      }
      print('');

      // Step 2: Parse JSON files
      print('Scanning JSON localization files...');
      final locales = JsonLocalizationParser.parseDirectory(
        config.inputDir,
        modular: config.modular,
        filePrefix: config.filePrefix,
        strictValidation: config.strictValidation,
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
        useContext: config.useContext,
        nullable: config.nullable,
      );

      final dartCode = writer.generate(locales);

      // Step 4: Write output
      final outputDir = Directory(config.outputDir);
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      final outputFile =
          File('${config.outputDir}/${_toSnakeCase(config.className)}.dart');
      outputFile.writeAsStringSync(dartCode);

      print('Generated: ${outputFile.path}');
      print('\nDone! Generated ${locales.first.items.length} translations.');
      print('\nAdd this to your MaterialApp:');
      print('   localizationsDelegates: [');
      print('     ${config.className}Extension.delegate,');
      print('     GlobalMaterialLocalizations.delegate,');
      print('   ],');
      print('   supportedLocales: ${config.className}.supportedLocales,');
    } catch (e, stack) {
      print('Error: $e');
      if (watch) {
        print('Stack trace: $stack');
      }
      exit(1);
    }
  }

  /// Convert PascalCase to snake_case
  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .substring(1); // Remove leading underscore
  }
}
