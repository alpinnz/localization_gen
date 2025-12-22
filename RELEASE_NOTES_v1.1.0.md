# Release Notes v1.1.0

**Release Date**: December 22, 2025

## Overview

Version 1.1.0 introduces field rename functionality, allowing developers to customize how JSON keys are converted to Dart identifiers. This release also includes major documentation improvements and expanded test coverage.

## Highlights

### New Feature: Field Rename

Control naming conventions for generated Dart code:

```yaml
localization_gen:
  field_rename: snake  # none, kebab, snake, pascal, camel, screamingSnake
```

**Example**:

JSON Input:
```json
{
  "userProfile": {
    "firstName": "First Name"
  }
}
```

Generated with `snake_case`:
```dart
appLocalizations.user_profile.first_name
```

### Documentation Overhaul

- Consolidated from 23 to 7 markdown files (70% reduction)
- Added full GitHub URLs for navigation
- Professional formatting without emoticons
- Clear structure for users and contributors

### Expanded Test Suite

- 82+ comprehensive tests
- New field rename tests (18 tests)
- Test structure mirrors source code
- Easy to maintain and extend

## What's New

### Features

**FieldRename Enum**
- 6 naming convention options
- Integrated with configuration
- Fully tested and documented

**Configuration Option**
```yaml
field_rename: snake  # New option
```

Supported values:
- `none`: Keep original (default)
- `kebab`: user-name
- `snake`: user_name
- `pascal`: UserName
- `camel`: userName
- `screamingSnake`: USER_NAME

### Improvements

**Documentation**
- README.md: Complete user guide
- CONTRIBUTING.md: Developer guidelines
- CHANGELOG.md: Version history
- Example READMEs: Clear setup instructions
- Test README: Testing documentation

**Test Coverage**
- `test/model/field_rename_test.dart`: New test file
- All conversion options tested
- Edge cases covered
- Integration verified

**Quality**
- No breaking changes
- Backward compatible
- All tests passing
- No compiler warnings

## Installation

```yaml
dev_dependencies:
  localization_gen: ^1.1.0
```

Then run:
```bash
dart pub get
```

## Usage

### Basic Setup

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  field_rename: snake  # Optional, default: none
```

### Generate Code

```bash
dart run localization_gen
```

### Use in Flutter

```dart
final appLocalizations = AppLocalizations.of(context);
Text(appLocalizations.user_profile.first_name);
```

## Migration Guide

### From 1.0.x to 1.1.0

**No breaking changes!** All existing code continues to work.

**Optional Enhancement**:

Add `field_rename` to your configuration:

```yaml
localization_gen:
  # ...existing config...
  field_rename: snake  # Add this line
```

Regenerate your code:
```bash
dart run localization_gen
```

**Note**: Changing `field_rename` will update how you access translations. Plan migration accordingly if you have existing code.

## Breaking Changes

None. Version 1.1.0 is fully backward compatible with 1.0.x.

## Known Issues

None reported.

## Performance

No performance impact. Field rename is applied during code generation only.

## Compatibility

- Dart SDK: >=3.0.0 <4.0.0
- Flutter: Any version with flutter_localizations
- Platforms: All (iOS, Android, Web, Desktop)

## Contributors

Thank you to all contributors who helped with this release!

## Links

- **Pub.dev**: https://pub.dev/packages/localization_gen
- **GitHub**: https://github.com/alpinnz/localization_gen
- **Documentation**: https://github.com/alpinnz/localization_gen#readme
- **Issues**: https://github.com/alpinnz/localization_gen/issues
- **Examples**: https://github.com/alpinnz/localization_gen/tree/master/example

## Next Steps

After upgrading:

1. Review the field_rename option
2. Update your pubspec.yaml if desired
3. Regenerate localization code
4. Test your application
5. Check documentation for new features

## Feedback

Found a bug or have a suggestion? Please open an issue:
https://github.com/alpinnz/localization_gen/issues

## Thank You

Thank you for using localization_gen! We hope this release improves your development experience.

