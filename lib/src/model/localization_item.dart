import 'package:localization_gen/src/const/constants.dart';

/// Represents a single localization entry from JSON file
class LocalizationItem {
  /// The key identifier for this localization entry (e.g., 'auth.login.title')
  final String key;

  /// The translated text value
  final String value;

  /// List of parameter names extracted from placeholders (e.g., ['name', 'count'])
  final List<String> parameters;

  /// Optional description for this localization entry
  final String? description;

  /// Optional example usage string for this localization entry.
  ///
  /// Sourced from inline metadata: `@example`.
  final String? example;

  /// Optional placeholder documentation for this localization entry.
  ///
  /// Sourced from inline metadata: `@placeholders`.
  final Map<String, String>? placeholderDocs;

  /// Additional metadata associated with this entry
  final Map<String, dynamic>? metadata;

  /// Pluralization forms (zero, one, two, few, many, other)
  final Map<String, String>? pluralForms;

  /// Gender-based forms (male, female, other)
  final Map<String, String>? genderForms;

  /// Context-based variants
  final Map<String, String>? contextForms;

  /// Creates a new LocalizationItem
  ///
  /// The [key] parameter is the dot-notation key for the translation.
  /// The [value] parameter is the translated text, which may contain placeholders.
  /// The [parameters] parameter lists parameter names found in the value.
  /// The [description] parameter provides optional documentation.
  /// The [metadata] parameter stores additional information.
  /// The [pluralForms] parameter contains plural variants.
  /// The [genderForms] parameter contains gender-based variants.
  /// The [contextForms] parameter contains context-based variants.
  ///
  /// Example:
  /// ```dart
  /// final item = LocalizationItem(
  ///   key: 'welcome.message',
  ///   value: 'Hello {name}!',
  ///   parameters: ['name'],
  ///   description: 'Welcome message for users',
  /// );
  /// ```
  LocalizationItem({
    required this.key,
    required this.value,
    this.parameters = const [],
    this.description,
    this.example,
    this.placeholderDocs,
    this.metadata,
    this.pluralForms,
    this.genderForms,
    this.contextForms,
  });

  /// Returns true if this localization entry has parameters
  bool get hasParameters => parameters.isNotEmpty;

  /// Returns true if this localization entry has plural forms
  bool get hasPlurals => pluralForms != null && pluralForms!.isNotEmpty;

  /// Returns true if this localization entry has gender forms
  bool get hasGenders => genderForms != null && genderForms!.isNotEmpty;

  /// Returns true if this localization entry has context forms
  bool get hasContexts => contextForms != null && contextForms!.isNotEmpty;

  @override
  String toString() =>
      'LocalizationItem(key: $key, params: $parameters, plurals: $hasPlurals, genders: $hasGenders)';
}

/// Configuration from pubspec.yaml
class LocalizationConfig {
  /// Directory containing the localization JSON files
  final String inputDir;

  /// Directory where generated Dart files will be written
  final String outputDir;

  /// Name of the generated localization class
  final String className;

  /// File pattern for modular organization (e.g., 'app_{module}_{locale}.json')
  final String filePattern;

  /// Prefix for modular file names
  final String filePrefix;

  /// Field naming convention for generated Dart identifiers.
  ///
  /// Summary
  /// - Controls how **JSON key segments** are converted into **Dart identifiers**
  ///   in the generated API.
  /// - This does **not** change how your JSON is parsed or merged; it only affects
  ///   the names of Dart getters/methods/classes produced by the generator.
  ///
  /// Options (see `FieldRename`)
  /// - `none`
  /// - `kebab`
  /// - `snake`
  /// - `pascal`
  /// - `camel`
  /// - `screamingSnake`
  ///
  /// Rules / Conventions
  /// - Treat generated identifiers as **public API**. Changing [fieldRename]
  ///   after you ship will be a breaking change for app code.
  /// - The conversion is applied **per key segment**.
  ///   Example key path: `user_profile.first_name` contains segments
  ///   `user_profile` and `first_name`.
  /// - Keys that are invalid or awkward for Dart (e.g. containing `-` or spaces)
  ///   are best handled by choosing a rename mode that produces valid Dart names
  ///   (most projects use `camel` or `snake`).
  ///
  /// Examples
  /// - JSON path: `"user-profile": { "first-name": "..." }`
  ///   - `camel`   → `userProfile.firstName`
  ///   - `snake`   → `user_profile.first_name`
  ///   - `pascal`  → `UserProfile.FirstName`
  ///
  /// Default
  /// - Uses [kDefaultFieldRename].
  final String fieldRename;

  /// Output file suffix.
  ///
  /// Always '.gen.dart', so the output file looks like:
  /// - app_localizations.gen.dart
  ///
  /// Note: the `output_file_suffix` configuration option has been removed and is no longer used.
  static const String outputFileSuffix = kDefaultOutputFileSuffix;

  /// Creates a new LocalizationConfig with default values
  ///
  /// All parameters are optional and have sensible defaults:
  /// - [inputDir]: kDefaultInputDir
  /// - [outputDir]: kDefaultOutputDir
  /// - [className]: kDefaultClassName
  /// - [filePattern]: kDefaultFilePattern
  /// - [filePrefix]: kDefaultFilePrefix
  /// - [fieldRename]: kDefaultFieldRename
  LocalizationConfig({
    this.inputDir = kDefaultInputDir,
    this.outputDir = kDefaultOutputDir,
    this.className = kDefaultClassName,
    this.filePattern = kDefaultFilePattern,
    this.filePrefix = kDefaultFilePrefix,
    this.fieldRename = kDefaultFieldRename,
  });

  /// Creates a LocalizationConfig from a map of configuration values.
  ///
  /// Typically used to parse configuration from pubspec.yaml.
  /// Missing values will use defaults.
  factory LocalizationConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null) return LocalizationConfig();

    return LocalizationConfig(
      inputDir: map['input_dir'] as String? ?? kDefaultInputDir,
      outputDir: map['output_dir'] as String? ?? kDefaultOutputDir,
      className: map['class_name'] as String? ?? kDefaultClassName,
      filePattern: map['file_pattern'] as String? ?? kDefaultFilePattern,
      filePrefix: map['file_prefix'] as String? ?? kDefaultFilePrefix,
      fieldRename: map['field_rename'] as String? ?? kDefaultFieldRename,
    );
  }
}

/// Parsed locale data
class LocaleData {
  /// The locale identifier (e.g., 'en', 'es', 'id')
  final String locale;

  /// Optional module name for modular organization
  final String? module;

  /// Map of localization items keyed by their full path
  final Map<String, LocalizationItem> items;

  /// Creates a new LocaleData instance
  ///
  /// The [locale] parameter specifies the language code.
  /// The [module] parameter is optional and used in modular organization.
  /// The [items] parameter contains all localization entries for this locale.
  ///
  /// Example:
  /// ```dart
  /// final localeData = LocaleData(
  ///   locale: 'en',
  ///   items: {
  ///     'hello': LocalizationItem(key: 'hello', value: 'Hello'),
  ///   },
  /// );
  /// ```
  LocaleData({
    required this.locale,
    this.module,
    required this.items,
  });
}
