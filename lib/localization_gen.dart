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
/// - Pluralization support
/// - Gender-based translations
/// - Context-based translations
/// - Multiple locale support
/// - Multi-command CLI
/// - Coverage reporting
library;

export 'src/generator/localization_generator.dart';
export 'src/model/localization_item.dart';
export 'src/model/field_rename.dart';
export 'src/config/config_reader.dart';
export 'src/parser/json_parser.dart';
export 'src/writer/dart_writer.dart';
export 'src/command/command_router.dart';
export 'src/command/base_command.dart';
export 'src/exceptions/exceptions.dart';
