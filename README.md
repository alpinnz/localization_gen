# Localization Generator

A powerful and type-safe localization generator for Flutter applications using JSON files.

[![Pub Version](https://img.shields.io/pub/v/localization_gen)](https://pub.dev/packages/localization_gen)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/alpinnz/localization_gen/blob/master/LICENSE)

> **Latest Update - v1.0.6**  
> Version 1.0.6 introduces **watch mode** and **strict validation**:
> -  **Watch Mode**: Auto-regenerate on file changes with `--watch`
> -  **Strict Validation**: Ensure locale consistency with `strict_validation: true`
> -  **Enhanced Error Handling**: Clear error messages with file paths and line numbers
> -  **Better Performance**: Optimized code generation
>
> **Previous Update - v1.0.4**  
> Named parameters for better code clarity: `l10n.welcome(name: 'John')`  
> See [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md)

## Features

-  **Type-Safe**: Compile-time checking of translation keys
-  **Nested JSON**: Organize translations hierarchically up to 10 levels deep
-  **Watch Mode**: Auto-regenerate on file changes during development
-  **Modular**: Support for feature-based file organization
-  **Parameter Interpolation**: Dynamic values with named parameters
-  **Strict Validation**: Ensure all locales have consistent keys and parameters
-  **Multi-Package**: Monorepo support with independent localization per package
-  **Customizable**: Flexible configuration options
-  **Production Ready**: Comprehensive testing and error handling

## Why Use This Package?

Traditional flat key-value translation files can become messy in large projects. This package uses **nested JSON** for better organization:

**Traditional Approach:**
```json
{
  "auth_login_title": "Login",
  "auth_login_email": "Email",
  "auth_login_password": "Password"
}
```

**Our Approach:**
```json
{
  "auth": {
    "login": {
      "title": "Login",
      "email": "Email",
      "password": "Password"
    }
  }
}
```

This generates clean, hierarchical code:
```dart
final l10n = AppLocalizations.of(context);
l10n.auth.login.title     // "Login"
l10n.auth.login.email     // "Email"
l10n.auth.login.password  // "Password"
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.0.6

dependencies:
  flutter_localizations:
    sdk: flutter
```

Then run:
```bash
dart pub get
```

## Quick Start

### 1. Configure

Add configuration to `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  strict_validation: true  # Optional: ensure all locales match
```

### 2. Create JSON Files

Create `assets/localizations/app_en.json`:

```json
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "save": "Save"
  },
  "home": {
    "welcome": "Welcome, {name}!"
  }
}
```

Create `assets/localizations/app_id.json`:

```json
{
  "@@locale": "id",
  "common": {
    "hello": "Halo",
    "save": "Simpan"
  },
  "home": {
    "welcome": "Selamat datang, {name}!"
  }
}
```

### 3. Generate Code

**One-time generation:**
```bash
dart run localization_gen
```

**Watch mode (auto-regenerate on file changes):**
```bash
dart run localization_gen --watch
```

**Custom debounce delay:**
```bash
dart run localization_gen --watch --debounce=500
```

### 4. Use in App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.common.hello)),
      body: Text(l10n.home.welcome(name: 'John')),
    );
  }
}
```

## Configuration Options

All configuration options in `pubspec.yaml`:

```yaml
localization_gen:
  # Required
  input_dir: assets/localizations    # Directory containing JSON files
  output_dir: lib/assets              # Where to generate Dart code
  class_name: AppLocalizations        # Name of generated class
  
  # Optional
  use_context: true                   # Enable context-aware access (default: true)
  nullable: false                     # Make translations nullable (default: false)
  modular: false                      # Use modular file organization (default: false)
  file_prefix: app                    # Prefix for JSON files (default: app)
  strict_validation: false            # Validate locale consistency (default: false)
```

### Configuration Details

- **input_dir**: Where your JSON translation files are located
- **output_dir**: Where the generated Dart code will be saved
- **class_name**: Main class name for localization (e.g., `AppLocalizations`)
- **use_context**: Generates static `of(BuildContext)` method for easy access
- **nullable**: Whether `of(context)` returns nullable type
- **modular**: Enable modular file organization (see [Modular Organization](#modular-organization))
- **file_prefix**: Prefix for JSON files when using modular mode
- **strict_validation**: Ensures all locales have identical keys and parameters

### Strict Validation

When `strict_validation: true`, the generator will:
-  Ensure all locales have the same translation keys
-  Verify parameters match across locales (order-independent)
-  Throw clear errors if locales are inconsistent

Example error:
```
LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (2):
    - auth.login.forgot_password
    - settings.theme
  File: assets/localizations/app_id.json
```

## CLI Options

The generator supports several command-line options:

```bash
# Show help
dart run localization_gen --help

# Generate once
dart run localization_gen

# Watch mode - auto-regenerate on changes
dart run localization_gen --watch

# Watch mode with custom debounce (milliseconds)
dart run localization_gen --watch --debounce=500

