import 'dart:convert';
import 'dart:io';
import '../model/localization_item.dart';

/// Parses JSON localization files with nested structure support
class JsonLocalizationParser {
  /// Parse a single JSON file with nested structure
  static LocaleData parse(File file) {
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;

    // Extract locale from @@locale or filename
    String locale = json['@@locale'] as String? ?? _extractLocaleFromFilename(file.path);

    final items = <String, LocalizationItem>{};

    // Flatten nested JSON structure
    _flattenJson(json, items);

    return LocaleData(locale: locale, items: items);
  }

  /// Recursively flatten nested JSON to dot-notation keys
  /// Example: {"auth": {"login": "Login"}} -> {"auth.login": "Login"}
  static void _flattenJson(
    Map<String, dynamic> json,
    Map<String, LocalizationItem> items, {
    String prefix = '',
  }) {
    for (final entry in json.entries) {
      final key = entry.key;

      // Skip metadata keys
      if (key.startsWith('@@') || key.startsWith('@')) continue;

      final value = entry.value;
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';

      if (value is Map<String, dynamic>) {
        // Recursively flatten nested objects
        _flattenJson(value, items, prefix: fullKey);
      } else if (value is String) {
        // Extract parameters from placeholders like {name}, {count}, etc.
        final parameters = _extractParameters(value);

        // Try to get description from @key metadata
        String? description;
        final metadataKey = '@$key';
        if (json.containsKey(metadataKey)) {
          final metadata = json[metadataKey] as Map<String, dynamic>?;
          description = metadata?['description'] as String?;
        }

        items[fullKey] = LocalizationItem(
          key: fullKey,
          value: value,
          parameters: parameters,
          description: description,
        );
      }
    }
  }

  /// Parse all JSON files in a directory
  static List<LocaleData> parseDirectory(String dirPath) {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      throw Exception('Directory not found: $dirPath');
    }

    final jsonFiles = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();

    if (jsonFiles.isEmpty) {
      throw Exception('No .json files found in: $dirPath');
    }

    return jsonFiles.map((file) {
      print('Parsing: ${file.path}');
      return parse(file);
    }).toList();
  }

  /// Extract parameters from string like "Welcome {name}" -> ["name"]
  static List<String> _extractParameters(String text) {
    final regex = RegExp(r'\{(\w+)\}');
    final matches = regex.allMatches(text);
    return matches.map((m) => m.group(1)!).toList();
  }

  /// Extract locale from filename like "app_en.json" -> "en"
  static String _extractLocaleFromFilename(String path) {
    final filename = path.split('/').last;
    final parts = filename.replaceAll('.json', '').split('_');
    return parts.length > 1 ? parts.last : 'en';
  }
}

