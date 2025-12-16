# Watch Mode Guide

## Overview

Watch mode enables automatic regeneration of localization files whenever your JSON translation files change. This is
perfect for development workflows, providing instant feedback without manual regeneration.

## Quick Start

```bash
dart run localization_gen --watch
```

That's it! The generator will now monitor your `input_dir` for changes and automatically regenerate when needed.

## Features

- **Automatic Monitoring**: Watches your localization directory for file changes
- **Debounced Regeneration**: Prevents excessive regeneration from rapid changes (default 300ms)
- **Smart Filtering**: Only processes `.json` files
- **Clear Feedback**: Console output shows what changed and regeneration status
- ️ **Easy Exit**: Press `Ctrl+C` to stop gracefully

## Command Line Options

### Basic Watch Mode

```bash
dart run localization_gen --watch
```

### Custom Debounce Delay

Adjust the debounce delay (in milliseconds) to control how quickly regeneration occurs after file changes:

```bash
# Wait 500ms before regenerating (good for slower machines)
dart run localization_gen --watch --debounce=500

# Quick regeneration (100ms delay)
dart run localization_gen --watch --debounce=100

# Very long delay (1 second, for very large projects)
dart run localization_gen --watch --debounce=1000
```

### With Custom Config

```bash
dart run localization_gen --watch --config=custom_pubspec.yaml
```

## Example Output

```
Starting localization generation...

Config:
   Input:  assets/localizations
   Output: lib/assets
   Class:  AppLocalizations
   Modular: false

Scanning JSON localization files...
Parsing: assets/localizations/app_en.json
Parsing: assets/localizations/app_id.json
Parsing: assets/localizations/app_es.json
Found 3 locale(s): en, id, es

Generating Dart code...
Generated: lib/assets/app_localizations.dart

Done! Generated 45 translations.

Add this to your MaterialApp:
   localizationsDelegates: [
     AppLocalizationsExtension.delegate,
     GlobalMaterialLocalizations.delegate,
   ],
   supportedLocales: AppLocalizations.supportedLocales,

 Watching for changes in: assets/localizations
   Press Ctrl+C to stop

 File modified: app_en.json
   Regenerating...
 Regeneration complete

 File added: app_fr.json
   Regenerating...
 Regeneration complete
```

## How It Works

### Event Types

Watch mode responds to three types of file events:

1. **ADD**: New JSON file created
2. **MODIFY**: Existing JSON file changed
3. **REMOVE**: JSON file deleted

All three trigger regeneration to keep your code in sync.

### Debouncing

When you make rapid changes to files (e.g., saving multiple times or bulk editing), the debounce mechanism prevents
multiple regenerations:

1. File change detected
2. Timer starts (default 300ms)
3. If another change occurs, timer resets
4. When timer expires, regeneration runs once

This ensures efficient regeneration even with many rapid changes.

### File Filtering

Only files ending in `.json` trigger regeneration. Other files (`.txt`, `.md`, etc.) are ignored.

## Best Practices

### 1. Run in Separate Terminal

Keep watch mode running in a dedicated terminal window:

```bash
# Terminal 1: Watch mode
dart run localization_gen --watch

# Terminal 2: Your development work
flutter run
```

### 2. Adjust Debounce for Your Workflow

- **Fast machines** + **Small projects**: Use lower debounce (100-200ms)
- **Slow machines** + **Large projects**: Use higher debounce (500-1000ms)
- **Default (300ms)**: Good for most cases

### 3. Hot Restart After Regeneration

Flutter's hot reload doesn't pick up generated code changes. Use hot restart:

```
1. Save your JSON file
2. Wait for "✅ Regeneration complete"
3. Press 'R' in Flutter terminal (hot restart)
```

### 4. Combine with Strict Validation

Enable strict validation to catch errors during development:

```yaml
# pubspec.yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  strict_validation: true  # Catch locale mismatches immediately
```

Then run watch mode:

```bash
dart run localization_gen --watch
```

Now you'll get immediate feedback on locale consistency issues!

## Development Workflow

### Recommended Setup

