import 'dart:io';
import 'package:yaml/yaml.dart';
import '../model/localization_item.dart';

/// Reads and parses localization configuration from pubspec.yaml.
///
/// This class is responsible for loading configuration settings that control
/// how localization files are processed and generated. It reads the
/// `localization_gen` section from pubspec.yaml.
///
/// Configuration options include:
/// - `input_dir`: Directory containing JSON localization files
/// - `output_dir`: Directory for generated Dart files
/// - `class_name`: Name of the generated localization class
/// - `use_context`: Whether to generate BuildContext helper
/// - `nullable`: Whether the context helper returns nullable type
/// - `modular`: Enable modular file organization
/// - `file_pattern`: Pattern for modular files
/// - `file_prefix`: Prefix for modular files
/// - `strict_validation`: Enable strict locale validation
///
/// Example usage:
/// ```dart
/// final config = ConfigReader.read('pubspec.yaml');
/// print(config.className); // 'AppLocalizations'
/// print(config.inputDir);  // 'assets/localizations'
/// ```
class ConfigReader {
  /// Creates a new ConfigReader instance.
  ConfigReader();

  /// Reads localization configuration from pubspec.yaml
  ///
  /// The [pubspecPath] parameter specifies the path to pubspec.yaml file.
  /// Defaults to 'pubspec.yaml' in the current directory.
  ///
  /// Returns a [LocalizationConfig] with default values if no configuration
  /// is found or if an error occurs during reading.
  ///
  /// Example:
  /// ```dart
  /// final config = ConfigReader.read('pubspec.yaml');
  /// print(config.inputDir); // 'assets/localizations'
  /// ```
  static LocalizationConfig read([String pubspecPath = 'pubspec.yaml']) {
    try {
      final file = File(pubspecPath);
      if (!file.existsSync()) {
        print('Warning: pubspec.yaml not found, using default config');
        return LocalizationConfig();
      }

      final content = file.readAsStringSync();
      final yaml = loadYaml(content) as YamlMap;

      final config = yaml['localization_gen'] as YamlMap?;
      if (config == null) {
        print('Warning: No localization_gen config found in pubspec.yaml');
        return LocalizationConfig();
      }

      return LocalizationConfig.fromMap(
        Map<String, dynamic>.from(config),
      );
    } catch (e) {
      print('Error reading config: $e');
      return LocalizationConfig();
    }
  }
}
