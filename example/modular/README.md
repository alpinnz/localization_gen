# Modular Example

Feature-based modular localization for large applications.

**Repository**: https://github.com/alpinnz/localization_gen/tree/master/example/modular

## Features

- Multiple JSON files per locale
- Feature-based organization
- Automatic merging by locale
- Scalable structure

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate (merges all files)
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
  modular: true
  file_prefix: app
```

## File Structure

```
modular/
├── lib/
│   └── assets/
│       └── app_localizations.dart     # Generated (merged)
└── assets/
    └── localizations/
        ├── app_auth_en.json           # Auth - English
        ├── app_auth_id.json           # Auth - Indonesian
        ├── app_home_en.json           # Home - English
        └── app_home_id.json           # Home - Indonesian
```

## How It Works

Files are merged by locale:

**English** = `app_auth_en.json` + `app_home_en.json`  
**Indonesian** = `app_auth_id.json` + `app_home_id.json`

Result: Single `AppLocalizations` class with all translations.

## File Naming

```
{prefix}_{module}_{locale}.json

Examples:
app_auth_en.json
app_home_id.json
app_settings_en.json
```

## Usage

```dart
import 'assets/app_localizations.dart';

// All modules merged
final appLocalizations = AppLocalizations.of(context);

Text(appLocalizations.login.title);  // Auth module
Text(appLocalizations.welcome);      // Home module
```

## Benefits

- Clear feature separation
- Easier maintenance
- Team collaboration friendly
- Add/remove modules easily

## Next Steps

- Add new module: Create `app_newmodule_en.json` and `app_newmodule_id.json`
- Run `dart run localization_gen`
- Translations automatically merged

