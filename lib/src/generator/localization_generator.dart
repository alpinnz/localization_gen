import 'dart:io';
import '../config/config_reader.dart';
import '../parser/json_parser.dart';
import '../writer/dart_writer.dart';

/// Main generator that orchestrates the entire process
class LocalizationGenerator {
  final bool watch;
  final String? configPath;

  LocalizationGenerator({
    this.watch = false,
    this.configPath,
  });

  /// Run the generation process
  void generate() {
    try {
      print('🚀 Starting localization generation...\n');

      // Step 1: Read config
      final config = ConfigReader.read(configPath ?? 'pubspec.yaml');
      print('📝 Config:');
      print('   Input:  ${config.inputDir}');
      print('   Output: ${config.outputDir}');
      print('   Class:  ${config.className}\n');

      // Step 2: Parse JSON files
      print('📂 Scanning JSON localization files...');
      final locales = JsonLocalizationParser.parseDirectory(config.inputDir);
      print('✅ Found ${locales.length} locale(s): ${locales.map((l) => l.locale).join(', ')}\n');

      if (locales.isEmpty) {
        print('❌ No locales found!');
        return;
      }

      // Step 3: Generate Dart code
      print('⚙️  Generating Dart code...');
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

      final outputFile = File('${config.outputDir}/${_toSnakeCase(config.className)}.dart');
      outputFile.writeAsStringSync(dartCode);

      print('✅ Generated: ${outputFile.path}');
      print('\n🎉 Done! Generated ${locales.first.items.length} translations.');
      print('\n📌 Add this to your MaterialApp:');
      print('   localizationsDelegates: [');
      print('     ${config.className}Extension.delegate,');
      print('     GlobalMaterialLocalizations.delegate,');
      print('   ],');
      print('   supportedLocales: ${config.className}.supportedLocales,');
    } catch (e, stack) {
      print('❌ Error: $e');
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

