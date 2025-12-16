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

    test('handles 10 levels of deeply nested structure', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "level1": {
    "level2": {
      "level3": {
        "level4": {
          "level5": {
            "level6": {
              "level7": {
                "level8": {
                  "level9": {
                    "level10": {
                      "deepValue": "This is deeply nested value",
                      "greeting": "Hello from level 10!",
                      "message": "You reached the deepest level with {count} steps"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "app": {
    "settings": {
      "profile": {
        "personal": {
          "info": {
            "contact": {
              "phone": {
                "mobile": {
                  "primary": {
                    "number": "Primary Phone Number"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      // Test 10 levels deep
      expect(
          localeData
              .items[
                  'level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.deepValue']
              ?.value,
          'This is deeply nested value');
      expect(
          localeData
              .items[
                  'level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.greeting']
              ?.value,
          'Hello from level 10!');

      // Test parameters in deeply nested structure
      final messageItem = localeData.items[
          'level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.message'];
      expect(messageItem?.value,
          'You reached the deepest level with {count} steps');
      expect(messageItem?.parameters, ['count']);

      // Test another deep path
      expect(
          localeData
              .items[
                  'app.settings.profile.personal.info.contact.phone.mobile.primary.number']
              ?.value,
          'Primary Phone Number');

      tempDir.deleteSync(recursive: true);
    });

    test('parses modular JSON with module metadata', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_auth_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "@@module": "auth",
  "login": {
    "title": "Login",
    "email": "Email",
    "password": "Password"
  },
  "register": {
    "title": "Register"
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.locale, 'en');
      // Module metadata is stored but not directly accessible
      expect(localeData.items['login.title']?.value, 'Login');
      expect(localeData.items['login.email']?.value, 'Email');
      expect(localeData.items['register.title']?.value, 'Register');

      tempDir.deleteSync(recursive: true);
    });

    test('handles multiple locales with same structure', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');

      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "save": "Save"
  }
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "common": {
    "hello": "Halo",
    "save": "Simpan"
  }
}
''');

      final enData = JsonLocalizationParser.parse(enFile);
      final idData = JsonLocalizationParser.parse(idFile);

      expect(enData.locale, 'en');
      expect(idData.locale, 'id');
      expect(enData.items['common.hello']?.value, 'Hello');
      expect(idData.items['common.hello']?.value, 'Halo');
      expect(enData.items['common.save']?.value, 'Save');
      expect(idData.items['common.save']?.value, 'Simpan');

      tempDir.deleteSync(recursive: true);
    });

    test('handles flat structure for modular files', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_common_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "@@module": "common",
  "hello": "Hello",
  "save": "Save",
  "cancel": "Cancel"
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.locale, 'en');
      // Module metadata is stored but not directly accessible
      expect(localeData.items['hello']?.value, 'Hello');
      expect(localeData.items['save']?.value, 'Save');
      expect(localeData.items['cancel']?.value, 'Cancel');

      tempDir.deleteSync(recursive: true);
    });

    test('handles empty translations', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en"
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.locale, 'en');
      expect(localeData.items.isEmpty, true);

      tempDir.deleteSync(recursive: true);
    });

    test('handles special characters in values', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "messages": {
    "quote": "He said \\"Hello\\"",
    "newline": "Line 1\\nLine 2",
    "special": "Price: \$100"
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);

      expect(localeData.items['messages.quote']?.value, 'He said "Hello"');
      expect(localeData.items['messages.newline']?.value, 'Line 1\nLine 2');
      expect(localeData.items['messages.special']?.value, 'Price: \$100');

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

    test('generates code with multiple locales', () {
      final enData = LocaleData(
        locale: 'en',
        items: {
          'common.hello': LocalizationItem(
            key: 'common.hello',
            value: 'Hello',
          ),
        },
      );

      final idData = LocaleData(
        locale: 'id',
        items: {
          'common.hello': LocalizationItem(
            key: 'common.hello',
            value: 'Halo',
          ),
        },
      );

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([enData, idData]);

      expect(code, contains('class AppLocalizations'));
      expect(code, contains("case 'en': return 'Hello'"));
      expect(code, contains("case 'id': return 'Halo'"));
      expect(code, contains('supportedLocales'));
      expect(code, contains("Locale('en')"));
      expect(code, contains("Locale('id')"));
    });

    test('generates code with parameters', () {
      final localeData = LocaleData(
        locale: 'en',
        items: {
          'greeting': LocalizationItem(
            key: 'greeting',
            value: 'Hello, {name}!',
            parameters: ['name'],
          ),
        },
      );

      final writer = DartWriter(
        className: 'TestLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('String greeting({required String name})'));
      expect(code, contains('Hello, \$name!'));
    });

    test('generates code for modular structure', () {
      final authData = LocaleData(
        locale: 'en',
        items: {
          'login.title': LocalizationItem(
            key: 'login.title',
            value: 'Login',
          ),
        },
      );

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([authData]);

      expect(code, contains('class AppLocalizations'));
      expect(code, contains('_Login get login'));
      expect(code, contains('class _Login'));
    });

    test('generates delegate extension', () {
      final localeData = LocaleData(
        locale: 'en',
        items: {
          'test': LocalizationItem(
            key: 'test',
            value: 'Test',
          ),
        },
      );

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('extension AppLocalizationsExtension'));
      expect(code, contains('static const delegate'));
      expect(code, contains('isSupported'));
      expect(code, contains('load'));
      expect(code, contains('shouldReload'));
    });

    test('handles nullable configuration', () {
      final localeData = LocaleData(
        locale: 'en',
        items: {
          'test': LocalizationItem(
            key: 'test',
            value: 'Test',
          ),
        },
      );

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: true,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('AppLocalizations?'));
    });
  });

  group('Integration Tests', () {
    test('end-to-end: parse and generate for nested JSON', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "auth": {
    "login": {
      "title": "Login",
      "button": "Sign In"
    }
  }
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);
      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('class AppLocalizations'));
      expect(code, contains('_Auth get auth'));
      expect(code, contains('_AuthLogin get login'));
      expect(code, contains('String get title'));
      expect(code, contains('String get button'));
      expect(code, contains("return 'Login'"));
      expect(code, contains("return 'Sign In'"));

      tempDir.deleteSync(recursive: true);
    });

    test('end-to-end: parse and generate for modular JSON', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');
      final jsonFile = File('${tempDir.path}/app_common_en.json');

      jsonFile.writeAsStringSync('''
{
  "@@locale": "en",
  "@@module": "common",
  "hello": "Hello",
  "save": "Save",
  "cancel": "Cancel"
}
''');

      final localeData = JsonLocalizationParser.parse(jsonFile);
      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([localeData]);

      expect(code, contains('class AppLocalizations'));
      expect(code, contains('String get hello'));
      expect(code, contains('String get save'));
      expect(code, contains('String get cancel'));
      expect(code, contains("return 'Hello'"));
      expect(code, contains("return 'Save'"));

      tempDir.deleteSync(recursive: true);
    });

    test('end-to-end: multiple locales with parameters', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');

      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "greeting": "Welcome, {name}!"
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "greeting": "Selamat datang, {name}!"
}
''');

      final enData = JsonLocalizationParser.parse(enFile);
      final idData = JsonLocalizationParser.parse(idFile);

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([enData, idData]);

      expect(code, contains('String greeting({required String name})'));
      expect(code, contains("case 'en': return 'Welcome, \$name!'"));
      expect(code, contains("case 'id': return 'Selamat datang, \$name!'"));

      tempDir.deleteSync(recursive: true);
    });

    test('end-to-end: 10 levels deep nested structure code generation', () {
      final tempDir = Directory.systemTemp.createTempSync('localization_test');

      final enFile = File('${tempDir.path}/app_en.json');
      enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "level1": {
    "level2": {
      "level3": {
        "level4": {
          "level5": {
            "level6": {
              "level7": {
                "level8": {
                  "level9": {
                    "level10": {
                      "deepValue": "This is deeply nested value",
                      "greeting": "Hello from level 10!",
                      "message": "You reached level {count}"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
''');

      final idFile = File('${tempDir.path}/app_id.json');
      idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "level1": {
    "level2": {
      "level3": {
        "level4": {
          "level5": {
            "level6": {
              "level7": {
                "level8": {
                  "level9": {
                    "level10": {
                      "deepValue": "Ini adalah nilai yang sangat dalam",
                      "greeting": "Halo dari level 10!",
                      "message": "Anda mencapai level {count}"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
''');

      final enData = JsonLocalizationParser.parse(enFile);
      final idData = JsonLocalizationParser.parse(idFile);

      final writer = DartWriter(
        className: 'AppLocalizations',
        useContext: true,
        nullable: false,
      );

      final code = writer.generate([enData, idData]);

      // Verify main class has level1 getter
      expect(code, contains('class AppLocalizations'));
      expect(code, contains('_Level1 get level1 => _Level1(locale);'));

      // Verify nested classes are generated correctly with UpperCamelCase (no underscores between parts)
      expect(code, contains('class _Level1'));
      expect(code, contains('class _Level1Level2'));
      expect(code, contains('class _Level1Level2Level3'));
      expect(code, contains('class _Level1Level2Level3Level4'));
      expect(code, contains('class _Level1Level2Level3Level4Level5'));
      expect(code, contains('class _Level1Level2Level3Level4Level5Level6'));
      expect(
          code, contains('class _Level1Level2Level3Level4Level5Level6Level7'));
      expect(code,
          contains('class _Level1Level2Level3Level4Level5Level6Level7Level8'));
      expect(
          code,
          contains(
              'class _Level1Level2Level3Level4Level5Level6Level7Level8Level9'));
      expect(
          code,
          contains(
              'class _Level1Level2Level3Level4Level5Level6Level7Level8Level9Level10'));

      // Verify getter chains use UpperCamelCase
      expect(
          code, contains('_Level1Level2 get level2 => _Level1Level2(locale);'));
      expect(
          code,
          contains(
              '_Level1Level2Level3 get level3 => _Level1Level2Level3(locale);'));

      // Verify final values in deepest class
      expect(code, contains('String get deepValue'));
      expect(code, contains('String get greeting'));
      expect(code, contains('String message({required String count})'));

      // Verify locale switching works
      expect(code, contains("case 'en': return 'This is deeply nested value'"));
      expect(code,
          contains("case 'id': return 'Ini adalah nilai yang sangat dalam'"));
      expect(code, contains("case 'en': return 'Hello from level 10!'"));
      expect(code, contains("case 'id': return 'Halo dari level 10!'"));

      tempDir.deleteSync(recursive: true);
    });
  });
}
