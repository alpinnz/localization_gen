# Localization Gen Examples

Working examples demonstrating different usage patterns of `localization_gen`.

**Repository**: https://github.com/alpinnz/localization_gen/tree/master/example

## Available Examples

### 1. Basic Example

**Path**: `example/basic/`

Simple single-file per locale approach, ideal for small to medium applications.

**Key Features**:
- One JSON file per locale
- Nested structure for organization
- Parameter interpolation
- Deep nesting support (up to 10 levels)
- English and Indonesian locales

**Best for**: Small to medium apps, simple localization needs

**Run**:
```bash
cd example/basic
flutter pub get
dart run localization_gen
flutter run
```

### 2. Modular Example

**Path**: `example/modular/`

Feature-based organization with multiple files per locale, ideal for large applications.

**Key Features**:
- Multiple JSON files per locale
- Feature/module-based organization
- Automatic file merging by locale
- Scalable structure for large teams
- English and Indonesian locales

**Best for**: Large apps, team projects, feature-based development

**Run**:
```bash
cd example/modular

## General Setup Steps

```bash
# 1. Navigate to example directory
cd example/basic   # or example/modular

# 2. Install dependencies
flutter pub get

# 3. Generate localization code
dart run localization_gen

# 4. Run the app
flutter run
```

## Recommended Learning Path

1. **Start with `basic/`** - Learn core concepts and basic usage
2. **Move to `modular/`** - Understand how to scale for large projects

## Documentation

- Each example has its own detailed README
- Main documentation: [../../README.md](../../README.md)
- Configuration options in each `pubspec.yaml`
