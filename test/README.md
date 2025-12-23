# Test Suite Documentation

Comprehensive test suite for localization_gen package, organized to mirror the lib/src structure for easy validation and maintenance.

## Directory Structure

```
test/
├── test_helper.dart                         # Shared utilities and fixtures
├── all_test.dart                            # Main test runner
├── README.md                                # This file
├── config/
│   └── config_reader_test.dart             # Tests for config/config_reader.dart
├── exceptions/
│   └── exceptions_test.dart                # Tests for exceptions/exceptions.dart
├── generator/
│   └── localization_generator_test.dart    # Tests for generator/localization_generator.dart
├── model/
│   └── localization_item_test.dart         # Tests for model/localization_item.dart
├── parser/
│   ├── json_parser_test.dart               # Tests for parser/json_parser.dart
│   └── validation_test.dart                # Tests for validation logic
├── watcher/
│   └── file_watcher_test.dart              # Tests for watcher/file_watcher.dart
└── writer/
    └── dart_writer_test.dart               # Tests for writer/dart_writer.dart
```

The test structure directly mirrors lib/src for easy correlation and maintenance.

## Running Tests

### All Tests
```bash
dart test
```

### By Directory
```bash
dart test test/config/
dart test test/exceptions/
dart test test/generator/
dart test test/model/
dart test test/parser/
dart test test/watcher/
dart test test/writer/
```

### Specific File
```bash
dart test test/parser/json_parser_test.dart
dart test test/writer/dart_writer_test.dart
dart test test/config/config_reader_test.dart
```

### With Coverage
```bash
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Watch Mode
```bash
dart test --watch
```

## Test Coverage

| Component  | Test File                        | Tests | Focus Area                              |
|------------|----------------------------------|-------|-----------------------------------------|
| Config     | config_reader_test.dart          | 5     | Configuration reading from pubspec.yaml |
| Exceptions | exceptions_test.dart             | 11    | All custom exception types              |
| Generator  | localization_generator_test.dart | 4     | End-to-end code generation              |
| Model      | localization_item_test.dart      | 7     | Data models and structures              |
| Parser     | json_parser_test.dart            | 13    | JSON file parsing                       |
| Parser     | validation_test.dart             | 8     | Strict validation mode                  |
| Watcher    | file_watcher_test.dart           | 3     | File change detection                   |
| Writer     | dart_writer_test.dart            | 13    | Dart code generation                    |

**Total**: 64+ comprehensive tests covering all package features

## Test Helper Utilities

All tests use `test_helper.dart` for common functionality:

### Directory Management
```dart
// Create temporary test directory
final dir = TestHelper.createTempDir('test_prefix_');

// Cleanup after test
TestHelper.cleanupDir(dir);
```

### File Creation
```dart
// Create test JSON file
TestHelper.createJsonFile(dir, 'app_en.json', jsonContent);
```

### Pre-made Templates
```dart
// Basic English JSON
TestHelper.basicEnglishJson();

// Basic Indonesian JSON
TestHelper.basicIndonesianJson();

// JSON with parameters
TestHelper.jsonWithParameters();

// JSON with pluralization
TestHelper.jsonWithPluralization();

// Nested JSON structure
TestHelper.nestedJson();

// Create modular files
TestHelper.createModularFiles(dir, 'app');
```

## Source-to-Test Mapping

Each source file has a corresponding test file with clear 1:1 mapping:

```
lib/src/config/config_reader.dart
  → test/config/config_reader_test.dart

lib/src/exceptions/exceptions.dart
  → test/exceptions/exceptions_test.dart

lib/src/generator/localization_generator.dart
  → test/generator/localization_generator_test.dart

lib/src/model/localization_item.dart
  → test/model/localization_item_test.dart

lib/src/parser/json_parser.dart
  → test/parser/json_parser_test.dart
  → test/parser/validation_test.dart

lib/src/watcher/file_watcher.dart
  → test/watcher/file_watcher_test.dart

lib/src/writer/dart_writer.dart
  → test/writer/dart_writer_test.dart
```

## Writing Tests

### Test Template

Use this template when creating new tests:

```dart
import 'dart:io';
import 'package:test/test.dart';
import 'package:localization_gen/src/component/file.dart';
import '../test_helper.dart';

