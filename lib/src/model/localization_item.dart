/// Represents a single localization entry from JSON file
class LocalizationItem {
  final String key;
  final String value;
  final List<String> parameters;
  final String? description;
  final Map<String, dynamic>? metadata;

  LocalizationItem({
    required this.key,
    required this.value,
    this.parameters = const [],
    this.description,
    this.metadata,
  });

  bool get hasParameters => parameters.isNotEmpty;

  @override
  String toString() => 'LocalizationItem(key: $key, params: $parameters)';
}

/// Configuration from pubspec.yaml
class LocalizationConfig {
  final String inputDir;
  final String outputDir;
  final String className;
  final bool useContext;
  final bool nullable;

  LocalizationConfig({
    this.inputDir = 'assets/localizations',
    this.outputDir = 'lib/assets',
    this.className = 'AppLocalizations',
    this.useContext = true,
    this.nullable = false,
  });

  factory LocalizationConfig.fromMap(Map<String, dynamic>? map) {
    if (map == null) return LocalizationConfig();

    return LocalizationConfig(
      inputDir: map['input_dir'] as String? ?? 'assets/localizations',
      outputDir: map['output_dir'] as String? ?? 'lib/assets',
      className: map['class_name'] as String? ?? 'AppLocalizations',
      useContext: map['use_context'] as bool? ?? true,
      nullable: map['nullable'] as bool? ?? false,
    );
  }
}

/// Parsed locale data
class LocaleData {
  final String locale;
  final Map<String, LocalizationItem> items;

  LocaleData({
    required this.locale,
    required this.items,
  });
}