# Custom config file
dart run localization_gen --config=custom_pubspec.yaml
```

### Available Options

- `-h, --help`: Show usage information
- `-w, --watch`: Enable watch mode for auto-regeneration
- `-d, --debounce`: Debounce delay in milliseconds (default: 300)
- `-c, --config`: Path to pubspec.yaml file (default: pubspec.yaml)

## Watch Mode

Watch mode automatically regenerates localization files when JSON files change. Perfect for development!

### Usage

```bash
dart run localization_gen --watch
```

### Features

- 👀 Monitors your `input_dir` for JSON file changes
- ⚡ Debounced regeneration (default 300ms, customizable)
- 🎯 Only processes `.json` files
- ⌨️ Press `Ctrl+C` to stop
- 📝 Clear console output showing what changed

### Example Output

```
Starting localization generation...
Config:
   Input:  assets/localizations
   Output: lib/assets
   Class:  AppLocalizations
   Modular: false

Scanning JSON localization files...
Found 2 locale(s): en, id

Generating Dart code...
Generated: lib/assets/app_localizations.dart

Done! Generated 25 translations.

👀 Watching for changes in: assets/localizations
   Press Ctrl+C to stop

🔄 File modified: app_en.json
   Regenerating...
✅ Regeneration complete
```

### Best Practices

1. **Use During Development**: Run watch mode in a terminal while developing
2. **Adjust Debounce**: Increase debounce for slower machines or very large files
3. **Git Integration**: Add generated files to `.gitignore` if regenerating in CI/CD

## Error Handling

The generator provides detailed error messages to help you fix issues quickly.

### Common Errors

#### Missing Translation Keys

```
LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (2):
    - auth.login.title
    - home.welcome
  File: assets/localizations/app_id.json
```

**Fix**: Add the missing keys to the Indonesian locale file.

#### Parameter Mismatch

```
ParameterException: Parameter mismatch between locales
  Key: home.welcome
  Expected parameters: name
  Actual parameters: user
  File: assets/localizations/app_id.json
```

**Fix**: Use the same parameter names in all locale files.

#### Invalid JSON

```
JsonParseException: Invalid JSON format
  File: assets/localizations/app_en.json
  Line: 5
  Content: {"key": "value",}
```

**Fix**: Remove the trailing comma or fix JSON syntax.

#### Unsupported Value Types

```
Warning: Unsupported value type int for key "version"
  File: assets/localizations/app_en.json
```

**Fix**: JSON values must be strings or nested objects. Convert numbers/booleans to strings.

## JSON File Format

### Basic Structure

```json
{
  "@@locale": "en",
  "section": {
    "key": "Value",
    "nested": {
      "key": "Nested value"
    }
  }
}
```

### With Parameters

```json
{
  "@@locale": "en",
  "greetings": {
    "welcome": "Welcome, {name}!",
    "items": "You have {count} items"
  }
}
```

Usage:
```dart
l10n.greetings.welcome(name: 'John')      // "Welcome, John!"
l10n.greetings.items(count: '5')          // "You have 5 items"
```

### Modular Organization

For large projects, use modular organization with `modular: true`:

```
assets/localizations/
├── app_auth_en.json      # Authentication module
├── app_auth_id.json
├── app_home_en.json      # Home module
└── app_home_id.json
```

Each file includes module metadata:
```json
{
  "@@locale": "en",
  "@@module": "auth",
  "login": {
    "title": "Login"
  }
}
```

## Examples

This package includes three comprehensive examples:

### Default Example
Traditional nested JSON approach. Best for small to medium apps.
- [View Example](https://github.com/alpinnz/localization_gen/tree/master/example/default)
- 12 tests, all passing

### Modular Example
Feature-based file organization. Best for large apps with multiple teams.
- [View Example](https://github.com/alpinnz/localization_gen/tree/master/example/modular)
- 19 tests, all passing

### Monorepo Example
Multi-package architecture. Best for enterprise applications.
- [View Example](https://github.com/alpinnz/localization_gen/tree/master/example/monorepo)
- 28 tests, all passing

See [EXAMPLES.md](https://github.com/alpinnz/localization_gen/blob/master/EXAMPLES.md) for detailed comparison and usage.

## Advanced Usage

### Language Switching

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(onLanguageChange: _changeLanguage),
    );
  }
}
```

### Accessing Translations

```dart
// In a widget with BuildContext
final l10n = AppLocalizations.of(context);

// Nested access
l10n.auth.login.title

// With parameters (using named parameters)
l10n.home.welcome(name: 'John')

// Deep nesting
l10n.settings.profile.edit.title
```

### Multiple Locales

Create one JSON file per locale:
- `app_en.json` - English
- `app_id.json` - Indonesian
- `app_es.json` - Spanish
- etc.

All files must have the same structure.

## Testing

Run tests for all examples:

```bash
./run_all_tests.sh
```

