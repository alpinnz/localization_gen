# Localization Generator

Type-safe localization code generator for Flutter applications using nested JSON files.

[![Pub Version](https://img.shields.io/pub/v/localization_gen)](https://pub.dev/packages/localization_gen)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Overview

Generate type-safe, nested localization code from JSON files with compile-time checking, parameter interpolation, and strict validation support.

Repository: https://github.com/alpinnz/localization_gen

## Features

- **Type-Safe**: Compile-time checking of translation keys
- **Nested Structure**: Organize translations hierarchically (up to 10 levels)
- **Watch Mode**: Auto-regenerate on file changes
- **Parameter Support**: Named parameters with type checking
- **Strict Validation**: Ensure consistency across all locales
- **Field Rename**: Support multiple naming conventions (snake_case, kebab-case, etc.)
- **Modular Organization**: Feature-based file structure
- **Monorepo Support**: Multiple packages with independent localization

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.1.0

dependencies:
  flutter_localizations:
    sdk: flutter
```

Install dependencies:

```bash
dart pub get
# or
make install
```

## Quick Start

### 1. Configuration

Add configuration to `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  strict_validation: true
  field_rename: snake  # none, kebab, snake, pascal, camel, screamingSnake
```

### 2. Create JSON Files

Create `assets/localizations/app_en.json`:

```json
{
  "@@locale": "en",
  "app": {
    "title": "My App",
    "welcome": "Welcome, {name}!"
  },
  "auth": {
    "login": {
      "title": "Login",
      "email": "Email",
      "password": "Password"
    }
  }
}
```

Create `assets/localizations/app_id.json`:

```json
{
  "@@locale": "id",
  "app": {
    "title": "Aplikasi Saya",
    "welcome": "Selamat datang, {name}!"
  },
  "auth": {
    "login": {
      "title": "Masuk",
      "email": "Email",
      "password": "Kata Sandi"
    }
  }
}
```

### 3. Generate Code

```bash
dart run localization_gen
# or
make generate
```

## Development Commands

This project includes a Makefile for common development tasks. Run `make help` to see all available commands.


```bash
# Development
make install          # Install dependencies
make test             # Run all tests
make test-file        # Run specific test file (FILE=path/to/test.dart)
make test-examples    # Run tests for all examples
make analyze          # Run dart analyze
make format           # Format all code
make format-check     # Check code formatting
make lint             # Run linter
make check            # Run all checks (analyze + format + test)
make coverage         # Generate test coverage report
make watch            # Run tests in watch mode

# Localization
make generate         # Generate localization (for testing)
make generate-watch   # Generate localization in watch mode
make validate         # Validate localization files

# Examples
make example-basic    # Run basic example
make example-modular  # Run modular example
make examples-setup   # Setup all examples

# Cleanup
make clean            # Remove build artifacts
make clean-all        # Deep clean (including cache)

# Publishing
make publish-dry      # Dry run publication
make publish          # Publish to pub.dev

# Maintenance
make update           # Update dependencies
make info             # Show package information
make check-release    # Check if ready for release

# Shortcuts
make all              # Run install + check
make run-all          # Run complete test suite (all + examples)
```

### 4. Setup Flutter App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(),
    );
  }
}
```

### 5. Use Translations

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.app.title),
      ),
      body: Column(
        children: [
          Text(appLocalizations.app.welcome(name: 'John')),
          Text(appLocalizations.auth.login.title),
        ],
      ),
    );
  }
}
```

## Commands

### Generate

```bash
# Generate once
dart run localization_gen

# Watch mode (auto-regenerate on changes)
dart run localization_gen generate --watch

# Custom config file
dart run localization_gen generate --config=custom_pubspec.yaml
```

### Initialize

```bash
# Create directory structure and sample files
dart run localization_gen init

# With options
dart run localization_gen init --locales=en,es,id --strict
```

### Validate

```bash
# Validate JSON files
dart run localization_gen validate
```

### Clean

```bash
# Remove generated files
dart run localization_gen clean
# or
make clean
```

### Coverage

```bash
# Generate coverage report
dart run localization_gen coverage
# or
make coverage

