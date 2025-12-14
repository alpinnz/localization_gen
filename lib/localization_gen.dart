/// Strongly-typed localization generator for Flutter with nested JSON support
///
/// Generate type-safe, nested localization code from JSON files.
///
/// Usage:
/// ```dart
/// LocalizationGenerator().generate();
/// ```
///
/// Features:
/// - Nested JSON structure support
/// - Type-safe code generation
/// - Parameter interpolation
/// - Multiple locale support
library;

export 'src/generator/localization_generator.dart';
export 'src/model/localization_item.dart';
export 'src/config/config_reader.dart';
export 'src/parser/json_parser.dart';
export 'src/writer/dart_writer.dart';
