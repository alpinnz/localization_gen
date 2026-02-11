/// Shared constants for localization_gen.
///
/// This file acts as a single source of truth for values that should not be
/// exposed as user configuration.
library;

/// Default debounce delay (milliseconds) for watch mode.
///
/// Used to avoid multiple rapid regenerations when multiple file system events
/// fire in quick succession.
const int kWatchDebounceMs = 300;

/// Default input directory for localization files.
const String kDefaultInputDir = 'assets/localizations';

/// Default output directory for generated Dart files.
const String kDefaultOutputDir = 'lib/assets';

/// Default generated localization class name.
const String kDefaultClassName = 'AppLocalizations';

/// Default file prefix for modular localization files.
const String kDefaultFilePrefix = 'app';

/// Default file pattern for modular localization files.
const String kDefaultFilePattern = 'app_{module}_{locale}.json';

/// Output suffix for generated Dart files.
///
/// Kept constant to ensure stable imports across projects.
const String kDefaultOutputFileSuffix = '.gen.dart';

/// Default field rename mode for generated Dart identifiers.
///
/// This package uses camelCase by default.
const String kDefaultFieldRename = 'camel';
