# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2024-12-14

### Fixed
- Removed deprecated 'authors' field from pubspec.yaml to comply with pub.dev publishing requirements
- Package now passes `dart pub publish` validation without warnings

### Maintenance
- Cleaned up package metadata for pub.dev compatibility

## [1.0.1] - 2024-12-14

### Added
- Support for modular localization files with flexible naming patterns
  - Optional per-module organization: `app_{module}_en.json`, `core_{feature}_en.json`
  - Maintains backward compatibility with standard `app_en.json` pattern
- Enhanced examples structure with three distinct use cases
  - Renamed `example` to `examples` directory
  - Added comprehensive unit tests for all example projects
  - Updated examples with multi-language support (English, Spanish, Indonesian)

### Changed
- Improved key naming convention: all generated keys now use `snake_case` format
- Removed emoji icons from all documentation files for cleaner presentation
- Enhanced documentation with per-module localization examples
- Refactored example projects:
  - `1_default`: Basic single-module setup
  - `2_modular`: Feature-based modular organization
  - `3_monorepo`: Multi-package monorepo architecture with app and core packages
- Updated all GitHub links to use `alpinnz` username
- Fixed broken documentation links for pub.dev compatibility

### Fixed
- Corrected parameter interpolation output format: `discount(value: "20")` for `{"discount": "Diskon {value}%"}`
- Fixed hyperlinks in documentation that were not compatible with pub.dev rendering
- Improved example test coverage and reliability

### Documentation
- All markdown files updated without emoji icons for professional appearance
- Enhanced modular localization pattern documentation
- Added clear examples for optional per-module file organization
- Updated READMEs for each example project with specific use case documentation

## [1.0.0] - 2024-12-14

### Added
- Initial stable release
- Type-safe localization generation from JSON files
- Support for nested JSON structure
- Support for modular organization with multiple JSON files per module
- Parameter interpolation with named placeholders
- Customizable configuration via pubspec.yaml
- Context-aware localization access
- Multiple example applications:
  - Default example with nested JSON
  - Modular example with feature-based organization
  - Monorepo example with multi-package architecture
- Comprehensive test coverage (59 tests across all examples)
- Detailed documentation and guides
- CLI tool for code generation
- Support for multiple locales
- Type-safe delegate generation for Flutter

### Features
- **Nested JSON Support**: Organize translations hierarchically
- **Modular Files**: Split translations by feature module
- **Parameter Interpolation**: Dynamic values in translations
- **Type Safety**: Compile-time checking of translation keys
- **Customizable**: Flexible configuration options
- **Production Ready**: Battle-tested with comprehensive examples

### Documentation
- Complete README with usage guide
- QUICKSTART guide for rapid setup
- EXAMPLES guide comparing different approaches
- Individual READMEs for each example
- API documentation
- Migration guides

### Testing
- Unit tests for core functionality
- Widget tests for all examples
- Integration tests for monorepo setup
- Test runner script for CI/CD
- 100% test pass rate

## [0.1.0] - Development

### Added
- Initial development version
- Basic JSON parsing
- Code generation prototype
- Experimental features

---

## Version History

### 1.0.0
First stable release ready for production use. Includes comprehensive examples, documentation, and testing.

---

## Upgrade Guide

### From 0.x to 1.0.0

1. Update your `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     localization_gen: ^1.0.0
   ```

2. Review your configuration (minimal changes needed)

3. Regenerate your localization files:
   ```bash
   dart run localization_gen:localization_gen
   ```

4. Update imports if needed (class names remain the same)

---

## Future Roadmap

Planned for future releases:
- Additional language support features
- Performance optimizations
- More configuration options
- Additional examples
- Enhanced error messages
- IDE plugins

---

For detailed information about each version, see the [Releases](https://github.com/alpinnz/localization_gen/releases) page.

