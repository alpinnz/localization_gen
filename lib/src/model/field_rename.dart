/// Field naming convention for generated Dart code.
///
/// Defines how JSON keys should be converted to Dart field names.
enum FieldRename {
  /// Use the field name without changes.
  ///
  /// Example: `userName` → `userName`
  none,

  /// Encodes a field named `kebabCase` with a JSON key `kebab-case`.
  ///
  /// Example: `userName` → `user-name`
  kebab,

  /// Encodes a field named `snakeCase` with a JSON key `snake_case`.
  ///
  /// Example: `userName` → `user_name`
  snake,

  /// Encodes a field named `pascalCase` with a JSON key `PascalCase`.
  ///
  /// Example: `userName` → `UserName`
  pascal,

  /// Encodes a field named `camelCase` with a JSON key `camelCase`.
  ///
  /// Example: `UserName` → `userName`
  camel,

  /// Encodes a field named `screamingSnakeCase` with a JSON key `SCREAMING_SNAKE_CASE`.
  ///
  /// Example: `userName` → `USER_NAME`
  screamingSnake;

  /// Converts a string to the appropriate case based on this enum value.
  ///
  /// Example:
  /// ```dart
  /// FieldRename.snake.convert('userName'); // Returns 'user_name'
  /// FieldRename.kebab.convert('userName'); // Returns 'user-name'
  /// ```
  String convert(String input) {
    final normalized = _normalizeToWords(input);

    switch (this) {
      case FieldRename.none:
        return input;
      case FieldRename.kebab:
        return _toKebabCase(normalized);
      case FieldRename.snake:
        return _toSnakeCase(normalized);
      case FieldRename.pascal:
        return _toPascalCase(normalized);
      case FieldRename.camel:
        return _toCamelCase(normalized);
      case FieldRename.screamingSnake:
        return _toScreamingSnakeCase(normalized);
    }
  }

  /// Parses a string to [FieldRename].
  ///
  /// Supported values (case-insensitive):
  /// - none
  /// - kebab, kebab-case
  /// - snake, snake_case
  /// - pascal, pascalcase
  /// - camel, camelcase
  /// - screaming_snake, screamingsnake, screaming-snake
  ///
  /// Returns [FieldRename.none] for unknown values.
  static FieldRename fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'kebab':
      case 'kebab-case':
        return FieldRename.kebab;
      case 'snake':
      case 'snake_case':
        return FieldRename.snake;
      case 'pascal':
      case 'pascalcase':
        return FieldRename.pascal;
      case 'camel':
      case 'camelcase':
        return FieldRename.camel;
      case 'screaming_snake':
      case 'screamingsnake':
      case 'screaming-snake':
        return FieldRename.screamingSnake;
      case 'none':
      default:
        return FieldRename.none;
    }
  }

  static String _normalizeToWords(String input) {
    if (input.isEmpty) return input;

    // 1) Convert obvious separators to spaces.
    // Examples:
    // - "first_name"  -> "first name"
    // - "first-name"  -> "first name"
    // - "first.name"  -> "first name"
    final withSpaces = input.replaceAll(RegExp(r'[\s_\-.]+'), ' ');

    // 2) Insert spaces on case transitions so "userName" becomes "user Name".
    // This keeps acronyms intact as much as possible.
    // - "UserName"   -> "User Name"
    // - "userName"   -> "user Name"
    // - "USERNAME"   -> "USERNAME" (no transitions)
    final withCaseBoundaries = withSpaces
        // fooBar -> foo Bar
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        )
        // XMLParser -> XML Parser
        .replaceAllMapped(
          RegExp(r'([A-Z]+)([A-Z][a-z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        );

    // 3) Split and rejoin to collapse repeated spaces.
    final parts = withCaseBoundaries
        .split(' ')
        .where((p) => p.trim().isNotEmpty)
        .toList(growable: false);

    return parts.join(' ');
  }

  static String _toKebabCase(String input) {
    final parts = input.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';

    final first = parts.first.toLowerCase();
    final rest = parts.skip(1).map((p) => p.isEmpty ? '' : p.toLowerCase());

    return [first, ...rest]
        .where((p) => p.isNotEmpty)
        .join('-')
        .replaceFirst(RegExp(r'^-'), '');
  }

  static String _toSnakeCase(String input) {
    final parts = input.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';

    final first = parts.first.toLowerCase();
    final rest = parts.skip(1).map((p) => p.isEmpty ? '' : p.toLowerCase());

    return [first, ...rest]
        .where((p) => p.isNotEmpty)
        .join('_')
        .replaceFirst(RegExp(r'^_'), '');
  }

  static String _toPascalCase(String input) {
    if (input.isEmpty) return input;
    final parts = input.split(' ').where((p) => p.isNotEmpty).toList();
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join();
  }

  static String _toCamelCase(String input) {
    if (input.isEmpty) return input;
    final pascal = _toPascalCase(input);
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  static String _toScreamingSnakeCase(String input) {
    final snake = _toSnakeCase(input);
    return snake.toUpperCase();
  }
}
