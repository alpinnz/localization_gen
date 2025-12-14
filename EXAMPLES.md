# Examples Guide

This directory contains three complete example applications demonstrating different approaches to using localization_gen.

## Available Examples

### 1. Default Example

**Location:** `examples/default/`

**Description:** Traditional nested JSON approach with single file per locale.

**Best For:**
- Small to medium applications
- Teams preferring simple structure
- Projects with clear feature boundaries
- Standard Flutter applications

**Key Features:**
- Single JSON file per locale
- Nested structure (e.g., `auth.login.title`)
- 12 comprehensive tests
- Simple configuration

**Languages:** English, Indonesian

[View Default Example README](default/README.md)

---

### 2. Modular Example

**Location:** `examples/modular/`

**Description:** Modular organization with separate JSON files per feature module.

**Best For:**
- Large applications with many features
- Multi-team development
- Projects requiring clear module boundaries
- Scalable architectures

**Key Features:**
- Multiple JSON files (one per module)
- Flat structure per module
- 19 comprehensive tests
- Better team collaboration

**Modules:**
- Auth (login, registration)
- Home (welcome, greetings)
- Common (shared buttons)
- Settings (preferences)

**Languages:** English, Indonesian

[View Modular Example README](modular/README.md)

---

### 3. Monorepo Example

**Location:** `examples/monorepo/`

**Description:** Multi-package architecture with independent localization per package.

**Best For:**
- Enterprise applications
- Multiple apps sharing code
- White-label applications
- Shared component libraries

**Key Features:**
- Multiple packages (App + Core)
- Independent localization per package
- 28 comprehensive tests (22 App + 6 Core)
- Enterprise-ready structure

**Packages:**
- **App Package:** Main application with app-specific features
- **Core Package:** Shared library with common components

**Languages:** English, Indonesian

[View Monorepo Example README](monorepo/README.md)

---

## Comparison Matrix

| Feature | Default | Modular | Monorepo |
|---------|---------|---------|----------|
| **Files per Locale** | 1 | Multiple | Multiple per package |
| **Structure** | Nested | Flat per module | Flat per module |
| **Packages** | 1 | 1 | Multiple (2+) |
| **Tests** | 12 | 19 | 28 total |
| **Complexity** | Low | Medium | High |
| **Scalability** | Medium | High | Very High |
| **Team Size** | Small | Medium-Large | Large |
| **Best For** | Standard apps | Feature-rich apps | Enterprise |

---

## Running Examples

### Quick Start

```bash
# Navigate to any example
cd examples/default  # or modular, or monorepo/app

# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

### Generate Localizations

```bash
# For Default and Modular examples
dart run localization_gen:localization_gen

# For Monorepo (run in each package)
cd examples/monorepo/core
dart run localization_gen:localization_gen

cd examples/monorepo/app
dart run localization_gen:localization_gen
```

---

## Common Features

All examples include:

- **Language Switching:** Toggle between English and Indonesian
- **Type-Safe Access:** Compile-time checking of translations
- **Parameter Interpolation:** Dynamic values in translations
- **Comprehensive Tests:** Full test coverage
- **Clean Architecture:** Well-organized code structure
- **Production Ready:** Can be used as templates

---

## Testing

Run all example tests at once:

```bash
# From repository root
./run_all_tests.sh
```

This will run tests for:
- Default Example (12 tests)
- Modular Example (19 tests)
- Monorepo App (22 tests)
- Monorepo Core (6 tests)

Total: 59 tests

---

## Configuration Examples

### Default (Nested)

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  use_context: true
  nullable: false
```

### Modular

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  use_context: true
  nullable: false
  modular: true
  file_prefix: app
```

### Monorepo (per package)

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations  # or CoreLocalizations
  modular: true
  file_prefix: app  # or core
```

---

## Choosing the Right Example

**Start with Default if:**
- You're building a small to medium app
- You prefer simplicity
- Your team is small
- You want to get started quickly

**Use Modular if:**
- Your app has many features
- Multiple teams work on different features
- You need clear separation between modules
- You're planning for growth

**Use Monorepo if:**
- You're building multiple apps
- You need a shared component library
- You have a large organization
- You need independent package versioning

---

## Learn More

- [Main README](../README.md) - Library documentation
- [QUICKSTART](../QUICKSTART.md) - Quick setup guide
- [CHANGELOG](../CHANGELOG.md) - Version history
- Individual example READMEs for detailed information

---

## Support

For questions or issues:
- Check example READMEs
- Review main documentation
- Look at test files for usage patterns
- Examine generated code for implementation details

All examples are fully functional and tested. Feel free to use them as starting points for your own projects.

