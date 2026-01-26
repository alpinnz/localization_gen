# Modular Example

Feature-based modular localization for large applications.

Repository: https://github.com/alpinnz/localization_gen/tree/master/example/modular

## Overview

This example demonstrates how to organize localization files by feature/module.
Multiple JSON files per locale are merged during code generation.

- Input: `assets/localizations/app_<module>_<locale>.json`
- Output: `lib/assets/app_localizations.gen.dart`

## Quick Start

```bash
flutter pub get

dart run localization_gen generate

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
  file_pattern: app_{module}_{locale}.json
  file_prefix: app
```

## File Structure (simplified)

```
modular/
├── lib/
│   └── assets/
│       └── app_localizations.gen.dart
└── assets/
    └── localizations/
        ├── app_auth_en.json
        ├── app_auth_id.json
        ├── app_common_en.json
        ├── app_common_id.json
        ├── app_home_en.json
        ├── app_home_id.json
        ├── app_settings_en.json
        └── app_settings_id.json
```

## How It Works

Files are merged by locale. For example:

- English: `app_auth_en.json` + `app_common_en.json` + `app_home_en.json` + `app_settings_en.json`
- Indonesian: `app_auth_id.json` + `app_common_id.json` + `app_home_id.json` + `app_settings_id.json`

Result: a single `AppLocalizations` class with all translations.

## File Naming

Pattern:

```
{prefix}_{module}_{locale}.json
```

Examples:

- `app_auth_en.json`
- `app_home_id.json`

## Usage

```text
import 'assets/app_localizations.gen.dart';

final l10n = AppLocalizations.of(context);

Text(l10n.login.title);
Text(l10n.welcome);
```

## Next Steps

- Add new module: create `app_newmodule_en.json` and `app_newmodule_id.json`
- Run `dart run localization_gen generate`
