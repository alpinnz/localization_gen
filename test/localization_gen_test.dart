import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:localization_gen/src/model/localization_item.dart';

void main() {
  group('JsonLocalizationParser', () {
    test('parses simple JSON with nested structure', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "goodbye": "Goodbye"
  },
  "auth": {
    "login": "Login"
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.locale, 'en');
      expect(localeData.items.length, 3);
      expect(localeData.items['common.hello']?.value, 'Hello');
      expect(localeData.items['common.goodbye']?.value, 'Goodbye');
      expect(localeData.items['auth.login']?.value, 'Login');

      tempDir.deleteSync(recursive: true);
    });

    test('extracts parameters from strings', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!",
  "itemCount": "You have {count} items"
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.items['greeting']?.parameters, ['name']);
      expect(localeData.items['itemCount']?.parameters, ['count']);

      tempDir.deleteSync(recursive: true);
    });

    test('handles deeply nested structure', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "settings": {
    "profile": {
      "personal": {
        "name": "Name"
      }
    }
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.items['settings.profile.personal.name']?.value, 'Name');

      tempDir.deleteSync(recursive: true);
    });
  });

  group('DartWriter', () {
    test('generates valid Dart code structure', () {
      final localeData = LocaleData(
        locale: 'en',
        items: {
          'common.hello': LocalizationItem(
            key: 'common.hello',
            value: 'Hello',
          ),
          'auth.login': LocalizationItem(
            key: 'auth.login',
            value: 'Login',
          ),
        },
      );

      final writer = DartWriter(
        className: 'TestLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('class TestLocalizations'));
      expect(code, contains('_Common get common'));
      expect(code, contains('_Auth get auth'));
      expect(code, contains('class _Common'));
      expect(code, contains('class _Auth'));
      expect(code, contains('String get hello'));
      expect(code, contains('String get login'));
    });
  });
}


