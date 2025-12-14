# Quick Start Guide - Localization Gen

Get started with type-safe, nested localization in 5 minutes!

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen:
    path: ../  # Or use pub.dev version when published

localization_gen:
  input_dir: assets/l10n
  output_dir: lib/generated
  class_name: AppLocalizations
```

## Step 1: Create JSON Files

Create `assets/l10n/app_en.json`:

```json
{
  "@@locale": "en",
  "app": {
    "title": "My App"
  },
  "auth": {
    "login": "Login",
    "logout": "Logout"
  },
  "greeting": "Hello, {name}!"
}
```

Create `assets/l10n/app_es.json`:

```json
{
  "@@locale": "es",
  "app": {
    "title": "Mi Aplicación"
  },
  "auth": {
    "login": "Iniciar sesión",
    "logout": "Cerrar sesión"
  },
  "greeting": "¡Hola, {name}!"
}
```

## Step 2: Generate Code

```bash
dart run localization_gen:localization_gen
```

You should see:
```
Starting localization generation...
Found 2 locale(s): en, es
Done! Generated X translations.
```

## Step 3: Setup Flutter App

Add to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add these 3 lines:
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

## Step 4: Use Translations

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.app.title),  // Type-safe nested access!
      ),
      body: Column(
        children: [
          Text(l10n.greeting('Alice')),  // With parameters
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.auth.login),
          ),
        ],
      ),
    );
  }
}
```

## That's It!

You now have:
- Type-safe translations
- Full IDE autocomplete
- Nested organization
- Multiple language support
- Compile-time checking

## Advanced: Deep Nesting

You can nest as deep as you want:

```json
{
  "settings": {
    "profile": {
      "personal": {
        "name": "Name",
        "email": "Email"
      },
      "security": {
        "password": "Password",
        "twoFactor": "Two-Factor Auth"
      }
    }
  }
}
```

Access with:
```dart
l10n.settings.profile.personal.name
l10n.settings.profile.security.password
```

## Workflow

Every time you update translations:

1. Edit JSON files
2. Run: `dart run localization_gen:localization_gen`
3. Code is automatically updated!

## More Examples

See the [example](example/) folder for a complete working app with:
- Multiple locales (English, Spanish, Indonesian)
- Deep nesting (3+ levels)
- Parameter interpolation
- Real-world UI examples

## Need Help?

- Read the [full README](README.md)
- Check the [real-world examples](EXAMPLES.md)
- See the [example app](example/) for complete code

---

**Happy coding!**

