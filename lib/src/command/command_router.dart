import 'dart:io';
import 'base_command.dart';
import 'generate_command.dart';
import 'init_command.dart';
import 'validate_command.dart';
import 'clean_command.dart';
import 'coverage_command.dart';

/// Main command router that handles all CLI commands
class CommandRouter {
  final Map<String, BaseCommand> _commands = {
    'generate': GenerateCommand(),
    'init': InitCommand(),
    'validate': ValidateCommand(),
    'clean': CleanCommand(),
    'coverage': CoverageCommand(),
  };

  /// Execute a command based on arguments
  Future<int> run(List<String> args) async {
    // If no args or help flag, show general help
    if (args.isEmpty || args.first == '--help' || args.first == '-h') {
      _printHelp();
      return 0;
    }

    // Check for version flag
    if (args.first == '--version' || args.first == '-v') {
      print('localization_gen version 1.0.7');
      return 0;
    }

    final commandName = args.first;

    // Check if command is 'generate' or if it's a flag (backward compatibility)
    if (commandName.startsWith('-')) {
      // No command specified, default to generate
      return await _executeCommand('generate', args);
    }

    // Execute the specified command
    if (_commands.containsKey(commandName)) {
      final commandArgs = args.sublist(1);
      return await _executeCommand(commandName, commandArgs);
    } else {
      stderr.writeln('Unknown command: $commandName');
      stderr.writeln(
          'Run "dart run localization_gen --help" for usage information.');
      return 1;
    }
  }

  Future<int> _executeCommand(String name, List<String> args) async {
    final command = _commands[name];
    if (command == null) {
      stderr.writeln('Command not found: $name');
      return 1;
    }

    try {
      return await command.execute(args);
    } catch (e) {
      stderr.writeln('Error executing command: $e');
      return 1;
    }
  }

  /// Prints general help information for all commands.
  ///
  /// Displays available commands, global options, and usage examples.
  void _printHelp() {
    print('localization_gen - Type-safe localization generator for Flutter\n');
    print('Usage: dart run localization_gen <command> [options]\n');
    print('Available commands:');

    final maxNameLength =
        _commands.keys.map((k) => k.length).reduce((a, b) => a > b ? a : b);

    for (final entry in _commands.entries) {
      final name = entry.key.padRight(maxNameLength + 2);
      final description = entry.value.description;
      print('  $name $description');
    }

    print('\nGlobal options:');
    print('  -h, --help       Show help information');
    print('  -v, --version    Show version information');

    print('\nExamples:');
    print('  dart run localization_gen init');
    print('  dart run localization_gen generate');
    print('  dart run localization_gen generate --watch');
    print('  dart run localization_gen validate');
    print('  dart run localization_gen coverage --format=html');
    print('  dart run localization_gen clean');

    print('\nFor command-specific help, run:');
    print('  dart run localization_gen <command> --help');

    print('\nBackward compatibility:');
    print(
        '  dart run localization_gen [options]    # Same as "generate" command');
  }
}