Or test individually:
```bash
cd example/default && flutter test
cd example/modular && flutter test
cd example/monorepo/app && flutter test
cd example/monorepo/core && flutter test
```

## CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Test
on: [ push, pull_request ]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: ./run_all_tests.sh
```

## Comparison with Other Solutions

| Feature | localization_gen | intl | easy_localization |
|---------|-----------------|------|-------------------|
| Nested JSON | Yes | No | Limited |
| Type Safety | Full | Partial | No |
| Modular Files | Yes | No | No |
| Code Generation | Yes | Yes | No |
| Configuration | YAML | Separate | YAML |
| Monorepo Support | Yes | No | No |

## Migration Guide

### From v1.0.3 to v1.0.4

Version 1.0.4 introduces **improved parameter handling** with named parameters for better code clarity and safety.

**What Changed:**
```dart
// Before (v1.0.3 and earlier) - Positional parameters
l10n.welcome_user('John')
l10n.item_count('5')
l10n.discount('20')

// After (v1.0.4+) - Named parameters with required keyword
l10n.welcome_user(name: 'John')
l10n.item_count(count: '5')
l10n.discount(value: '20')
```

**Migration Steps:**

1. **Update the package:**
   ```yaml
   dev_dependencies:
     localization_gen: ^1.0.4
   ```

2. **Regenerate localization files:**
   ```bash
   dart run localization_gen:localization_gen
   ```

3. **Update all method calls with parameters:**
   - Find all calls to methods with parameters
   - Convert from positional to named parameters
   - Use the parameter name from your JSON (e.g., `{name}` becomes `name:`)

4. **Test your application:**
   - Run all tests to catch any missed conversions
   - The compiler will show errors for any unconverted calls

**Example Migration:**

Before:
```dart
Text(l10n.home.welcome_user('Alice'))
Text(l10n.shop.discount('25'))
Text(l10n.cart.item_count('10'))
```

After:
```dart
Text(l10n.home.welcome_user(name: 'Alice'))
Text(l10n.shop.discount(value: '25'))
Text(l10n.cart.item_count(count: '10'))
```

**Why This Change?**

Named parameters provide:
- Better code clarity
- Prevention of parameter order mistakes
- Improved IDE autocomplete
- Easier maintenance

For detailed migration guide, see [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md).

### From intl

1. Convert ARB files to nested JSON
2. Update configuration
3. Generate code
4. Update import statements
5. Replace `AppLocalizations.of(context)!.key` with `AppLocalizations.of(context).section.key`

### From easy_localization

1. Convert flat JSON to nested structure
2. Add configuration to pubspec.yaml
3. Generate code
4. Replace `tr('key')` with `AppLocalizations.of(context).section.key`

## Troubleshooting

**Issue: Generated file not found**
- Check `output_dir` in configuration
- Ensure generator ran successfully
- Verify file permissions

**Issue: Translations not updating**
- Regenerate after JSON changes
- Perform full restart (not hot reload)
- Check for JSON syntax errors

**Issue: Type errors**
- Ensure all locale files have same structure
- Check for missing keys
- Regenerate code

**Issue: Locale not switching**
- Verify `locale` parameter in MaterialApp
- Check `supportedLocales` list
- Ensure delegates are properly configured

## Best Practices

1. **Organize by Feature**: Group related translations together
2. **Use Nested Structure**: Take advantage of hierarchical organization
3. **Consistent Naming**: Use clear, descriptive key names
4. **Parameter Naming**: Use meaningful parameter names like `{userName}` not `{x}`
5. **Keep Synced**: Ensure all locale files have the same structure
6. **Version Control**: Commit generated files for easier code review
7. **Testing**: Write tests for localized widgets
8. **Documentation**: Document special translation rules in code comments

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

MIT License - see [LICENSE](https://github.com/alpinnz/localization_gen/blob/master/LICENSE) file for details.

## Support

### Documentation
- [Quick Start Guide](https://github.com/alpinnz/localization_gen/blob/master/QUICKSTART.md) - Get started in 5 minutes
- [Examples](https://github.com/alpinnz/localization_gen/blob/master/EXAMPLES.md) - Real-world examples
- [Changelog](https://github.com/alpinnz/localization_gen/blob/master/CHANGELOG.md) - Version history

### v1.0.4 Update Resources
- [Update Guide](https://github.com/alpinnz/localization_gen/blob/master/UPDATE_V1.0.4.md) - Complete update documentation
- [Migration Guide](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md) - Step-by-step migration

### Get Help
- [Report Issues](https://github.com/alpinnz/localization_gen/issues)
- [Discussions](https://github.com/alpinnz/localization_gen/discussions)
- Contact maintainer via GitHub

## Acknowledgments

Inspired by the need for better localization organization in large Flutter projects.

---

**Version:** 1.0.4  
**Dart SDK:** >=3.0.0 <4.0.0  
**Flutter:** >=3.0.0
