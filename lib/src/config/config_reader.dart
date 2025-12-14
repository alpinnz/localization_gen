import 'dart:io';
import 'package:yaml/yaml.dart';
import '../model/localization_item.dart';

/// Reads configuration from pubspec.yaml
class ConfigReader {
  static LocalizationConfig read([String pubspecPath = 'pubspec.yaml']) {
    try {
      final file = File(pubspecPath);
      if (!file.existsSync()) {
        print('⚠️  pubspec.yaml not found, using default config');
        return LocalizationConfig();
      }

      final content = file.readAsStringSync();
      final yaml = loadYaml(content) as YamlMap;

      final config = yaml['localization_gen'] as YamlMap?;
      if (config == null) {
        print('⚠️  No localization_gen config found in pubspec.yaml');
        return LocalizationConfig();
      }

      return LocalizationConfig.fromMap(
        Map<String, dynamic>.from(config),
      );
    } catch (e) {
      print('❌ Error reading config: $e');
      return LocalizationConfig();
    }
  }
}