```bash
# 1. Start Flutter app in terminal 1
cd my_app
flutter run

# 2. Start watch mode in terminal 2
dart run localization_gen --watch

# 3. Edit translations in terminal 3 / IDE
vim assets/localizations/app_en.json

# 4. See regeneration in terminal 2
# 5. Hot restart in terminal 1 (press 'R')
```

### VS Code Setup

Create a VS Code task (`.vscode/tasks.json`):

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Watch Localizations",
      "type": "shell",
      "command": "dart run localization_gen --watch",
      "isBackground": true,
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "dedicated"
      }
    }
  ]
}
```

Run with `Ctrl+Shift+P` → `Tasks: Run Task` → `Watch Localizations`

## Troubleshooting

### Watch Mode Not Starting

**Error**: `Exception: Directory not found: assets/localizations`

**Solution**: Check your `input_dir` configuration in `pubspec.yaml`

```yaml
localization_gen:
  input_dir: assets/localizations  # Make sure this exists
```

### Changes Not Detected

1. **Check file is `.json`**: Only JSON files trigger regeneration
2. **Check debounce**: Wait for debounce period to expire
3. **Restart watch mode**: Press `Ctrl+C` and restart

### Too Many Regenerations

**Problem**: Regenerating multiple times for single save

**Solution**: Increase debounce delay

```bash
dart run localization_gen --watch --debounce=500
```

### High CPU Usage

**Problem**: Watch mode using too much CPU

**Solution**:

1. Increase debounce delay
2. Ensure you're only watching necessary directories
3. Check for file backup tools that might be creating temp files

## CI/CD Integration

Watch mode is for development only. In CI/CD, use one-time generation:

```yaml
# .github/workflows/build.yml
- name: Generate Localizations
  run: dart run localization_gen

# Do NOT use --watch in CI/CD
```

## Advanced Usage

### Multiple Projects

Watch different projects in different terminals:

```bash
# Terminal 1: Main app
cd apps/main_app
dart run localization_gen --watch --config=pubspec.yaml

# Terminal 2: Admin app
cd apps/admin_app
dart run localization_gen --watch --config=pubspec.yaml
```

### Monorepo Setup

Watch all packages:

```bash
# Terminal 1: App package
cd monorepo/app
dart run localization_gen --watch

# Terminal 2: Core package
cd monorepo/core
dart run localization_gen --watch
```

### Custom Watch Script

Create a convenience script (`watch.sh`):

```bash
#!/bin/bash
echo "Starting localization watch mode..."
dart run localization_gen --watch --debounce=400
```

Make it executable:

```bash
chmod +x watch.sh
./watch.sh
```

## Comparison with Manual Generation

| Aspect            | Manual Generation                     | Watch Mode                               |
|-------------------|---------------------------------------|------------------------------------------|
| Command           | `dart run localization_gen` each time | `dart run localization_gen --watch` once |
| Workflow          | Edit → Run command → Hot restart      | Edit → Wait → Hot restart                |
| Efficiency        | Manual step each time                 | Automatic                                |
| Development Speed | Slower                                | Faster                                   |
| CI/CD             | Recommended                           | Not recommended                          |
| Production Builds | ¬ Use this                            | Don't use                                |

## FAQ

**Q: Does watch mode work with modular organization?**  
A: Yes! Watch mode respects your `modular` configuration.

**Q: Can I watch multiple directories?**  
A: No, watch mode monitors the `input_dir` specified in your config. For multiple directories, run multiple watch
instances.

**Q: Does it work on Windows/Linux/macOS?**  
A: Yes, watch mode works on all platforms.

**Q: What happens if I delete all JSON files?**  
A: Watch mode will attempt regeneration and show an error. Add files back to fix.

**Q: Can I use watch mode in production?**  
A: No, watch mode is for development only. Use one-time generation for production builds.

**Q: Does it impact battery life?**  
A: Minimal impact. The file watcher is efficient and only activates on changes.

## Related Documentation

- [Configuration Options](README.md#configuration-options)
- [Strict Validation](STRICT_VALIDATION.md)
- [Error Handling](README.md#error-handling)
- [Examples](EXAMPLES.md)

