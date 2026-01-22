# Basic Example

Simple single-file localization for standard applications.

Repository: https://github.com/alpinnz/localization_gen/tree/master/example/basic

## Overview

This example demonstrates basic usage of `localization_gen` with a Flutter application.

- One JSON file per locale in `assets/localizations/`
- Generated output in `lib/assets/app_localizations.gen.dart`

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
  output_file_suffix: .gen.dart
```

## File Structure

```
basic/
├── lib/
│   ├── main.dart
│   └── assets/
│       └── app_localizations.gen.dart
└── assets/
    └── localizations/
        ├── app_en.json
        └── app_id.json
```

## Usage

```text
import 'assets/app_localizations.gen.dart';

final appLocalizations = AppLocalizations.of(context);

Text(appLocalizations.common.hello);
Text(appLocalizations.auth.login.title);
Text(appLocalizations.home.welcome_user(name: 'John'));
```

## Next Steps

- Modify JSON files in `assets/localizations/`
- Run `dart run localization_gen generate` to regenerate
- See `../modular/` for modular organization
