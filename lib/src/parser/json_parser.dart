import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/exceptions/exceptions.dart';

/// Parses JSON localization files with nested structure support.
///
/// This class handles reading and parsing of JSON files containing translations.
/// It supports:
/// - Nested JSON structures (converted to dot-notation)
/// - Parameter placeholders ({name}, {count}, etc.)
/// - Pluralization forms (@plural)
/// - Gender forms (@gender)
/// - Context forms (@context)
/// - Metadata and descriptions (@key notation)
///
/// Example usage:
/// ```dart
/// // Parse a single file
/// final file = File('assets/localizations/app_common_en.json');
/// final localeData = JsonLocalizationParser.parse(file);
///
/// // Parse a directory
/// final locales = JsonLocalizationParser.parseDirectory(
///   'assets/localizations',
/// );
/// ```
class JsonLocalizationParser {
  /// Creates a new JsonLocalizationParser instance.
  JsonLocalizationParser();

  /// Parses a single JSON file with nested structure
  ///
  /// The [file] parameter specifies the JSON file to parse.
  /// Returns a [LocaleData] object containing the parsed translations.
  ///
  /// The locale is extracted from either the @@locale key in the JSON
  /// or from the filename (e.g., 'app_common_en.json' -> 'en').
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
  /// final file = File('assets/localizations/app_common_en.json');
  /// final localeData = JsonLocalizationParser.parse(file);
  /// ```
  static LocaleData parse(File file) {
    try {
      if (!file.existsSync()) {
        throw FileOperationException(
          'File does not exist',
          operation: 'read',
          filePath: file.path,
        );
      }

      final content = file.readAsStringSync();

      if (content.trim().isEmpty) {
        throw JsonParseException(
          'JSON file is empty',
          filePath: file.path,
        );
      }

      final dynamic decoded;
      try {
        decoded = jsonDecode(content);
      } catch (e) {
        throw JsonParseException(
          'Invalid JSON format: $e',
          filePath: file.path,
          jsonContent: content,
        );
      }

      if (decoded is! Map<String, dynamic>) {
        throw JsonParseException(
          'JSON root must be an object, got ${decoded.runtimeType}',
          filePath: file.path,
        );
      }

      final json = decoded;

      // Extract locale from @@locale or filename
      String locale =
          json['@@locale'] as String? ?? _extractLocaleFromFilename(file.path);

      final items = <String, LocalizationItem>{};

      // Flatten nested JSON structure
      _flattenJson(json, items, filePath: file.path);

      return LocaleData(locale: locale, items: items);
    } on LocalizationException {
      rethrow;
    } catch (e) {
      throw JsonParseException(
        'Unexpected error parsing file: $e',
        filePath: file.path,
      );
    }
  }

