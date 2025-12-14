# Localization Gen Example

This example demonstrates how to use the `localization_gen` package with nested JSON structure and **runtime language switching**.

## Features Demonstrated

- ✅ **Runtime Language Switching** - Switch between English, Indonesian, and Spanish on the fly
- ✅ Nested translation structure (`auth.login.title`, `settings.profile.edit_profile`)
- ✅ Multiple locales (English, Spanish, Indonesian)
- ✅ String interpolation with parameters (`{name}`, `{count}`, `{value}`)
- ✅ Type-safe access to translations
- ✅ Snake_case naming convention for keys
- ✅ Interactive UI with language selector

## How to Try the Demo

### Quick Start
```bash
cd example
flutter run
```

### Try Language Switching
1. **Launch the app** - Default language is English 🇺🇸
2. **Click the language icon** (🌐) in the AppBar
3. **Select a language:**
   - 🇺🇸 English
   - 🇮🇩 Indonesia
   - 🇪🇸 Español
4. **Watch the UI update** instantly with new translations!

### Or Use the Language Chips
- At the top of the screen, you'll see colorful language chips
- Click any chip to switch language immediately
- The selected language is highlighted

## Project Structure

```
example/
├── assets/localizations/
│   ├── app_en.json    # 🇺🇸 English translations
│   ├── app_id.json    # 🇮🇩 Indonesian translations
│   └── app_es.json    # 🇪🇸 Spanish translations
├── lib/
│   ├── main.dart      # Example app with language switcher
│   └── assets/
│       └── app_localizations.dart  # Generated code
└── pubspec.yaml       # Configuration
```

## JSON Translation Files

The example uses nested JSON with **snake_case** keys for better organization:

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
      "email": "Email",
      "forgot_password": "Forgot Password?"
    }
  },
  "home": {
    "welcome_user": "Welcome, {name}!",
    "item_count": "You have {count} items",
    "discount": "Discount {value}%"
  }
}
```

## Demo Features in the App

### 1. Language Selector Card
- Shows current language with flag emoji
- Interactive chips to switch languages
- Updates entire app instantly

### 2. Parameterized Strings
- `welcome_user("John Doe")` → "Welcome, John Doe!" / "Selamat datang, John Doe!"
- `item_count("5")` → "You have 5 items" / "Anda memiliki 5 item"
- `discount("20")` → "Discount 20%" / "Diskon 20%"

### 3. Nested Translations
Access nested keys naturally:
```dart
AppLocalizations.of(context).auth.login.forgot_password
AppLocalizations.of(context).settings.profile.edit_profile
AppLocalizations.of(context).home.welcome_user("John")
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

- English (`en`)
- Spanish (`es`)
- Indonesian (`id`)

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
