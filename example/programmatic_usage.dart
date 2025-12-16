/// Example demonstrating programmatic use of localization components.
///
/// This example shows how to use individual components of the package
library;

import 'dart:io';
import 'package:localization_gen/localization_gen.dart';

void main() {
  print('=== Localization Gen Component Example ===\n');

  // 1. Read configuration
  print('Step 1: Reading configuration...');
  final config = ConfigReader.read('pubspec.yaml');
  print('  Input directory: ${config.inputDir}');
  print('  Output directory: ${config.outputDir}');
  print('  Class name: ${config.className}');
  print('  Modular mode: ${config.modular}\n');

  // 2. Parse JSON files
  print('Step 2: Parsing JSON files...');
  try {
    final locales = JsonLocalizationParser.parseDirectory(
      config.inputDir,
      modular: config.modular,
      filePrefix: config.filePrefix,
    );
    print('  Found ${locales.length} locale(s)');

    for (final locale in locales) {
      print('  - ${locale.locale}: ${locale.items.length} translations');
    }
    print('');

    // 3. Generate Dart code
    print('Step 3: Generating Dart code...');
    final writer = DartWriter(
      className: config.className,
      useContext: config.useContext,
      nullable: config.nullable,
    );

    final dartCode = writer.generate(locales);
    print('  Generated ${dartCode.length} characters of Dart code\n');

    // 4. Write output
    print('Step 4: Writing output...');
    final outputDir = Directory(config.outputDir);
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final outputFile = File('${config.outputDir}/example_output.dart');
    outputFile.writeAsStringSync(dartCode);
    print('  Written to: ${outputFile.path}');

    print('\n=== Example completed successfully! ===');
  } catch (e) {
    print('Error: $e');
  }
}
