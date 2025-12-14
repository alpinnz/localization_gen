# Monorepo Example

An enterprise-level example demonstrating multi-package monorepo architecture with independent localization for each package.

## Features

- Multi-package architecture (App + Core)
- Independent localization per package
- Shared library pattern
- Support for English and Indonesian languages
- Enterprise-ready structure

## Structure

This example demonstrates a **monorepo** with multiple packages:

```
monorepo/
├── app/                    # Main Application Package
│   ├── lib/
│   │   └── assets/
│   │       └── app_localizations.dart
│   ├── assets/localizations/
│   │   ├── app_auth_en.json
│   │   ├── app_auth_id.json
│   │   ├── app_home_en.json
│   │   ├── app_home_id.json
│   │   ├── app_settings_en.json
│   │   └── app_settings_id.json
│   └── pubspec.yaml (depends on: core)
│
└── core/                   # Shared Library Package
    ├── lib/
    │   └── assets/
    │       └── core_localizations.dart
    ├── assets/localizations/
    │   ├── core_widgets_en.json
    │   ├── core_widgets_id.json
    │   ├── core_buttons_en.json
    │   └── core_buttons_id.json
    └── pubspec.yaml (independent)
```

## Generated Code

Each package has its own localization class:

**App Package:**
```dart
final appL10n = AppLocalizations.of(context);
appL10n.login.title        // "Login"
appL10n.welcome            // "Welcome!"
```

**Core Package:**
```dart
final coreL10n = CoreLocalizations.of(context);
coreL10n.save              // "Save"
coreL10n.loading           // "Loading..."
```

**Using Both:**
```dart
// In app/lib/main.dart
final appL10n = AppLocalizations.of(context);
final coreL10n = CoreLocalizations.of(context);

Text(appL10n.login.title)        // App-specific
Chip(label: Text(coreL10n.save)) // Shared from Core
```

## Running the Example

### Run the App:
```bash
# Navigate to the app package
cd examples/monorepo/app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Run Tests:
```bash
# Test the app package
cd examples/monorepo/app
flutter test

# Test the core package
cd examples/monorepo/core
flutter test
```

## Test Coverage

### App Package (22 tests):
- App initialization
- Language switching
- Package cards display
- App and Core package integration
- UI interactions
- AppLocalizations API

### Core Package (6 tests):
- CoreLocalizations API
- Buttons module (save, cancel, delete)
- Widgets module (loading, error, retry)
- English and Indonesian translations

Total: 28 tests, all passing with 100% success rate.

## Use Case

Best suited for:
- Enterprise applications
- Multiple apps sharing common code
- White-label applications
- Projects requiring shared component library
- Organizations with multiple products
- Teams building app families

## Benefits

1. **Independent Packages**: Each package has its own dependencies and versioning
2. **Shared Library**: Core package can be used across multiple apps
3. **Separate Localization**: Each package manages its own translations
4. **Scalability**: Easy to add more apps using the same core
5. **Clear Separation**: App-specific vs shared code is clearly defined
6. **Team Organization**: Different teams can own different packages

## Configuration

### App Package (pubspec.yaml):
```yaml
name: monorepo_app
dependencies:
  core:
    path: ../core

localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  modular: true
  file_prefix: app
```

### Core Package (pubspec.yaml):
```yaml
name: core

localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: CoreLocalizations
  modular: true
  file_prefix: core
```

## Supported Languages

- English (en)
- Indonesian (id)

## Package Organization

### App Package
Contains app-specific features:
- Authentication
- Home screen
- Settings
- App-specific UI

### Core Package
Contains shared components:
- Common buttons
- Widget states (loading, error)
- Shared UI elements
- Utility functions

## Setup Instructions

1. **Generate Core Localizations:**
   ```bash
   cd examples/monorepo/core
   dart run localization_gen:localization_gen
   ```

2. **Generate App Localizations:**
   ```bash
   cd examples/monorepo/app
   dart run localization_gen:localization_gen
   ```

3. **Run the App:**
   ```bash
   cd examples/monorepo/app
   flutter run
   ```

## Learn More

- See the main [README](../../README.md) for library documentation
- Check [EXAMPLES.md](../../EXAMPLES.md) for other example types
- Compare with [Modular Example](../modular/) for single-package modular approach

