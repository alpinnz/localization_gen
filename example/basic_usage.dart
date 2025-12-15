/// Example demonstrating basic usage of localization_gen.
///
/// This example shows how to:
/// - Generate localizations from JSON files
/// - Use the generated code in a simple Dart application
library;
import 'package:localization_gen/localization_gen.dart';
void main() {
  // Create a localization generator instance
  final generator = LocalizationGenerator();
  // Run the generation process
  // This will:
  // 1. Read configuration from pubspec.yaml
  // 2. Parse JSON localization files
  // 3. Generate type-safe Dart code
  // 4. Write the output to the specified directory
  generator.generate();
  print('Localization generation completed successfully!');
}
