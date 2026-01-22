# Localization Gen Examples

Working examples demonstrating different usage patterns of `localization_gen`.

Repository: https://github.com/alpinnz/localization_gen/tree/master/example

## Available Examples

### Basic Example

Path: `example/basic/`

Single file per locale. Suitable for small to medium applications.

- Locales: English (en), Indonesian (id)
- Input: `assets/localizations/app_<locale>.json`
- Output: `lib/assets/app_localizations.gen.dart`

### Modular Example

Path: `example/modular/`

Multiple files per locale. Suitable for feature-based organization.

- Locales: English (en), Indonesian (id)
- Input: `assets/localizations/<prefix>_<module>_<locale>.json`
- Output: `lib/assets/app_localizations.gen.dart`

## Run

From the repository root:

```bash
# Basic example
cd example/basic
flutter pub get
dart run localization_gen generate
flutter run

# Modular example
cd ../modular
flutter pub get
dart run localization_gen generate
flutter run
```

## Documentation

- Basic: https://github.com/alpinnz/localization_gen/tree/master/example/basic
- Modular: https://github.com/alpinnz/localization_gen/tree/master/example/modular
- Main README: https://github.com/alpinnz/localization_gen