void main() {
  group('ComponentName', () {
    late Directory tempDir;

    setUp(() {
      tempDir = TestHelper.createTempDir('component_test_');
    });

    tearDown(() {
      TestHelper.cleanupDir(tempDir);
    });

    group('methodName()', () {
      test('should do something specific', () {
        // Arrange
        final input = prepareInput();
        
        // Act
        final result = componentMethod(input);
        
        // Assert
        expect(result, expectedValue);
      });
    });
  });
}
```

### Best Practices

1. **AAA Pattern**: Structure tests as Arrange, Act, Assert
2. **Clear Names**: Use descriptive test names that explain intent
3. **Independent**: Tests should not depend on each other
4. **Fast**: Keep individual tests under 1 second
5. **Clean**: Use setUp/tearDown for proper cleanup
6. **Helper**: Leverage TestHelper utilities to avoid duplication
7. **Focused**: Test one thing per test
8. **Readable**: Write tests that serve as documentation

## Test Organization

### Group Tests Logically

```dart
group('ComponentName', () {
  group('Feature A', () {
    test('behavior 1', () {});
    test('behavior 2', () {});
  });
  
  group('Feature B', () {
    test('behavior 3', () {});
  });
  
  group('Error Handling', () {
    test('throws on invalid input', () {});
  });
});
```

### Use Descriptive Names

Good:
- `'parses simple flat JSON'`
- `'generates method with multiple parameters'`
- `'throws LocaleValidationException on missing keys'`

Avoid:
- `'test1'`
- `'it works'`
- `'check parsing'`

## Adding New Tests

When adding a new source file to lib/src:

1. **Create test directory** if it doesn't exist
   ```bash
   mkdir -p test/new_component
   ```

2. **Create test file** matching source name
   ```bash
   touch test/new_component/new_file_test.dart
   ```

3. **Follow the template** shown above

4. **Use TestHelper** for common operations

5. **Add import** to `all_test.dart`
   ```dart
   import 'new_component/new_file_test.dart' as new_file_test;
   
   void main() {
     // ...existing imports...
     new_file_test.main();
   }
   ```

## Maintenance Guidelines

### When Modifying Source Code

1. **Run related tests** first
   ```bash
   dart test test/component/
   ```

2. **Update tests** if API changes

3. **Add new tests** for new functionality

4. **Verify all pass** before committing
   ```bash
   dart test
   ```

### When Refactoring

1. **Ensure tests pass** before starting
2. **Keep tests unchanged** if behavior doesn't change
3. **Update test names** if behavior changes
4. **Run tests frequently** during refactoring

### Maintaining Coverage

Check coverage regularly:
```bash
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html
```

Target coverage levels:
- Critical components: 90%+
- Standard components: 80%+
- Overall project: 80%+

## Continuous Integration

Tests run automatically on:
- Every commit
- Pull requests
- Before releases

Ensure all tests pass before pushing:
```bash
dart analyze
dart test
```

## Troubleshooting

### Tests Failing

1. **Check error message** carefully
2. **Run single test** to isolate issue
   ```bash
   dart test test/file.dart --name "specific test"
   ```
3. **Clean and retry**
   ```bash
   dart pub get
   dart pub cache repair
   dart test
   ```

### Slow Tests

1. **Profile tests** to find slow ones
2. **Reduce test scope** if too broad
3. **Mock expensive operations**
4. **Use setUp/tearDown** efficiently

### Flaky Tests

1. **Check for race conditions**
2. **Ensure proper cleanup** in tearDown
3. **Avoid timing dependencies**
4. **Use deterministic test data**

## Resources

- [Dart Testing Guide](https://dart.dev/guides/testing)
- [Test Package Documentation](https://pub.dev/packages/test)
- [Code Coverage](https://pub.dev/packages/coverage)

## Summary

The test suite is organized to:
- Mirror the source structure for easy navigation
- Provide comprehensive coverage of all features
- Use shared utilities to reduce duplication
- Follow best practices for maintainability
- Support continuous integration workflows

Each test file directly corresponds to a source file, making it easy to find and maintain tests as the codebase evolves.

