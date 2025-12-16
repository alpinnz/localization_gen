/// Example demonstrating custom configuration for localization_gen.
///
/// This example shows how to use a custom pubspec.yaml path
library;

import 'package:localization_gen/localization_gen.dart';

void main() {
  // Create a generator with custom configuration path
  final generator = LocalizationGenerator(
    configPath: 'custom_pubspec.yaml',
  );
  // Generate localizations
  generator.generate();
  print('Custom configuration example completed!');
}
