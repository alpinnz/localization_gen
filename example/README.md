# Examples

Working examples demonstrating localization_gen usage.

Repository: https://github.com/alpinnz/localization_gen/tree/master/example

## Available Examples

### 1. Basic Example

Simple single-file localization.

**Location**: [example/basic/](https://github.com/alpinnz/localization_gen/tree/master/example/basic)

**Features**:
- Single JSON file per locale
- Nested structure
- Parameter interpolation
- Multiple locales (English, Indonesian)

**Run**:
```bash
cd example/basic
flutter pub get
dart run localization_gen
flutter run
```

### 2. Modular Example

Feature-based organization.

**Location**: [example/modular/](https://github.com/alpinnz/localization_gen/tree/master/example/modular)

**Features**:
- Multiple JSON files per locale
- Feature-based organization
- Automatic file merging
- Scalable structure

**Run**:
```bash
cd example/modular
flutter pub get
dart run localization_gen
flutter run
```

## Quick Setup

```bash
# Navigate to example
cd example/<example-name>

# Install dependencies
flutter pub get

# Generate localizations
dart run localization_gen

# Run app
flutter run
```

## Learning Path

1. Start with `basic/` for core concepts
2. Explore `modular/` for organization at scale

## Configuration

Each example has its own `pubspec.yaml` with localization_gen configuration.

See example files for different setup options.