  /// Recursively flatten nested JSON to dot-notation keys
  /// Example: {"auth": {"login": "Login"}} -> {"auth.login": "Login"}
  /// Supports pluralization, gender, and context forms
  static void _flattenJson(
    Map<String, dynamic> json,
    Map<String, LocalizationItem> items, {
    String prefix = '',
    String? filePath,
  }) {
    for (final entry in json.entries) {
      final key = entry.key;

      // Skip metadata keys
      if (key.startsWith('@@') || key.startsWith('@')) continue;

      final value = entry.value;
      final fullKey = prefix.isEmpty ? key : '$prefix.$key';

      if (value is Map<String, dynamic>) {
        // String value wrapper with inline metadata:
        // {
        //   "@value": "Welcome, {name}.",
        //   "@description": "...",
        //   "@example": "...",
        //   "@placeholders": {"name": "..."}
        // }
        if (value.containsKey('@value') && value['@value'] is String) {
          final wrappedValue = value['@value'] as String;
          final parameters = _extractParameters(wrappedValue);
          final keyMeta = _readInlineKeyMetadata(value);

          items[fullKey] = LocalizationItem(
            key: fullKey,
            value: wrappedValue,
            parameters: parameters,
            description: keyMeta.description,
            example: keyMeta.example,
            placeholderDocs: keyMeta.placeholderDocs,
            metadata: keyMeta.additional,
          );
          continue;
        }

        if (value.containsKey('@plural')) {
          // Pluralization: {"@plural": {"zero": "...", "one": "...", "other": "..."}}
          final pluralMap = value['@plural'] as Map<String, dynamic>;
          final pluralForms = <String, String>{};
          final allParams = <String>{};

          for (final pluralEntry in pluralMap.entries) {
            if (pluralEntry.value is String) {
              pluralForms[pluralEntry.key] = pluralEntry.value as String;
              allParams.addAll(_extractParameters(pluralEntry.value as String));
            }
          }

          final keyMeta = _readInlineKeyMetadata(value);

          items[fullKey] = LocalizationItem(
            key: fullKey,
            value: pluralForms['other'] ?? pluralForms.values.first,
            parameters: allParams.toList(),
            description: keyMeta.description,
            example: keyMeta.example,
            placeholderDocs: keyMeta.placeholderDocs,
            metadata: keyMeta.additional,
            pluralForms: pluralForms,
          );
        } else if (value.containsKey('@gender')) {
          // Gender forms: {"@gender": {"male": "...", "female": "...", "other": "..."}}
          final genderMap = value['@gender'] as Map<String, dynamic>;
          final genderForms = <String, String>{};
          final allParams = <String>{};

          for (final genderEntry in genderMap.entries) {
            if (genderEntry.value is String) {
              genderForms[genderEntry.key] = genderEntry.value as String;
              allParams.addAll(_extractParameters(genderEntry.value as String));
            }
          }

          final keyMeta = _readInlineKeyMetadata(value);

          items[fullKey] = LocalizationItem(
            key: fullKey,
            value: genderForms['other'] ?? genderForms.values.first,
            parameters: allParams.toList(),
            description: keyMeta.description,
            example: keyMeta.example,
            placeholderDocs: keyMeta.placeholderDocs,
            metadata: keyMeta.additional,
            genderForms: genderForms,
          );
        } else if (value.containsKey('@context')) {
          // Context forms: {"@context": {"formal": "...", "informal": "..."}}
          final contextMap = value['@context'] as Map<String, dynamic>;
          final contextForms = <String, String>{};
          final allParams = <String>{};

          for (final contextEntry in contextMap.entries) {
            if (contextEntry.value is String) {
              contextForms[contextEntry.key] = contextEntry.value as String;
              allParams
                  .addAll(_extractParameters(contextEntry.value as String));
            }
          }

          final keyMeta = _readInlineKeyMetadata(value);

          items[fullKey] = LocalizationItem(
            key: fullKey,
            value: contextForms.values.first,
            parameters: allParams.toList(),
            description: keyMeta.description,
            example: keyMeta.example,
            placeholderDocs: keyMeta.placeholderDocs,
            metadata: keyMeta.additional,
            contextForms: contextForms,
          );
        } else {
          // Regular nested object, recurse deeper
          _flattenJson(value, items, prefix: fullKey, filePath: filePath);
        }
      } else if (value is String) {
        // Extract parameters from placeholders like {name}, {count}, etc.
        final parameters = _extractParameters(value);

        // Inline metadata is not possible for raw string values.
        // If you need metadata, wrap the string into an object form.
        const keyMeta = _KeyMetadata();

        items[fullKey] = LocalizationItem(
          key: fullKey,
          value: value,
          parameters: parameters,
          description: keyMeta.description,
          example: keyMeta.example,
          placeholderDocs: keyMeta.placeholderDocs,
          metadata: keyMeta.additional,
        );
      } else if (value != null) {
        // Warn about unsupported value types
        print(
            'Warning: Unsupported value type ${value.runtimeType} for key "$fullKey"${filePath != null ? ' in $filePath' : ''}');
      }
    }
  }

