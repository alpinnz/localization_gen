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
    switch (this) {
      case FieldRename.none:
        return input;
      case FieldRename.kebab:
        return _toKebabCase(input);
      case FieldRename.snake:
        return _toSnakeCase(input);
      case FieldRename.pascal:
        return _toPascalCase(input);
      case FieldRename.camel:
        return _toCamelCase(input);
      case FieldRename.screamingSnake:
        return _toScreamingSnakeCase(input);
    }
  }

  /// Parses a string to FieldRename enum.
  ///
  /// Returns [FieldRename.none] if the string doesn't match any enum value.
  static FieldRename fromString(String value) {
    switch (value.toLowerCase()) {
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
      default:
        return FieldRename.none;
    }
  }

  static String _toKebabCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '-${match.group(1)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^-'), '');
  }

  static String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }

  static String _toPascalCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static String _toCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }

  static String _toScreamingSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!}',
        )
        .replaceFirst(RegExp(r'^_'), '')
        .toUpperCase();
  }
}
