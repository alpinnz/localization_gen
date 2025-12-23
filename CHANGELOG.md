# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-12-22

### Added
- **Field Rename Feature**: Support for multiple naming conventions
  - New `FieldRename` enum with 6 naming options
  - `field_rename` configuration option in pubspec.yaml
  - Options: `none`, `kebab`, `snake`, `pascal`, `camel`, `screamingSnake`
  - Converts JSON keys to desired Dart naming convention
  - Supports consistent code style across projects
  - Fully tested with 18 comprehensive tests

- **Makefile for Development**: Convenient commands for common tasks
  - `make help` - Show all available commands
  - `make install` - Install dependencies
  - `make test` - Run all tests
  - `make check` - Run all checks (analyze + format + test)
  - `make coverage` - Generate test coverage report
  - `make publish-dry` - Test publication
  - And more (see `make help` for complete list)

- **Enhanced Documentation**:
  - Consolidated all markdown files (23 → 7 files, 70% reduction)
  - Added full GitHub repository URLs for easy navigation
  - Removed all emoticons for professional appearance
  - Consistent formatting across all documentation
  - Clear structure: README, CONTRIBUTING, CHANGELOG, examples, tests
  - Professional tone suitable for library package

- **Test Suite Expansion**:
  - Added `test/model/field_rename_test.dart` (18 tests)
  - Total test coverage: 82+ comprehensive tests
  - Test structure mirrors lib/src for easy validation
  - All tests organized by component
  - Updated test/all_test.dart runner

- **Repository Navigation**:
  - All documentation includes full GitHub URLs
  - Easy access to examples, issues, and documentation
  - Improved discoverability for contributors
  - Better pub.dev integration

### Changed
- **Version**: Major feature addition (1.0.7 → 1.1.0)
- **Documentation Structure**: Streamlined from 23 to 7 essential markdown files
  - Root: README.md, CONTRIBUTING.md, CHANGELOG.md
  - Examples: 3 README files (overview, basic, modular)
  - Tests: 1 README file
- **Test Organization**: Restructured tests to mirror source structure
- **Configuration**: Added `field_rename` option to `LocalizationConfig`
- **Package Description**: Updated to include field rename feature

### Fixed
- Test file corruption issues resolved
- Documentation consistency improved
- Example structure clarified
- All markdown files formatted professionally

### Migration from 1.0.x

No breaking changes. New `field_rename` option is optional with default value `none`.

To use the new feature, add to your `pubspec.yaml`:

```yaml
localization_gen:
  field_rename: snake  # Choose: none, kebab, snake, pascal, camel, screamingSnake
```

### Notes

This release focuses on:
- Adding flexible naming convention support
- Improving documentation quality and navigation
- Expanding test coverage
- Maintaining backward compatibility

## [1.0.6] - 2025-12-16

### Added
- **Watch Mode**: Auto-regenerate localization files when JSON files change
  - `--watch` flag for continuous development
  - `--debounce` option to customize regeneration delay (default: 300ms)
  - Monitors only `.json` files for changes
  - Clear console output showing file changes and regeneration status
  - Graceful shutdown with Ctrl+C

- **Strict Validation**: Ensure locale consistency across all translation files
  - `strict_validation: true` in config to enable
  - Validates all locales have identical translation keys
  - Verifies parameters match across locales (order-independent)
  - Detailed error messages with missing/extra keys listed

- **Enhanced Error Handling**: Custom exception classes with detailed information
  - `LocalizationException` base class for all errors
  - `JsonParseException` for JSON parsing errors with file paths
  - `LocaleValidationException` for locale consistency errors
  - `ParameterException` for parameter mismatch errors
  - `FileOperationException` for file I/O errors
  - `ConfigException` for configuration errors
  - All exceptions include file paths, line numbers, and helpful context

- **Comprehensive Test Suite**: 30+ new tests added
  - Error handling tests for all exception types
  - Watch mode functionality tests
  - Locale validation tests
  - Parameter validation tests
  - Integration tests for end-to-end workflows

### Changed
- **CLI Interface**: Made main function async to support watch mode
- **JSON Parser**: Added detailed error messages for malformed JSON
- **Code Generation**: Improved error reporting during generation
- **Configuration**: Added `strict_validation` option to LocalizationConfig

### Improved
- **Documentation**: Comprehensive README updates
  - Watch mode usage and examples
  - Error handling guide with common errors and fixes
  - CLI options reference
  - Best practices section
  - Troubleshooting guide
  
- **Developer Experience**:
  - Clear, actionable error messages
  - Warnings for unsupported value types
  - Better progress output during generation
  - Detailed validation feedback

