import 'dart:io';
import 'package:yaml/yaml.dart';

import 'package:localization_gen/src/model/localization_item.dart';

/// Reads and parses localization configuration from pubspec.yaml.
///
/// This class is responsible for loading configuration settings that control
/// how localization files are processed and generated. It reads the
/// `localization_gen` section from pubspec.yaml.
///
/// Configuration options include:
/// - `input_dir`: Directory containing JSON localization files (required)
/// - `output_dir`: Directory for generated Dart files
/// - `class_name`: Name of the generated localization class
/// - `file_pattern`: Pattern for modular files (default: app_{module}_{locale}.json)
/// - `file_prefix`: Prefix for modular files (default: app)
/// - `field_rename`: Naming convention for generated identifiers
///
/// Mandatory (not configurable):
/// - BuildContext helper is always generated
/// - of(context) is always non-nullable
/// - Modular file mode is always enabled
/// - Strict validation is always enabled
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
    final file = File(pubspecPath);
    if (!file.existsSync()) {
      throw Exception('Config file not found: $pubspecPath');
    }

    final content = file.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;

    final config = yaml['localization_gen'] as YamlMap?;
    if (config == null) {
      throw Exception('Missing "localization_gen" section in $pubspecPath');
    }

    final map = Map<String, dynamic>.from(config);

    final inputDir = (map['input_dir'] as String?)?.trim();
    if (inputDir == null || inputDir.isEmpty) {
      throw Exception('Missing required "input_dir" in $pubspecPath');
    }

    return LocalizationConfig.fromMap(map);
  }
}