# HTML format
dart run localization_gen coverage --format=html --output=coverage.html
```

## Configuration Options

```yaml
localization_gen:
  # Required: Input directory containing JSON files
  input_dir: assets/localizations
  
  # Optional: Output directory for generated code (default: lib/assets)
  output_dir: lib/assets
  
  # Optional: Generated class name (default: AppLocalizations)
  class_name: AppLocalizations
  
  # Optional: Generate static of(context) method (default: true)
  use_context: true
  
  # Optional: Make of(context) return nullable (default: false)
  nullable: false
  
  # Optional: Enable strict validation (default: false)
  strict_validation: true
  
  # Optional: Field naming convention (default: none)
  # Options: none, kebab, snake, pascal, camel, screamingSnake
  field_rename: snake
  
  # Optional: Modular file organization (default: false)
  modular: false
  
  # Optional: File pattern for modular mode
  file_pattern: app_{module}_{locale}.json
  
  # Optional: File prefix for modular mode
  file_prefix: app
```

## Field Rename Options

Control how JSON keys are converted to Dart identifiers:

- **none**: Keep original naming (default)
- **kebab**: user-name
- **snake**: user_name
- **pascal**: UserName
- **camel**: userName
- **screamingSnake**: USER_NAME

Example:

```yaml
localization_gen:
  field_rename: snake
```

JSON:
```json
{
  "userProfile": {
    "firstName": "First Name"
  }
}
```

Generated (with snake_case):
```dart
appLocalizations.user_profile.first_name
```

## Advanced Features

### Parameter Interpolation

```json
{
  "greeting": "Hello, {name}!",
  "items": "You have {count} items"
}
```

```dart
appLocalizations.greeting(name: 'John');
appLocalizations.items(count: '5');
```

### Pluralization

```json
{
  "items": {
    "@plural": {
      "zero": "No items",
      "one": "One item",
      "other": "{count} items"
    }
  }
}
```

### Gender Forms

```json
{
  "greeting": {
    "@gender": {
      "male": "Hello Mr. {name}",
      "female": "Hello Ms. {name}",
      "other": "Hello {name}"
    }
  }
}
```

### Context Forms

```json
{
  "invitation": {
    "@context": {
      "formal": "We cordially invite you",
      "informal": "Come join us"
    }
  }
}
```

### Nested Structure (10 Levels)

```json
{
  "level1": {
    "level2": {
      "level3": {
        "message": "Deeply nested translation"
      }
    }
  }
}
```

```dart
appLocalizations.level1.level2.level3.message;
```

### Watch Mode

```bash
dart run localization_gen generate --watch
```

Automatically regenerates code when JSON files change.

### Strict Validation

```yaml
localization_gen:
  strict_validation: true
```

Ensures all locales have:
- Same translation keys
- Same parameter names
- Consistent structure

### Modular Organization

```yaml
localization_gen:
  modular: true
  file_prefix: app
```

File structure:
```
assets/localizations/
  app_auth_en.json
  app_auth_id.json
  app_home_en.json
  app_home_id.json
```

Files are automatically merged by locale.

## Examples

See the `example/` directory:

- [example/basic/](https://github.com/alpinnz/localization_gen/tree/master/example/basic) - Basic usage
- [example/modular/](https://github.com/alpinnz/localization_gen/tree/master/example/modular) - Modular organization

## Migration Guide

### From v1.0.3 to v1.0.4+

Named parameters are now required:

```dart
// Before
appLocalizations.welcome('John');

// After
appLocalizations.welcome(name: 'John');
```

## Troubleshooting

### Generated file not found

Ensure `output_dir` exists and check file permissions.

### Locale not switching

Verify `localizationsDelegates` and `supportedLocales` in MaterialApp.

### Parameter type mismatch

All parameters are String type. Convert numbers before passing.

### Validation errors

Run `dart run localization_gen validate` for detailed error messages.

## Best Practices

1. Use consistent naming: `appLocalizations` as variable name
2. Group related translations in nested structure
3. Use descriptive parameter names
4. Enable strict validation in production
5. Use watch mode during development
6. Consider modular organization for large apps

## Contributing

Contributions welcome! See [CONTRIBUTING.md](https://github.com/alpinnz/localization_gen/blob/master/CONTRIBUTING.md)

## License

MIT License - see [LICENSE](https://github.com/alpinnz/localization_gen/blob/master/LICENSE)

## Links

- **Pub.dev**: https://pub.dev/packages/localization_gen
- **GitHub**: https://github.com/alpinnz/localization_gen
- **Issues**: https://github.com/alpinnz/localization_gen/issues
- **Changelog**: https://github.com/alpinnz/localization_gen/blob/master/CHANGELOG.md
- **Documentation**: https://github.com/alpinnz/localization_gen

