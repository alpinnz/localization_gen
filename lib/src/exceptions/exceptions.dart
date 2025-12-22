/// Base class for all localization generation exceptions
abstract class LocalizationException implements Exception {
  /// The error message
  final String message;

  /// Optional file path where the error occurred
  final String? filePath;

  /// Optional line number where the error occurred
  final int? lineNumber;

  /// Creates a new LocalizationException
  const LocalizationException(
    this.message, {
    this.filePath,
    this.lineNumber,
  });

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (filePath != null) {
      buffer.write('\n  File: $filePath');
    }
    if (lineNumber != null) {
      buffer.write('\n  Line: $lineNumber');
    }
    return buffer.toString();
  }
}

/// Exception thrown when a configuration error occurs
class ConfigException extends LocalizationException {
  /// Creates a new ConfigException
  const ConfigException(
    super.message, {
    super.filePath,
    super.lineNumber,
  });
}

/// Exception thrown when JSON parsing fails
class JsonParseException extends LocalizationException {
  /// The invalid JSON content (truncated if too long)
  final String? jsonContent;

  /// Creates a new JsonParseException
  const JsonParseException(
    super.message, {
    super.filePath,
    super.lineNumber,
    this.jsonContent,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (jsonContent != null) {
      final truncated = jsonContent!.length > 100
          ? '${jsonContent!.substring(0, 100)}...'
          : jsonContent;
      buffer.write('\n  Content: $truncated');
    }
    return buffer.toString();
  }
}

/// Exception thrown when locale validation fails.
///
/// This exception is raised during strict validation when locales don't
/// have consistent translation keys. It provides detailed information about
/// missing or extra keys to help developers fix the inconsistencies.
///
/// Example:
/// ```dart
/// throw LocaleValidationException(
///   'Missing translations in Spanish locale',
///   locale: 'es',
///   missingKeys: ['auth.login', 'auth.logout'],
/// );
/// ```
class LocaleValidationException extends LocalizationException {
  /// The locale that failed validation.
  final String locale;

  /// Missing keys in this locale compared to the base locale.
  ///
  /// When present, indicates which translations are missing.
  final List<String>? missingKeys;

  /// Extra keys not present in the base locale.
  ///
  /// When present, indicates translations that shouldn't be there.
  final List<String>? extraKeys;

  /// Creates a new LocaleValidationException.
  ///
  /// The [message] parameter describes the validation error.
  /// The [locale] parameter specifies which locale failed validation.
  /// The [missingKeys] parameter lists missing translations.
  /// The [extraKeys] parameter lists unexpected translations.
  /// The [filePath] parameter optionally specifies the file location.
  const LocaleValidationException(
    super.message, {
    required this.locale,
    this.missingKeys,
    this.extraKeys,
    super.filePath,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\n  Locale: $locale');

    if (missingKeys != null && missingKeys!.isNotEmpty) {
      buffer.write('\n  Missing keys (${missingKeys!.length}):');
      for (final key in missingKeys!.take(5)) {
        buffer.write('\n    - $key');
      }
      if (missingKeys!.length > 5) {
        buffer.write('\n    ... and ${missingKeys!.length - 5} more');
      }
    }

    if (extraKeys != null && extraKeys!.isNotEmpty) {
      buffer.write('\n  Extra keys (${extraKeys!.length}):');
      for (final key in extraKeys!.take(5)) {
        buffer.write('\n    - $key');
      }
      if (extraKeys!.length > 5) {
        buffer.write('\n    ... and ${extraKeys!.length - 5} more');
      }
    }

    return buffer.toString();
  }
}

/// Exception thrown when parameter extraction or validation fails
class ParameterException extends LocalizationException {
  /// The key with the parameter issue
  final String key;

  /// Expected parameters
  final List<String>? expectedParameters;

  /// Actual parameters found
  final List<String>? actualParameters;

  /// Creates a new ParameterException
  const ParameterException(
    super.message, {
    required this.key,
    this.expectedParameters,
    this.actualParameters,
    super.filePath,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\n  Key: $key');

    if (expectedParameters != null) {
      buffer
          .write('\n  Expected parameters: ${expectedParameters!.join(', ')}');
    }

    if (actualParameters != null) {
      buffer.write('\n  Actual parameters: ${actualParameters!.join(', ')}');
    }

    return buffer.toString();
  }
}

/// Exception thrown when code generation fails
class CodeGenerationException extends LocalizationException {
  /// The class name being generated
  final String? className;

  /// Creates a new CodeGenerationException
  const CodeGenerationException(
    super.message, {
    this.className,
    super.filePath,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (className != null) {
      buffer.write('\n  Class: $className');
    }
    return buffer.toString();
  }
}

/// Exception thrown when file operations fail.
///
/// This exception is raised when file system operations like reading,
/// writing, or deleting files encounter errors.
///
/// Example:
/// ```dart
/// throw FileOperationException(
///   'Failed to read localization file',
///   operation: 'read',
///   filePath: 'assets/localizations/app_en.json',
/// );
/// ```
class FileOperationException extends LocalizationException {
  /// The file operation that failed.
  ///
  /// Common values: 'read', 'write', 'delete', 'scan'.
  final String operation;

  /// Creates a new FileOperationException.
  ///
  /// The [message] parameter describes the file operation error.
  /// The [operation] parameter specifies what operation failed.
  /// The [filePath] parameter optionally specifies the file location.
  const FileOperationException(
    super.message, {
    required this.operation,
    super.filePath,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    buffer.write('\n  Operation: $operation');
    return buffer.toString();
  }
}
