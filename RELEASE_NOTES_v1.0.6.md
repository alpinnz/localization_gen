# Release Notes v1.0.6

## 🎉 What's New in v1.0.6

Version 1.0.6 brings powerful development tools and production-ready validation features to make localization easier and more reliable.

### 🚀 Major Features

#### 1. Watch Mode - Auto-Regeneration
Never manually regenerate again during development! Watch mode monitors your JSON files and automatically regenerates when you save.

```bash
dart run localization_gen --watch
```

**Features:**
- 👀 Monitors your localization directory in real-time
- ⚡ Debounced regeneration (default 300ms, customizable)
- 🎯 Smart filtering - only processes .json files
- 📝 Clear console feedback
- ⌨️ Graceful shutdown with Ctrl+C

**Learn More:** [WATCH_MODE.md](WATCH_MODE.md)

#### 2. Strict Validation - Ensure Quality
Catch locale inconsistencies at build time, not runtime!

```yaml
localization_gen:
  strict_validation: true
```

**What it validates:**
- ✅ All locales have identical translation keys
- ✅ Parameters match across locales (order-independent)
- ✅ No missing or extra keys between locales

**Learn More:** [STRICT_VALIDATION.md](STRICT_VALIDATION.md)

#### 3. Enhanced Error Handling
Get clear, actionable error messages with file paths and detailed context.

**New Exception Types:**
- `LocalizationException` - Base class for all errors
- `JsonParseException` - JSON syntax errors with file location
- `LocaleValidationException` - Missing/extra keys with full list
- `ParameterException` - Parameter mismatches with details
- `FileOperationException` - File I/O errors
- `ConfigException` - Configuration errors

**Example Error:**
```
LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (2):
    - auth.login.forgot_password
    - settings.theme
  File: assets/localizations/app_id.json
```

### 📚 Documentation Updates

- **README.md**: Comprehensive update with all new features
- **WATCH_MODE.md**: Complete guide to watch mode
- **STRICT_VALIDATION.md**: Detailed validation documentation
- **CHANGELOG.md**: Full version history
- **Error examples**: Common errors and how to fix them

### 🧪 Testing

- **30+ new tests** for error handling and watch mode
- **100% coverage** of new exception types
- **Integration tests** for end-to-end workflows
- **Validation tests** for locale consistency

### ⚡ CLI Improvements

**New Options:**
```bash
-w, --watch              # Enable watch mode
-d, --debounce=<ms>      # Debounce delay (default: 300)
-c, --config=<path>      # Custom config file path
-h, --help               # Show usage information
```

**Examples:**
```bash
# Basic watch mode
dart run localization_gen --watch

# Custom debounce
dart run localization_gen --watch --debounce=500

# Custom config
dart run localization_gen --config=custom_pubspec.yaml
```

## 📦 Installation

Update your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.0.6

dependencies:
  flutter_localizations:
    sdk: flutter
```

Then run:
```bash
dart pub get
```

##  Migration from v1.0.5

**Good news:** No breaking changes! All existing code works without modifications.

**To use new features:**

1. **Enable Watch Mode:**
   ```bash
   dart run localization_gen --watch
   ```

2. **Enable Strict Validation:**
   ```yaml
   localization_gen:
     strict_validation: true
   ```

That's it! No code changes needed.

##  Use Cases

### During Development
```bash
# Terminal 1: Flutter app
flutter run

# Terminal 2: Watch mode
dart run localization_gen --watch

# Edit JSON files - auto-regenerates!
# Hot restart Flutter app to see changes
```

### In Production
```yaml
# pubspec.yaml - Ensure quality
localization_gen:
  strict_validation: true
```

```yaml
# CI/CD - Fail build on inconsistencies
- run: dart run localization_gen
```

### Team Collaboration
```yaml
# Prevent accidental locale drift
localization_gen:
  strict_validation: true
```

All team members must keep locales in sync!

##  Performance

- **Generation Speed**: No significant impact from validation (~10-50ms)
- **Watch Mode**: Minimal CPU usage, efficient file monitoring
- **Memory**: No memory leaks, properly handles resources

##  Bug Fixes

- Fixed async handling for watch mode
- Improved error messages for malformed JSON
- Better handling of unsupported value types
- Enhanced file path resolution

##  Technical Details

### New Dependencies
- `watcher: ^1.1.0` - For file watching functionality

### New Files
- `lib/src/watcher/file_watcher.dart` - Watch mode implementation
- `lib/src/exceptions/exceptions.dart` - Custom exception classes
- `test/error_handling_test.dart` - Error handling tests
- `test/watcher_test.dart` - Watch mode tests

### Updated Files
- `lib/src/command/generate_command.dart` - Added watch mode support
- `lib/src/parser/json_parser.dart` - Enhanced error handling
- `lib/src/model/localization_item.dart` - Added strict_validation config
- `lib/src/generator/localization_generator.dart` - Validation integration
- `bin/localization_gen.dart` - Async main function

## 🎓 Learning Resources

### Quick Start
1. [Quick Start Guide](QUICKSTART.md) - Get started in 5 minutes
2. [Watch Mode Guide](WATCH_MODE.md) - Master watch mode
3. [Strict Validation Guide](STRICT_VALIDATION.md) - Ensure quality

### Examples
- [Basic Example](example/default/) - Standard usage
- [Modular Example](example/modular/) - Large projects
- [Monorepo Example](example/monorepo/) - Enterprise apps

### Reference
- [README.md](README.md) - Complete documentation
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [EXAMPLES.md](EXAMPLES.md) - Detailed examples

##  Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) (coming soon).

##  Support

-  [Documentation](https://github.com/alpinnz/localization_gen)
-  [Report Issues](https://github.com/alpinnz/localization_gen/issues)
-  [Discussions](https://github.com/alpinnz/localization_gen/discussions)

##  Acknowledgments

Thanks to all contributors and users who provided feedback to make this release possible!

##  Release Timeline

- **v1.0.4** (Nov 2024): Named parameters
- **v1.0.5** (Dec 15, 2025): Complete API documentation
- **v1.0.6** (Dec 16, 2025): Watch mode & strict validation ← **You are here!**

##  What's Next?

Coming in future releases:
- Pluralization support (ICU MessageFormat)
- RTL language metadata
- Custom validation rules
- Performance optimizations for very large projects (10,000+ keys)

---

**Ready to upgrade?**

```bash
# Update dependency
dart pub upgrade localization_gen

# Try watch mode!
dart run localization_gen --watch
```

Happy localizing! 🌍✨

