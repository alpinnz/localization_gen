/// Tests for custom exceptions.
///
/// Covers all exception types and their properties.

import 'package:test/test.dart';
import 'package:localization_gen/src/exceptions/exceptions.dart';

void main() {
  group('LocaleValidationException', () {
    test('creates with locale and message', () {
      const exception = LocaleValidationException(
        'Validation failed',
        locale: 'id',
      );

      expect(exception.message, equals('Validation failed'));
      expect(exception.locale, equals('id'));
    });

    test('includes missing keys', () {
      const exception = LocaleValidationException(
        'Missing keys',
        locale: 'id',
        missingKeys: ['key1', 'key2'],
      );

      expect(exception.missingKeys, isNotNull);
      expect(exception.missingKeys, hasLength(2));
      expect(exception.missingKeys, containsAll(['key1', 'key2']));
    });

    test('includes extra keys', () {
      const exception = LocaleValidationException(
        'Extra keys found',
        locale: 'id',
        extraKeys: ['extra1', 'extra2'],
      );

      expect(exception.extraKeys, isNotNull);
      expect(exception.extraKeys, hasLength(2));
    });

    test('toString includes locale and message', () {
      const exception = LocaleValidationException(
        'Validation failed',
        locale: 'id',
      );

      final str = exception.toString();
      expect(str, contains('id'));
      expect(str, contains('Validation failed'));
    });
  });

  group('ParameterException', () {
    test('creates with message and key', () {
      const exception = ParameterException(
        'Parameter mismatch',
        key: 'greeting',
      );

      expect(exception.message, equals('Parameter mismatch'));
      expect(exception.key, equals('greeting'));
    });

    test('toString includes key and message', () {
      const exception = ParameterException(
        'Parameter mismatch',
        key: 'greeting',
      );

      final str = exception.toString();
      expect(str, contains('greeting'));
      expect(str, contains('Parameter mismatch'));
    });
  });

  group('JsonParseException', () {
    test('creates with message', () {
      const exception = JsonParseException('Invalid JSON');

      expect(exception.message, equals('Invalid JSON'));
    });

    test('includes file path', () {
      const exception = JsonParseException(
        'Invalid JSON',
        filePath: '/path/to/file.json',
      );

      expect(exception.filePath, equals('/path/to/file.json'));
    });

    test('includes line number', () {
      const exception = JsonParseException(
        'Invalid JSON',
        filePath: '/path/to/file.json',
        lineNumber: 42,
      );

      expect(exception.lineNumber, equals(42));
    });
  });

  group('FileOperationException', () {
    test('creates with message and operation', () {
      const exception = FileOperationException(
        'File not found',
        operation: 'read',
      );

      expect(exception.message, equals('File not found'));
      expect(exception.operation, equals('read'));
    });

    test('includes file path', () {
      const exception = FileOperationException(
        'Permission denied',
        operation: 'write',
        filePath: '/path/to/file',
      );

      expect(exception.filePath, equals('/path/to/file'));
    });
  });

  group('CodeGenerationException', () {
    test('creates with message', () {
      const exception = CodeGenerationException('Generation failed');

      expect(exception.message, equals('Generation failed'));
    });

    test('has toString representation', () {
      const exception = CodeGenerationException('Generation failed');

      expect(exception.toString(), contains('Generation failed'));
    });
  });
}
