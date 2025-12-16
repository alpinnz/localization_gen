import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/exceptions/exceptions.dart';

void main() {
  group('Error Handling', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('error_test');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('throws FileOperationException for non-existent file', () {
      final nonExistentFile = File('${tempDir.path}/non_existent.json');

      expect(
        () => JsonLocalizationParser.parse(nonExistentFile),
        throwsA(isA<FileOperationException>()),
      );
    });

    test('throws JsonParseException for empty file', () {
      final emptyFile = File('${tempDir.path}/empty.json');
      emptyFile.writeAsStringSync('   ');

      expect(
        () => JsonLocalizationParser.parse(emptyFile),
        throwsA(isA<JsonParseException>()),
      );
    });

    test('throws JsonParseException for invalid JSON', () {
      final invalidFile = File('${tempDir.path}/invalid.json');
      invalidFile.writeAsStringSync('{ invalid json }');

      expect(
        () => JsonLocalizationParser.parse(invalidFile),
        throwsA(isA<JsonParseException>()),
      );
    });

    test('throws JsonParseException for non-object root', () {
      final arrayFile = File('${tempDir.path}/array.json');
      arrayFile.writeAsStringSync('["not", "an", "object"]');

      expect(
        () => JsonLocalizationParser.parse(arrayFile),
        throwsA(isA<JsonParseException>()),
      );
    });

    test('throws FileOperationException for non-existent directory', () {
      expect(
        () => JsonLocalizationParser.parseDirectory('/non/existent/path'),
        throwsA(isA<FileOperationException>()),
      );
    });

    test('throws FileOperationException when no JSON files found', () {
      final emptyDir = Directory('${tempDir.path}/empty');
      emptyDir.createSync();

      expect(
        () => JsonLocalizationParser.parseDirectory(emptyDir.path),
        throwsA(isA<FileOperationException>()),
      );
    });

    test('handles malformed JSON with helpful error message', () {
      final malformedFile = File('${tempDir.path}/malformed.json');
      malformedFile.writeAsStringSync('{"key": "value",}'); // Trailing comma

      try {
        JsonLocalizationParser.parse(malformedFile);
        fail('Should have thrown JsonParseException');
      } on JsonParseException catch (e) {
        expect(e.message, contains('Invalid JSON format'));
        expect(e.filePath, equals(malformedFile.path));
      }
    });

    test('warns about unsupported value types', () {
      final jsonFile = File('${tempDir.path}/unsupported.json');
      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "number": 123,
  "bool": true,
  "valid": "Valid String"
}
''');

      // Should parse successfully but warn about unsupported types
      final result = JsonLocalizationParser.parse(jsonFile);
      expect(result.items['valid']?.value, 'Valid String');
      expect(result.items['number'], isNull);
      expect(result.items['bool'], isNull);
    });
  });

  group('Locale Validation', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('validation_test');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('throws LocaleValidationException for missing keys', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "hello": "Hello",
  "goodbye": "Goodbye"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "hello": "Halo"
}
''');

      expect(
        () => JsonLocalizationParser.parseDirectory(
          tempDir.path,
          strictValidation: true,
        ),
        throwsA(isA<LocaleValidationException>()),
      );
    });

    test('throws LocaleValidationException for extra keys', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "hello": "Hello"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "hello": "Halo",
  "extra": "Extra Key"
}
''');

      expect(
        () => JsonLocalizationParser.parseDirectory(
          tempDir.path,
          strictValidation: true,
        ),
        throwsA(isA<LocaleValidationException>()),
      );
    });

    test('throws ParameterException for parameter mismatch', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "greeting": "Halo, {user}!"
}
''');

      expect(
        () => JsonLocalizationParser.parseDirectory(
          tempDir.path,
          strictValidation: true,
        ),
        throwsA(isA<ParameterException>()),
      );
    });

    test('allows consistent locales with strict validation', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!",
  "count": "You have {count} items"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "greeting": "Halo, {name}!",
  "count": "Anda memiliki {count} item"
}
''');

      final locales = JsonLocalizationParser.parseDirectory(
        tempDir.path,
        strictValidation: true,
      );

      expect(locales.length, 2);
      expect(locales[0].items.length, 2);
      expect(locales[1].items.length, 2);
    });

    test('does not validate without strict mode', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "hello": "Hello",
  "goodbye": "Goodbye"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "hello": "Halo"
}
''');

      // Should not throw without strict validation
      final locales = JsonLocalizationParser.parseDirectory(
        tempDir.path,
        strictValidation: false,
      );

      expect(locales.length, 2);
      expect(locales[0].items.length, 2);
      expect(locales[1].items.length, 1);
    });

    test('validates parameters are order-independent', () {
      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "message": "User {name} has {count} items"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "message": "{count} item dimiliki oleh {name}"
}
''');

      // Should pass - same parameters, different order
      final locales = JsonLocalizationParser.parseDirectory(
        tempDir.path,
        strictValidation: true,
      );

      expect(locales.length, 2);
    });
  });

  group('Exception Information', () {
    test('LocaleValidationException includes detailed info', () {
      final exception = LocaleValidationException(
        'Test error',
        locale: 'id',
        missingKeys: ['key1', 'key2', 'key3'],
        extraKeys: ['extra1'],
        filePath: '/path/to/file.json',
      );

      final message = exception.toString();
      expect(message, contains('Test error'));
      expect(message, contains('Locale: id'));
      expect(message, contains('Missing keys'));
      expect(message, contains('key1'));
      expect(message, contains('Extra keys'));
      expect(message, contains('extra1'));
    });

    test('ParameterException includes parameter details', () {
      final exception = ParameterException(
        'Parameter mismatch',
        key: 'greeting',
        expectedParameters: ['name'],
        actualParameters: ['user'],
      );

      final message = exception.toString();
      expect(message, contains('Parameter mismatch'));
      expect(message, contains('Key: greeting'));
      expect(message, contains('Expected parameters: name'));
      expect(message, contains('Actual parameters: user'));
    });

    test('JsonParseException truncates long content', () {
      final longContent = 'x' * 200;
      final exception = JsonParseException(
        'Parse error',
        filePath: '/test.json',
        jsonContent: longContent,
      );

      final message = exception.toString();
      expect(message, contains('Parse error'));
      expect(message, contains('Content:'));
      expect(message.length, lessThan(longContent.length + 100));
      expect(message, contains('...'));
    });
  });
}
