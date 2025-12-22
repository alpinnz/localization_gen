/// Test configuration and shared utilities.
///
/// This file provides common test utilities, fixtures, and helpers
/// used across all test files.

import 'dart:io';

import 'package:path/path.dart' as p;

/// Test helper utilities
class TestHelper {
  /// Create a temporary directory for testing
  static Directory createTempDir([String prefix = 'test_']) =>
      Directory.systemTemp.createTempSync(prefix);

  /// Create a test JSON file with given content
  static File createJsonFile(Directory dir, String filename, String content) {
    final file = File(p.join(dir.path, filename));
    file.writeAsStringSync(content);
    return file;
  }

  /// Clean up test directory
  static void cleanupDir(Directory dir) {
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  /// Create basic English locale JSON
  static String basicEnglishJson() => '''
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome": "Welcome, {name}!",
  "common": {
    "ok": "OK",
    "cancel": "Cancel"
  }
}
''';

  /// Create basic Indonesian locale JSON
  static String basicIndonesianJson() => '''
{
  "@@locale": "id",
  "hello": "Halo",
  "welcome": "Selamat datang, {name}!",
  "common": {
    "ok": "OK",
    "cancel": "Batal"
  }
}
''';

  /// Create JSON with parameters
  static String jsonWithParameters() => '''
{
  "@@locale": "en",
  "greeting": "Hello, {name}!",
  "itemCount": "You have {count} items",
  "multiParam": "{user} sent {count} messages"
}
''';

  /// Create JSON with pluralization
  static String jsonWithPluralization() => '''
{
  "@@locale": "en",
  "items": {
    "@plural": {
      "zero": "No items",
      "one": "One item",
      "other": "{count} items"
    }
  }
}
''';

  /// Create nested JSON (3 levels)
  static String nestedJson() => '''
{
  "@@locale": "en",
  "app": {
    "auth": {
      "login": {
        "title": "Login",
        "email": "Email",
        "password": "Password"
      }
    }
  }
}
''';

  /// Create modular JSON files for testing
  static void createModularFiles(Directory dir, String prefix) {
    createJsonFile(dir, '${prefix}_auth_en.json', '''
{
  "@@locale": "en",
  "@@module": "auth",
  "login": "Login",
  "logout": "Logout"
}
''');

    createJsonFile(dir, '${prefix}_auth_id.json', '''
{
  "@@locale": "id",
  "@@module": "auth",
  "login": "Masuk",
  "logout": "Keluar"
}
''');

    createJsonFile(dir, '${prefix}_home_en.json', '''
{
  "@@locale": "en",
  "@@module": "home",
  "welcome": "Welcome",
  "title": "Home"
}
''');

    createJsonFile(dir, '${prefix}_home_id.json', '''
{
  "@@locale": "id",
  "@@module": "home",
  "welcome": "Selamat Datang",
  "title": "Beranda"
}
''');
  }

  /// Create invalid JSON for error testing
  static String invalidJson() => '{ "invalid": json }';

  /// Create JSON with missing keys (for validation testing)
  static String incompleteJson() => '''
{
  "@@locale": "id",
  "hello": "Halo"
}
''';
}

/// Test fixtures paths
class TestFixtures {
  static const deepNested10En = 'test/fixtures/deep_nested_10_en.json';
  static const deepNested10Id = 'test/fixtures/deep_nested_10_id.json';
}

/// Expected values for validation
class TestExpectations {
  static const englishHello = 'Hello';
  static const indonesianHello = 'Halo';
  static const okButton = 'OK';
  static const cancelButton = 'Cancel';
}
