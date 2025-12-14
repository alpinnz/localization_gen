# Localization Generator

A powerful and type-safe localization generator for Flutter applications using JSON files.

## Features

- Generate type-safe localization classes from JSON files
- Support for multiple languages
- Simple JSON format
- Customizable configuration
- Context-aware usage in Flutter widgets

## Why Nested JSON?

Traditional flat key-value translation files can become messy in large projects. This package uses **nested JSON** for better organization:

```json
{
  "auth": {
    "login": {
      "title": "Login",
      "email": "Email"
    }
  }
}
```

This generates clean, hierarchical code:
```dart
final l10n = AppLocalizations.of(context);
l10n.auth.login.title  // "Login"
l10n.auth.login.email  // "Email"
```

## Getting Started

### 1. Add to `pubspec.yaml`

```yaml
dev_dependencies:
  localization_gen: ^1.0.0

localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
```

### 2. Create JSON translation files

Create files in `assets/localizations/`:

**app_en.json:**
```json
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "save": "Save",
    "cancel": "Cancel"
  },
  "auth": {
    "login": {
      "title": "Login",
      "button": "Sign In"
    }
  },
  "home": {
    "welcomeUser": "Welcome, {name}!"
  }
}
```

**app_es.json:**
```json
{
  "@@locale": "es",
  "common": {
    "hello": "Hola",
    "save": "Guardar",
    "cancel": "Cancelar"
  },
  "auth": {
    "login": {
      "title": "Iniciar Sesión",
      "button": "Entrar"
    }
  },
  "home": {
    "welcomeUser": "¡Bienvenido, {name}!"
  }
}
```

### 3. Generate code

```bash
dart run localization_gen:localization_gen
```

### 4. Setup in your app

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '.dart_tool/localization_gen/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(),
    );
  }
}
```

### 5. Use in your widgets

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auth.login.title),
      ),
      body: Column(
        children: [
          Text(l10n.common.hello),
          Text(l10n.home.welcomeUser('John')),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.common.save),
          ),
        ],
      ),
    );
  }
}
```

## Usage Examples

### Simple translations
```dart
final l10n = AppLocalizations.of(context);
print(l10n.common.hello);  // "Hello" or "Hola" based on locale
```

### With parameters
```dart
print(l10n.home.welcomeUser('Alice'));  // "Welcome, Alice!"
```

### Nested structure
```dart
l10n.auth.login.title       // "Login"
l10n.auth.login.email       // "Email"
l10n.auth.register.button   // "Sign Up"
l10n.settings.profile.title // "Profile"
```

## Configuration

All configuration is in `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations  # Where JSON files are located
  output_dir: lib/assets           # Where to generate code
  class_name: AppLocalizations     # Name of generated class
  use_context: true                # Generate of(context) method
  nullable: false                  # Make of() return nullable type
```

## JSON File Format

- **File naming**: `app_{locale}.json` (e.g., `app_en.json`, `app_es.json`)
- **Locale marker**: Include `"@@locale": "en"` at the root
- **Nesting**: Use objects for organization
- **Parameters**: Use `{paramName}` syntax for string interpolation

```json
{
  "@@locale": "en",
  "section": {
    "subsection": {
      "key": "Value",
      "withParam": "Hello {name}!"
    }
  }
}
```


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
