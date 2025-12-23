#!/usr/bin/env dart

library;

/// Localization Generator CLI entry point.
///
/// This is the main executable for the localization_gen package.
/// It routes command-line arguments to the appropriate command handler.
///
/// Usage:
/// ```bash
/// dart run localization_gen <command> [options]
/// ```
///
/// Available commands:
/// - `generate`: Generate localization code from JSON files
/// - `init`: Initialize localization setup
/// - `validate`: Validate localization files
/// - `clean`: Remove generated files
/// - `coverage`: Generate coverage report
///
/// For more information, run:
/// ```bash
/// dart run localization_gen --help
/// ```

import 'dart:io';
import 'package:localization_gen/src/command/command_router.dart';

/// Main entry point for the localization generator CLI.
///
/// The [args] parameter contains command-line arguments passed to the
/// program.
///
/// Returns an exit code where 0 indicates success and non-zero indicates an
/// error.
Future<void> main(List<String> args) async {
  final router = CommandRouter();
  final exitCode = await router.run(args);
  exit(exitCode);
}
