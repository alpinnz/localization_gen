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
  localization_gen: ^1.3.1

dependencies:
  flutter_localizations:
    sdk: flutter
```

Install dependencies:

```bash
dart pub get
```

## Quick Start

### 1. Configuration

Add configuration to `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations

  # Optional (defaults shown)
  file_pattern: app_{module}_{locale}.json
  file_prefix: app

  # Optional (default: camel)
  # JSON keys are recommended to be snake_case (e.g. welcome_user)
  # Generated Dart API becomes camelCase (e.g. welcomeUser)
  field_rename: camel  # none, kebab, snake, pascal, camel, screamingSnake
```

### 2. Create JSON Files (modular-only)

This package is **modular-only**. Every file MUST include:
- `@@locale`
- `@@module`

> Canonical spec: `.jsonc` (commented, developer-readable). Generator input: `.json` (strict JSON).

Create `assets/localizations/app_common_en.json`:

```json
{
  "@@locale": "en",
  "@@module": "common",
  "strings": { "app_title": "Demo App" },
  "simple": { "hello": "Hello" },
  "placeholders": { "welcome_user": "Welcome, {name}." }
}
```

Create `assets/localizations/app_common_id.json`:

```json
{
  "@@locale": "id",
  "@@module": "common",
  "strings": { "app_title": "Aplikasi Demo" },
  "simple": { "hello": "Halo" },
  "placeholders": { "welcome_user": "Selamat datang, {name}." }
}
```

## Supported Cases (CASE 1–15)

The canonical dataset lives in this repository under:
- `assets/localizations/app_common_en.jsonc`
- `assets/localizations/app_common_id.jsonc`

The dataset is designed to cover the most common localization cases, each appearing once:

1) `@@locale` metadata
2) `@@module` metadata
3) Basic strings (namespace: `strings.*`)
4) Nested keys (flattened dot-keys; recommended max depth 6)
5) Placeholders `{name}` (named parameters)
6) Multiple placeholders in one message
7) Placeholder reordering across locales
8) Per-key metadata (inline-only)
   - Inline: `@description`, `@example`, `@placeholders`, plus custom `@<name>`
   - For string keys with metadata: wrap using `@value`
9) Newline escaping (`\n`)
10) Quote escaping (`\"`)
11) Unicode punctuation
12) Symbols inside strings (URLs/email/bullets/legal marks)
13) Literal tokens that are not placeholders (e.g. `{{...}}`, `[x]`)
14) Literal braces `{` and `}`
15) Structured forms: `@plural`, `@gender`, `@context`

If you need a working `.json` dataset for generation, mirror the JSONC structure into `.json` files (remove comments).

## Development Commands

Use full commands (cross-platform):

```bash
# Install

dart pub get

# Quality

dart format .
dart analyze
dart test

# Flutter (if you want to run the example app tests)

flutter test

# Generate once

dart run localization_gen generate

# Generate (watch mode)

dart run localization_gen generate --watch

# Validate

dart run localization_gen validate

# Clean generated output

dart run localization_gen clean

# Coverage

dart run localization_gen coverage
```

### 4. Setup Flutter App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.gen.dart';

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
    return Scaffold(
      appBar: AppBar(
        // JSON: strings.app_title
        // Dart: strings.appTitle
        title: Text(AppLocalizations.of(context).strings.appTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // JSON: simple.hello
          Text(AppLocalizations.of(context).simple.hello),

          // JSON: placeholders.welcome_user
          Text(AppLocalizations.of(context).placeholders.welcomeUser(name: 'John')),
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

dart run localization_gen generate

# Watch mode (auto-regenerate on changes)

dart run localization_gen generate --watch
```

### Initialize

```bash
# Create directory structure and sample files

dart run localization_gen init
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
```

### Coverage

```bash
# Generate coverage report

dart run localization_gen coverage

# HTML format

dart run localization_gen coverage --format=html --output=coverage.html
```

## Configuration Options

```yaml
localization_gen:
  # Required
  input_dir: assets/localizations

  # Optional (defaults shown)
  output_dir: lib/assets
  class_name: AppLocalizations

  # Optional: control naming of generated Dart identifiers (default: camel)
  field_rename: camel

  # Optional: modular file naming (defaults shown)
  file_pattern: app_{module}_{locale}.json
  file_prefix: app
```

### Mandatory behavior (not configurable)

This package always enforces the following:
- **BuildContext access is always available**: `AppLocalizations.of(context)` is generated.
- **Non-nullable access**: `of(context)` returns a non-null instance.
- **Modular-only input**: every file must include `@@locale` and `@@module`.
- **Strict validation is always enabled**: keys and placeholders must match across locales.


## Field Rename Options

Control how JSON keys are converted to Dart identifiers:

- **none**: Keep original naming
- **kebab**: user-name
- **snake**: user_name
- **pascal**: UserName
- **camel**: userName (default)
- **screamingSnake**: USER_NAME

Example:

```yaml
localization_gen:
  field_rename: camel
```

JSON:
```json
{
  "userProfile": {
    "firstName": "First Name"
  }
}
```

Generated (with camelCase):

```text
appLocalizations.userProfile.firstName;
```

## Advanced Features

### Parameter Interpolation

```json
{
  "greeting": "Hello, {name}!",
  "items": "You have {count} items"
}
```

```text
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

```text
appLocalizations.level1.level2.level3.message;
```

### Watch Mode

```bash
dart run localization_gen generate --watch
```

Automatically regenerates code when JSON files change.

### Strict Validation

Strict validation is always enabled (no configuration needed).

### Modular Organization

This package is modular-only. File naming follows:

- `app_{module}_{locale}.json`

Recommended file structure:
```
assets/localizations/
  app_common_en.json
  app_common_id.json
```

Files are merged by locale.

## Examples

See the `example/` directory:

- [example/](https://github.com/alpinnz/localization_gen/tree/master/example) - Canonical example app

## Migration Guide

### From v1.0.3 to v1.0.4+

Named parameters are now required:

```text
// Before
appLocalizations.welcome('John');

// After
appLocalizations.welcome(name: 'John');
```

## Troubleshooting

### Generated file not found

By default the generator writes:

- `lib/assets/<class_name in snake_case>.gen.dart`

If you override `output_dir`, adjust your imports accordingly.

### Newline (\n) handling

In JSON there is an important difference:

- `"Line 1\nLine 2"` produces a real newline character at runtime.
- `"Line 1\\nLine 2"` produces the two characters `\` and `n` (literal backslash-n).

The generator preserves the parsed string value. If you want a real newline in the UI, store `\n` (single backslash) in JSON.

## Best Practices

1. Use consistent naming: `appLocalizations` as variable name
2. Group related translations in nested structure
3. Use descriptive parameter names
4. Strict validation is always enabled
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