### Dependencies
- Added `watcher: ^1.1.0` for file watching functionality

### Breaking Changes
None - fully backward compatible with v1.0.5

### Migration from 1.0.5
No migration needed - all existing code works without changes.

To use new features:
1. Enable watch mode: `dart run localization_gen --watch`
2. Enable strict validation: Add `strict_validation: true` to config

## [1.0.5] - 2025-12-15

### Added
- **Complete API Documentation**: Added comprehensive dartdoc comments to all 43 public API elements (100% coverage)
  - ConfigReader class and methods with detailed examples
  - DartWriter class with all properties and methods documented
  - LocalizationItem, LocalizationConfig, and LocaleData with full property documentation
  - LocalizationGenerator with step-by-step generation process documentation
  - JsonLocalizationParser with nested JSON examples and usage patterns
  
- **Example Directory**: Added standalone examples following dart.dev package layout conventions
  - `example/basic_usage.dart` - Simple usage demonstration
  - `example/custom_config.dart` - Custom configuration example
  - `example/programmatic_usage.dart` - Advanced component usage
  - `example/README.md` - Comprehensive quick start guide
  - All examples are runnable with `dart run example/FILENAME.dart`

### Changed
- **Example Structure**: Reorganized example directory to follow official Dart package layout guidelines
  - Simple standalone examples now at root level of example/
  - Complex Flutter applications remain in subdirectories (default/, modular/, monorepo/)
  - Improved discoverability and learning path for users

### Fixed
- **Code Formatting**: Fixed all Dart formatting issues across the entire codebase
  - All source files properly formatted with `dart format`
  - Zero linting errors, warnings, or formatting issues
  - Achieves perfect static analysis score (50/50 points)

### Documentation
- Added detailed dartdoc comments with code examples and parameter descriptions
- Every public API element now has clear, comprehensive documentation
- Examples demonstrate both simple and advanced usage patterns
- Documentation follows Dart best practices and conventions

### Quality Improvements
- **Pub.dev Score**: Achieved perfect 160/160 points
  - Documentation: 20/20 points (100% API coverage + examples)
  - Static Analysis: 50/50 points (no errors, warnings, lints, or formatting issues)
  - Platform Support: 20/20 points
  - Dependencies: 40/40 points
  - Valid pubspec: 30/30 points

### Migration from 1.0.4
- No breaking changes
- All existing code continues to work without modifications
- This is a documentation and quality improvement release

## [1.0.4] - 2025-12-15

### Changed
- **IMPORTANT**: Updated method parameter generation from positional to named parameters with `required` keyword
  - Old: `welcome_user(String name)`
  - New: `welcome_user({required String name})`
  - **Migration recommended**: All method calls with parameters should be updated to use named parameters
  - See [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md) for detailed migration guide
  - See [UPDATE_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/UPDATE_V1.0.4.md) for complete update documentation
  
### Why This Change?
- Better API clarity and self-documenting code
- Prevention of parameter order mistakes
- Improved IDE autocomplete support
- Future-proof for adding optional parameters

### Impact
- Applications using methods with parameters will need to update their method calls
- Compiler will catch all locations that need updating with clear error messages
- This change improves code quality and maintainability

### Documentation
- Added comprehensive update guide (UPDATE_V1.0.4.md)
- Updated all examples to use named parameters
- Updated README and QUICKSTART with new syntax
- Updated migration guide with detailed step-by-step instructions

## [1.0.3] - 2024-12-14

### Fixed
- Updated GitHub repository branch references from 'main' to 'master' in documentation
  - Fixed links in README.md, EXAMPLES.md, and QUICKSTART.md
  - Updated example README files (default, modular, monorepo)
  - Ensures all documentation links point to correct repository branch

### Documentation
- Corrected branch references across all documentation files for accurate navigation

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

### 1.0.4
Named parameters with required keyword for better API design and code clarity.

### 1.0.3
Documentation fixes for branch references.

### 1.0.2
Metadata cleanup for pub.dev compliance.

### 1.0.1
Modular organization support and enhanced examples.

### 1.0.0
First stable release ready for production use. Includes comprehensive examples, documentation, and testing.

---

## Upgrade Guide

### From 1.0.3 to 1.0.4

1. Update your `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     localization_gen: ^1.0.4
   ```

2. Regenerate your localization files:
   ```bash
   dart run localization_gen:localization_gen
   ```

3. Update all method calls with parameters from positional to named:
   ```dart
   // Before
   appLocalizations.welcome('John')
   
   // After
   appLocalizations.welcome(name: 'John')
   ```

4. Test your application - the compiler will catch any missed conversions

For detailed migration guide, see [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md).

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

