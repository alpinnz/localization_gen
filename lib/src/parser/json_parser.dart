import 'dart:convert';
import 'dart:io';
import '../model/localization_item.dart';

/// Parses JSON localization files with nested structure support
class JsonLocalizationParser {
  /// Creates a new JsonLocalizationParser instance
  JsonLocalizationParser();

  /// Parses a single JSON file with nested structure
  ///
  /// The [file] parameter specifies the JSON file to parse.
  /// Returns a [LocaleData] object containing the parsed translations.
  ///
  /// The locale is extracted from either the @@locale key in the JSON
  /// or from the filename (e.g., 'app_en.json' -> 'en').
  ///
  /// Nested JSON structures are flattened to dot-notation:
  /// ```json
  /// {"auth": {"login": "Login"}}
  /// ```
  /// becomes:
  /// ```
  /// "auth.login": "Login"
  /// ```
  ///
  /// Example:
  /// ```dart
  /// final file = File('assets/localizations/app_en.json');
  /// final localeData = JsonLocalizationParser.parse(file);
  /// ```
  static LocaleData parse(File file) {
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;

    // Extract locale from @@locale or filename
    String locale =
        json['@@locale'] as String? ?? _extractLocaleFromFilename(file.path);

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

  /// Parses all JSON files in a directory
  ///
  /// The [dirPath] parameter specifies the directory containing JSON files.
  /// The [modular] parameter enables modular file organization.
  /// The [filePrefix] parameter specifies the prefix for modular files.
  ///
  /// Returns a list of [LocaleData] objects, one per locale.
  ///
  /// In modular mode, files like 'app_auth_en.json' and 'app_home_en.json'
  /// are merged into a single 'en' locale.
  ///
  /// Throws an [Exception] if the directory doesn't exist or contains no JSON files.
  ///
  /// Example:
  /// ```dart
  /// // Standard mode
  /// final locales = JsonLocalizationParser.parseDirectory('assets/localizations');
  ///
  /// // Modular mode
  /// final locales = JsonLocalizationParser.parseDirectory(
  ///   'assets/localizations',
  ///   modular: true,
  ///   filePrefix: 'app',
  /// );
  /// ```
  static List<LocaleData> parseDirectory(String dirPath,
      {bool modular = false, String filePrefix = 'app'}) {
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

    if (modular) {
      return _parseModularFiles(jsonFiles, filePrefix);
    } else {
      return jsonFiles.map((file) {
        print('Parsing: ${file.path}');
        return parse(file);
      }).toList();
    }
  }

  /// Parse modular localization files and merge by locale
  /// Example: app_auth_en.json + app_home_en.json -> merged en locale
  static List<LocaleData> _parseModularFiles(
      List<File> jsonFiles, String filePrefix) {
    final localeMap = <String, Map<String, LocalizationItem>>{};

    for (final file in jsonFiles) {
      final filename = file.path.split('/').last;

      // Skip files that don't match the pattern
      if (!filename.startsWith(filePrefix)) continue;

      print('Parsing modular file: ${file.path}');

      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Extract locale from @@locale or filename
      String locale = json['@@locale'] as String? ??
          _extractLocaleFromModularFilename(filename, filePrefix);
      String? module = json['@@module'] as String?;

      if (module != null) {
        print('  Module: $module, Locale: $locale');
      }

      // Initialize locale map if not exists
      if (!localeMap.containsKey(locale)) {
        localeMap[locale] = <String, LocalizationItem>{};
      }

      // Flatten and add to locale map
      final items = <String, LocalizationItem>{};
      _flattenJson(json, items);

      // Merge items into locale map
      localeMap[locale]!.addAll(items);
    }

    // Convert to LocaleData list
    return localeMap.entries.map((entry) {
      print(
          'Merged locale "${entry.key}" with ${entry.value.length} translations');
      return LocaleData(
        locale: entry.key,
        items: entry.value,
      );
    }).toList();
  }

  /// Extract locale from modular filename like "app_auth_en.json" -> "en"
  /// or "core_common_id.json" -> "id"
  static String _extractLocaleFromModularFilename(
      String filename, String filePrefix) {
    final parts = filename.replaceAll('.json', '').split('_');
    // Pattern: {prefix}_{module}_{locale}.json
    // Example: app_auth_en.json -> ["app", "auth", "en"]
    if (parts.length >= 3) {
      return parts.last; // Return last part as locale
    }
    // Fallback: try to extract locale from standard pattern
    return parts.length > 1 ? parts.last : 'en';
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
