# Localization Generator

A powerful and type-safe localization generator for Flutter applications using JSON files.

[![Pub Version](https://img.shields.io/pub/v/localization_gen)](https://pub.dev/packages/localization_gen)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- **Type-Safe**: Compile-time checking of translation keys
- **Nested JSON**: Organize translations hierarchically for better maintainability
- **Modular**: Support for feature-based file organization
- **Parameter Interpolation**: Dynamic values in translations
- **Multi-Package**: Monorepo support with independent localization per package
- **Customizable**: Flexible configuration options
- **Production Ready**: Comprehensive examples and testing

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
  localization_gen: ^1.0.0

dependencies:
  flutter_localizations:
    sdk: flutter
```

## Quick Start

### 1. Configure

Add configuration to `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
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

### 3. Generate Code

```bash
dart run localization_gen:localization_gen
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
      body: Text(l10n.home.welcome('John')),
    );
  }
}
```

## Configuration Options

```yaml
localization_gen:
  # Required
  input_dir: assets/localizations    # Directory containing JSON files
  output_dir: lib/assets              # Where to generate Dart code
  class_name: AppLocalizations        # Name of generated class
  
  # Optional
  use_context: true                   # Enable context-aware access (default: true)
  nullable: false                     # Make translations non-nullable (default: false)
  modular: false                      # Use modular file organization (default: false)
  file_prefix: app                    # Prefix for JSON files (default: app)
```

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
l10n.greetings.welcome('John')      // "Welcome, John!"
l10n.greetings.items('5')           // "You have 5 items"
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
- [View Example](example/default/)
- 12 tests, all passing

### Modular Example
Feature-based file organization. Best for large apps with multiple teams.
- [View Example](example/modular/)
- 19 tests, all passing

### Monorepo Example
Multi-package architecture. Best for enterprise applications.
- [View Example](example/monorepo/)
- 28 tests, all passing

See [EXAMPLES.md](EXAMPLES.md) for detailed comparison and usage.

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

// With parameters
l10n.home.welcome('John')

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
on: [push, pull_request]
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

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- [Documentation](README.md)
- [Quick Start Guide](QUICKSTART.md)
- [Examples](EXAMPLES.md)
- [Changelog](CHANGELOG.md)
- [Issues](https://github.com/yourusername/localization_gen/issues)

## Acknowledgments

Inspired by the need for better localization organization in large Flutter projects.

---

**Version:** 1.0.0  
**Dart SDK:** >=3.0.0 <4.0.0  
**Flutter:** >=3.0.0

