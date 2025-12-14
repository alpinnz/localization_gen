# Localization Gen Example

This example demonstrates how to use the `localization_gen` package with nested JSON structure.

## Features Demonstrated

- Nested translation structure (`auth.login.title`, `settings.profile.editProfile`)
- Multiple locales (English, Spanish, Indonesian)
- String interpolation with parameters (`{name}`, `{count}`)
- Type-safe access to translations  

## Project Structure

```
example/
├── assets/localizations/
│   ├── app_en.json    # English translations
│   ├── app_es.json    # Spanish translations
│   └── app_id.json    # Indonesian translations
├── lib/
│   └── main.dart      # Example app
└── pubspec.yaml       # Configuration
```

## JSON Translation Files

The example uses nested JSON for better organization:

```json
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "save": "Save"
  },
  "auth": {
    "login": {
      "title": "Login",
      "email": "Email"
    }
  },
  "home": {
    "welcomeUser": "Welcome, {name}!"
  }
}
```

## Running the Example

1. **Generate localization code:**
   ```bash
   dart run localization_gen:localization_gen
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

## Generated Code

The generator creates type-safe code in `.dart_tool/localization_gen/app_localizations.dart`:

```dart
final l10n = AppLocalizations.of(context);

// Access nested translations
l10n.common.hello          // "Hello"
l10n.auth.login.title      // "Login"
l10n.auth.login.email      // "Email"

// With parameters
l10n.home.welcomeUser('John')  // "Welcome, John!"
```

## Supported Locales

- 🇬🇧 English (`en`)
- 🇪🇸 Spanish (`es`)
- 🇮🇩 Indonesian (`id`)

## Configuration

See `pubspec.yaml` for configuration:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  use_context: true
  nullable: false
```

## Adding More Translations

1. Edit the JSON files in `assets/localizations/`
2. Add new nested structures as needed
3. Run `dart run localization_gen:localization_gen`
4. Use the new translations with autocomplete!

## Adding New Locales

1. Create a new JSON file: `assets/localizations/app_{locale}.json`
2. Copy structure from an existing file
3. Translate all values
4. Run the generator
5. The new locale is automatically supported!
