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

  /// Additional metadata associated with this entry
  final Map<String, dynamic>? metadata;

  /// Creates a new LocalizationItem
  ///
  /// The [key] parameter is the dot-notation key for the translation.
  /// The [value] parameter is the translated text, which may contain placeholders.
  /// The [parameters] parameter lists parameter names found in the value.
  /// The [description] parameter provides optional documentation.
  /// The [metadata] parameter stores additional information.
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
    this.metadata,
  });

  /// Returns true if this localization entry has parameters
  bool get hasParameters => parameters.isNotEmpty;

  @override
  String toString() => 'LocalizationItem(key: $key, params: $parameters)';
}

/// Configuration from pubspec.yaml
class LocalizationConfig {
  /// Directory containing the localization JSON files
  final String inputDir;

  /// Directory where generated Dart files will be written
  final String outputDir;

  /// Name of the generated localization class
  final String className;

  /// Whether to generate static of(BuildContext) method
  final bool useContext;

  /// Whether the of(BuildContext) method returns a nullable type
  final bool nullable;

  /// Whether to use modular file organization
  final bool modular;

  /// File pattern for modular organization (e.g., 'app_{module}_{locale}.json')
  final String filePattern;

  /// Prefix for modular file names
  final String filePrefix;

  /// Whether to enable strict validation of locale consistency
  final bool strictValidation;

  /// Creates a new LocalizationConfig with default values
  ///
  /// All parameters are optional and have sensible defaults:
  /// - [inputDir]: 'assets/localizations'
  /// - [outputDir]: 'lib/assets'
  /// - [className]: 'AppLocalizations'
  /// - [useContext]: true
  /// - [nullable]: false
  /// - [modular]: false
  /// - [filePattern]: 'app_{module}_{locale}.json'
  /// - [filePrefix]: 'app'
  /// - [strictValidation]: false
  LocalizationConfig({
    this.inputDir = 'assets/localizations',
    this.outputDir = 'lib/assets',
    this.className = 'AppLocalizations',
    this.useContext = true,
    this.nullable = false,
    this.modular = false,
    this.filePattern = 'app_{module}_{locale}.json',
    this.filePrefix = 'app',
    this.strictValidation = false,
  });

  /// Creates a LocalizationConfig from a map of configuration values
  ///
  /// Typically used to parse configuration from pubspec.yaml.
  /// Missing values will use defaults.
  ///
  /// Example:
  /// ```dart
  /// final config = LocalizationConfig.fromMap({
  ///   'input_dir': 'assets/i18n',
  ///   'class_name': 'L10n',
  /// });
  /// ```
  factory LocalizationConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null) return LocalizationConfig();

    return LocalizationConfig(
      inputDir: map['input_dir'] as String? ?? 'assets/localizations',
      outputDir: map['output_dir'] as String? ?? 'lib/assets',
      className: map['class_name'] as String? ?? 'AppLocalizations',
      useContext: map['use_context'] as bool? ?? true,
      nullable: map['nullable'] as bool? ?? false,
      modular: map['modular'] as bool? ?? false,
      filePattern:
          map['file_pattern'] as String? ?? 'app_{module}_{locale}.json',
      filePrefix: map['file_prefix'] as String? ?? 'app',
      strictValidation: map['strict_validation'] as bool? ?? false,
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
