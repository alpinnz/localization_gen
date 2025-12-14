# Modular Example

An advanced example demonstrating modular organization with separate JSON files per feature module.

## Features

- Modular JSON structure with separate files per module
- Support for English and Indonesian languages
- Better organization for large projects
- Team-friendly file separation
- Scalable architecture

## Structure

This example uses **multiple JSON files** organized by feature modules:

```
assets/localizations/
├── app_auth_en.json       # Authentication module
├── app_auth_id.json
├── app_home_en.json       # Home module
├── app_home_id.json
├── app_common_en.json     # Common/shared module
├── app_common_id.json
├── app_settings_en.json   # Settings module
└── app_settings_id.json
```

Each file contains translations for a specific feature:

**app_auth_en.json:**
```json
{
  "@@locale": "en",
  "@@module": "auth",
  "login": {
    "title": "Login",
    "email": "Email"
  },
  "errors": {
    "invalid_email": "Invalid email address"
  }
}
```

## Generated Code

The generator creates flat structure per module:

```dart
final l10n = AppLocalizations.of(context);
l10n.login.title           // "Login"
l10n.errors.invalid_email  // "Invalid email address"
```

Note: Unlike nested structure, modular approach has flat access within each module.

## Running the Example

```bash
# Navigate to the example directory
cd example/modular

# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test test/main_test.dart
```

## Test Coverage

This example includes 19 comprehensive tests covering:

- App initialization and loading
- Language switching functionality
- All module displays (Auth, Home, Common, Settings)
- Localization in both languages
- UI interactions and scrolling
- AppLocalizations API

All tests are passing with 100% success rate.

## Use Case

Best suited for:
- Large applications with many features
- Multi-team development
- Projects requiring clear module boundaries
- Applications planning for significant growth
- Teams working on separate features

## Benefits

1. **Better Organization**: Each feature has its own translation file
2. **Team Collaboration**: Teams can work on separate modules without conflicts
3. **Maintainability**: Easier to find and update translations
4. **Scalability**: Add new modules without affecting existing ones
5. **Clear Boundaries**: Feature separation is enforced at translation level

## Configuration

The example uses this configuration in `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  use_context: true
  nullable: false
  modular: true
  file_prefix: app
```

Key setting: `modular: true` enables modular file parsing.

## Supported Languages

- English (en)
- Indonesian (id)

## Module Organization

### Auth Module
- Login form
- Registration
- Error messages

### Home Module
- Welcome messages
- User greetings
- Item counts and discounts

### Common Module
- Shared buttons and actions
- Common UI elements

### Settings Module
- Profile settings
- Preferences
- Theme and language options

## Learn More

- See the main [README](../../README.md) for library documentation
- Check [EXAMPLES.md](../../EXAMPLES.md) for other example types
- Compare with [Default Example](../default/) for traditional approach

