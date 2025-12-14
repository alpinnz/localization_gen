# Quick Start Guide

Get started with localization_gen in 5 minutes.

## Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Basic Setup

### 1. Configure

Add configuration to `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
```

### 2. Create Translation Files

Create `assets/localizations/app_en.json`:

```json
{
  "@@locale": "en",
  "common": {
    "hello": "Hello",
    "save": "Save",
    "cancel": "Cancel"
  },
  "home": {
    "title": "Home",
    "welcome": "Welcome, {name}!"
  }
}
```

Create `assets/localizations/app_id.json`:

```json
{
  "@@locale": "id",
  "common": {
    "hello": "Halo",
    "save": "Simpan",
    "cancel": "Batal"
  },
  "home": {
    "title": "Beranda",
    "welcome": "Selamat datang, {name}!"
  }
}
```

### 3. Generate Code

Run the generator:

```bash
dart run localization_gen:localization_gen
```

This creates `lib/assets/app_localizations.dart`.

### 4. Setup Flutter App

Update your `MaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      localizationsDelegates: const [
        AppLocalizationsExtension.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
```

### 5. Use in Widgets

Access translations in your widgets:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home.title),
      ),
      body: Column(
        children: [
          Text(l10n.common.hello),
          Text(l10n.home.welcome('John')),
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

## That's It!

You now have type-safe, nested localization working in your app.

## Next Steps

- **Add More Languages:** Create more JSON files (e.g., `app_es.json`)
- **Organize Better:** Use nested structures for complex features
- **Try Modular:** Check out the modular example for large apps
- **Read Examples:** See [EXAMPLES.md](https://github.com/alpinnz/localization_gen/blob/master/EXAMPLES.md) for advanced patterns

## Common Configuration Options

```yaml
localization_gen:
  input_dir: assets/localizations    # Where JSON files are located
  output_dir: lib/assets              # Where to generate code
  class_name: AppLocalizations        # Name of generated class
  use_context: true                   # Enable context-aware access
  nullable: false                     # Make fields non-nullable
  modular: false                      # Use modular file organization
  file_prefix: app                    # Prefix for JSON files
```

## Troubleshooting

**Generated file not found?**
- Check `output_dir` path in configuration
- Ensure you ran the generator
- Verify the file is created in correct location

**Translations not updating?**
- Run the generator after JSON changes
- Restart hot reload (full restart)
- Check for syntax errors in JSON

**Type errors?**
- Ensure all JSON files have same structure
- Check for typos in key names
- Regenerate after JSON changes

## Learn More

- [Full Documentation](https://github.com/alpinnz/localization_gen#readme)
- [Examples](https://github.com/alpinnz/localization_gen/blob/master/EXAMPLES.md)
- [Changelog](https://github.com/alpinnz/localization_gen/blob/master/CHANGELOG.md)

## Support

Found an issue? Have a question?
- Check the examples directory
- Read the full README
- Look at test files for usage patterns