  /// Parses all JSON files in a directory.
  ///
  /// This package uses **modular-only** localization files.
  ///
  /// The [dirPath] parameter specifies the directory containing JSON files.
  /// The [filePrefix] parameter specifies the prefix for modular files.
  ///
  /// Returns a list of [LocaleData] objects, one per locale.
  ///
  /// Modular files like 'app_auth_en.json' and 'app_home_en.json'
  /// are merged into a single 'en' locale.
  ///
  /// Throws an [Exception] if the directory doesn't exist or contains no JSON files.
  ///
  /// Example:
  /// ```dart
  /// final locales = JsonLocalizationParser.parseDirectory(
  ///   'assets/localizations',
  ///   modular: true,
  ///   filePrefix: 'app',
  /// );
  /// ```
  static List<LocaleData> parseDirectory(
    String dirPath, {
    String filePrefix = 'app',
  }) {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      throw FileOperationException(
        'Directory not found',
        operation: 'read',
        filePath: dirPath,
      );
    }

    final jsonFiles = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.extension(f.path).toLowerCase() == '.json')
        .toList();

    if (jsonFiles.isEmpty) {
      throw FileOperationException(
        'No .json files found in directory',
        operation: 'scan',
        filePath: dirPath,
      );
    }

    // Modular-only: merge files by locale.
    final locales = _parseModularFiles(jsonFiles, filePrefix);

    if (locales.length > 1) {
      _validateLocaleConsistency(locales);
    }

    return locales;
  }

  /// Parses modular localization files and merges by locale.
  ///
  /// In modular mode, multiple JSON files for the same locale are merged together.
  ///
  /// The [jsonFiles] parameter contains all JSON files in the directory.
  /// The [filePrefix] parameter specifies the expected file prefix.
  ///
  /// Returns a list of merged [LocaleData] objects.
  ///
  /// Example:
  /// ```
  /// app_auth_en.json + app_home_en.json -> merged 'en' locale
  /// app_auth_id.json + app_home_id.json -> merged 'id' locale
  /// ```
  static List<LocaleData> _parseModularFiles(
      List<File> jsonFiles, String filePrefix) {
    final localeMap = <String, Map<String, LocalizationItem>>{};

    for (final file in jsonFiles) {
      final filename = p.basename(file.path);

      // Skip files that don't match the pattern
      if (!filename.startsWith(filePrefix)) continue;

      print('Parsing modular file: ${file.path}');

      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;

      final locale = json['@@locale'] as String? ??
          _extractLocaleFromModularFilename(filename, filePrefix);

      final module = json['@@module'] as String?;
      if (module == null || module.trim().isEmpty) {
        throw JsonParseException(
          'Missing required "@@module" metadata (modular-only)',
          filePath: file.path,
          jsonContent: content,
        );
      }

      print('  Module: $module, Locale: $locale');

      if (!localeMap.containsKey(locale)) {
        localeMap[locale] = <String, LocalizationItem>{};
      }

      final items = <String, LocalizationItem>{};
      _flattenJson(json, items, filePath: file.path);

      localeMap[locale]!.addAll(items);
    }

    // Convert to LocaleData list
    final locales = localeMap.entries.map((entry) {
      print(
          'Merged locale "${entry.key}" with ${entry.value.length} translations');
      return LocaleData(
        locale: entry.key,
        items: entry.value,
      );
    }).toList();

    locales.sort((a, b) => a.locale.compareTo(b.locale));
    return locales;
  }

  static _KeyMetadata _readInlineKeyMetadata(Map<String, dynamic> value) {
    // Inline metadata style (no sibling blocks):
    //
    //  {
    //    "@description": "...",
    //    "@example": "...",
    //    "@placeholders": {"name": "..."},
    //    "@since": "1.4.1",
    //    "@deprecated": false
    //  }
    final description = value['@description'] as String?;
    final example = value['@example'] as String?;

    Map<String, String>? placeholderDocs;
    final placeholdersRaw = value['@placeholders'];
    if (placeholdersRaw is Map) {
      placeholderDocs =
          placeholdersRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    final additional = <String, dynamic>{};
    for (final e in value.entries) {
      if (!e.key.startsWith('@')) continue;
      // reserved translation structures
      if (e.key == '@plural' || e.key == '@gender' || e.key == '@context')
        continue;
      // known doc fields
      if (e.key == '@description' ||
          e.key == '@example' ||
          e.key == '@placeholders') {
        continue;
      }
      additional[e.key.substring(1)] = e.value;
    }

    return _KeyMetadata(
      description: description,
      example: example,
      placeholderDocs: placeholderDocs,
      additional: additional.isEmpty ? null : additional,
    );
  }

  /// Extract locale from modular filename like "app_auth_en.json" -> "en".
  static String _extractLocaleFromModularFilename(
      String filename, String filePrefix) {
    final base = p.withoutExtension(filename);
    final parts = base.split('_');
    // Pattern: {prefix}_{module}_{locale}.json
    if (parts.length >= 3) {
      return parts.last;
    }
    return parts.isNotEmpty ? parts.last : 'en';
  }

  /// Extract parameters from string like "Welcome {name}" -> ["name"].
  static List<String> _extractParameters(String text) {
    final regex = RegExp(r'\{(\w+)\}');
    final matches = regex.allMatches(text);
    return matches.map((m) => m.group(1)!).toList();
  }

  /// Extract locale from filename like "app_common_en.json" -> "en".
  static String _extractLocaleFromFilename(String path) {
    final filename = p.basename(path);
    final base = p.withoutExtension(filename);
    final parts = base.split('_');
    return parts.isNotEmpty ? parts.last : 'en';
  }

  /// Validates consistency across multiple locales.
  ///
  /// Ensures all locales have the same keys and matching parameters for
  /// each translation.
  static void _validateLocaleConsistency(List<LocaleData> locales) {
    if (locales.isEmpty) return;

    final baseLocale = locales.first;
    final baseKeys = baseLocale.items.keys.toSet();

    for (var i = 1; i < locales.length; i++) {
      final locale = locales[i];
      final localeKeys = locale.items.keys.toSet();

      final missingKeys = baseKeys.difference(localeKeys).toList();
      if (missingKeys.isNotEmpty) {
        throw LocaleValidationException(
          'Locale has missing translation keys compared to base locale "${baseLocale.locale}"',
          locale: locale.locale,
          missingKeys: missingKeys,
        );
      }

      final extraKeys = localeKeys.difference(baseKeys).toList();
      if (extraKeys.isNotEmpty) {
        throw LocaleValidationException(
          'Locale has extra translation keys not in base locale "${baseLocale.locale}"',
          locale: locale.locale,
          extraKeys: extraKeys,
        );
      }

      for (final key in baseKeys) {
        final baseItem = baseLocale.items[key]!;
        final localeItem = locale.items[key]!;

        if (baseItem.parameters.length != localeItem.parameters.length ||
            !_parametersMatch(baseItem.parameters, localeItem.parameters)) {
          throw ParameterException(
            'Parameter mismatch between locales "${baseLocale.locale}" and "${locale.locale}"',
            key: key,
            expectedParameters: baseItem.parameters,
            actualParameters: localeItem.parameters,
          );
        }
      }
    }
  }

  static bool _parametersMatch(List<String> params1, List<String> params2) {
    if (params1.length != params2.length) return false;
    final set1 = params1.toSet();
    final set2 = params2.toSet();
    return set1.length == set2.length && set1.containsAll(set2);
  }
}

class _KeyMetadata {
  final String? description;
  final String? example;
  final Map<String, String>? placeholderDocs;
  final Map<String, dynamic>? additional;

  const _KeyMetadata({
    this.description,
    this.example,
    this.placeholderDocs,
    this.additional,
  });
}
