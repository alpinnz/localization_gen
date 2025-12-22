# Basic Example

Simple single-file localization for standard applications.

**Repository**: https://github.com/alpinnz/localization_gen/tree/master/example/basic

## Features

- Single JSON file per locale
- Nested structure for organization
- Parameter interpolation
- Multiple locales (English, Indonesian)
- Flutter widget integration

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate localization code
dart run localization_gen

# Run app
flutter run
```

## Configuration

See `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
```

## File Structure

```
basic/
├── lib/
│   ├── main.dart                      # Flutter app
│   └── assets/
│       └── app_localizations.dart     # Generated
└── assets/
    └── localizations/
        ├── app_en.json                # English
        └── app_id.json                # Indonesian
```

## JSON Structure

```json
{
  "@@locale": "en",
  "hello": "Hello",
  "welcome": "Welcome, {name}!",
  "auth": {
    "login": {
      "title": "Login"
    }
  }
}
```

## Usage

```dart
import 'assets/app_localizations.dart';

final appLocalizations = AppLocalizations.of(context);

// Simple
Text(appLocalizations.hello);

// Nested
Text(appLocalizations.auth.login.title);

// Parameters
Text(appLocalizations.welcome(name: 'John'));
```

## Next Steps

- Modify JSON files in `assets/localizations/`
- Run `dart run localization_gen` to regenerate
- See `../modular/` for large app organization

