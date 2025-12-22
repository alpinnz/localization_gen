# Contributing Guide

Thank you for contributing to Localization Gen!

Repository: https://github.com/alpinnz/localization_gen

## Quick Start

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/localization_gen.git
cd localization_gen

# 2. Install dependencies
dart pub get

# 3. Run tests
dart test

# 4. Make changes and verify
dart analyze
dart format .
dart test
```

## Development Standards

### Code Style

Follow Dart conventions:

```dart
// Good: Clear naming
final appLocalizations = AppLocalizations.of(context);
final localizationItems = parser.parseItems();

// Bad: Unclear naming
final l = AppLocalizations.of(context);
final items = parser.parseItems();
```

### Documentation

All public APIs must be documented:

```dart
/// Parses JSON localization files.
///
/// Returns [LocaleData] containing parsed translations.
/// Throws [JsonParseException] if JSON is invalid.
///
/// Example:
/// ```dart
/// final data = parseJson(file);
/// ```
LocaleData parseJson(File file) { }
```

### Testing

- Minimum 80% test coverage
- Use AAA pattern (Arrange, Act, Assert)
- Test public APIs, edge cases, and error scenarios

```dart
test('parses valid JSON successfully', () {
  // Arrange
  final file = createTestFile();
  
  // Act
  final result = parser.parse(file);
  
  // Assert
  expect(result.locale, equals('en'));
});
```

### Error Handling

Use specific exceptions with context:

```dart
throw JsonParseException(
  'Invalid JSON format',
  filePath: file.path,
  lineNumber: 15,
);
```

## Commit Guidelines

Follow Conventional Commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code refactoring
- `test`: Tests
- `chore`: Maintenance

Examples:

```bash
feat(parser): add RTL language support

Implemented RTL detection and updated generated code.

Closes #123

fix(generator): handle empty JSON files

Previously caused crashes, now displays error message.

Fixes #456
```

## Pull Request Process

Before submitting:

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Code is formatted
- [ ] No analyzer warnings
- [ ] Documentation updated
- [ ] CHANGELOG.md updated

## Quality Checks

```bash
# Run all checks
dart analyze
dart test
dart format .

# Check coverage
dart test --coverage
```

## Project Structure

```
lib/src/
├── command/        # CLI commands
├── config/         # Configuration
├── exceptions/     # Custom exceptions
├── generator/      # Core generator
├── model/          # Data models
├── parser/         # JSON parsing
├── watcher/        # File watching
└── writer/         # Code generation
```

## Best Practices

1. One class per file
2. Keep methods under 50 lines
3. Cache expensive operations
4. Validate all inputs
5. Use safe file operations

## Release Process

Maintainers handle releases:

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create git tag
4. Publish to pub.dev

## Getting Help

- Issues: https://github.com/alpinnz/localization_gen/issues
- Discussions: https://github.com/alpinnz/localization_gen/discussions

## Code of Conduct

- Use welcoming language
- Respect different viewpoints
- Accept constructive criticism
- Focus on community benefit
- Show empathy

## License

By contributing, you agree your contributions will be licensed under the MIT License.

