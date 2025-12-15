# Examples

This directory contains examples demonstrating how to use `localization_gen`.

## Simple Examples

The following standalone examples show basic usage:

### 1. Basic Usage (`basic_usage.dart`)

The simplest way to use localization_gen:

```bash
dart run example/basic_usage.dart
```

Demonstrates:
- Creating a LocalizationGenerator instance
- Running the generation process
- Default configuration from pubspec.yaml

### 2. Custom Configuration (`custom_config.dart`)

Using a custom configuration file:

```bash
dart run example/custom_config.dart
```

Demonstrates:
- Using a custom pubspec.yaml path
- Overriding default configuration

### 3. Programmatic Usage (`programmatic_usage.dart`)

Using individual package components:

```bash
dart run example/programmatic_usage.dart
```

Demonstrates:
- Reading configuration with ConfigReader
- Parsing JSON files with JsonLocalizationParser
- Generating code with DartWriter
- Writing output files

## Quick Start

1. Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.0.4

localization_gen:
  input_dir: 'assets/localizations'
  output_dir: 'lib/assets'
  class_name: 'AppLocalizations'
```

2. Create JSON files in `assets/localizations/`:

```json
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome_user": "Welcome {name}!"
}
```

3. Generate code:

```bash
dart run localization_gen
```

4. Use in your Flutter app:

```dart
import 'assets/app_localizations.dart';

// In your MaterialApp
localizationsDelegates: [
  AppLocalizationsExtension.delegate,
],
supportedLocales: AppLocalizations.supportedLocales,

// In your widgets
final l10n = AppLocalizations.of(context);
Text(l10n.hello);
Text(l10n.welcome_user(name: 'John'));
```

## Full Flutter Examples

For complete Flutter application examples, see:

- `default/` - Complete Flutter app with basic localization
- `modular/` - Modular file organization with multiple modules
- `monorepo/` - Multi-package monorepo setup

These are full Flutter projects and can be run with:

```bash
cd example/default
flutter run
```

