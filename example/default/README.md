# Default Example

A basic example demonstrating traditional nested JSON localization structure.

## Features

- Nested JSON structure for better organization
- Support for English and Indonesian languages
- Parameter interpolation
- Type-safe localization access
- Simple and straightforward implementation

## Structure

This example uses a **single JSON file per locale** with nested structure:

```
assets/localizations/
├── app_en.json
└── app_id.json
```

Each JSON file contains all translations organized by feature:

```json
{
  "@@locale": "en",
  "auth": {
    "login": {
      "title": "Login",
      "email": "Email",
      "password": "Password"
    }
  },
  "home": {
    "welcome": "Welcome!"
  }
}
```

## Generated Code

The generator creates type-safe code with nested access:

```dart
final l10n = AppLocalizations.of(context);
l10n.auth.login.title      // "Login"
l10n.auth.login.email      // "Email"
l10n.home.welcome          // "Welcome!"
```

## Running the Example

```bash
# Navigate to the example directory
cd examples/default

# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## Test Coverage

This example includes 12 comprehensive tests covering:

- App initialization
- Language switching functionality
- UI rendering
- Localization in both languages
- Parameter interpolation
- User interactions

All tests are passing with 100% success rate.

## Use Case

Best suited for:
- Small to medium applications
- Teams preferring simple structure
- Projects with clear feature boundaries
- Traditional Flutter app architecture

## Configuration

The example uses this configuration in `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  use_context: true
  nullable: false
```

## Supported Languages

- English (en)
- Indonesian (id)

## Learn More

- See the main [README](../../README.md) for library documentation
- Check [EXAMPLES.md](../../EXAMPLES.md) for other example types
- Read [QUICKSTART.md](../../QUICKSTART.md) for quick setup guide

