import 'dart:io';

/// Base class for all CLI commands.
///
/// This abstract class provides the foundation for implementing CLI commands
/// in the localization generator. Each command must implement [name], [description],
/// and [execute] methods.
///
/// Example usage:
/// ```dart
/// class Command extends BaseCommand {
///   @override
///   String get name => 'command';
///
///   @override
///   String get description => 'My custom command';
///
///   @override
///   Future<int> execute(List<String> args) async {
///     // Command implementation
///     return 0;
///   }
/// }
/// ```
abstract class BaseCommand {
  /// The name of the command as used in the CLI.
  ///
  /// This name is used when invoking the command from the command line.
  /// For example, if [name] returns 'generate', the command would be invoked
  /// as `dart run localization_gen generate`.
  String get name;

  /// A brief description of what the command does.
  ///
  /// This description is displayed in help text and command listings.
  String get description;

  /// Example usage string for the command.
  ///
  /// By default, returns a formatted string showing how to invoke the command.
  /// Can be overridden to provide more specific usage examples.
  String get usage => 'dart run localization_gen $name [options]';

  /// Executes the command with the given arguments.
  ///
  /// This method must be implemented by all subclasses to define the command's
  /// behavior. The [args] parameter contains the command-line arguments passed
  /// to the command (excluding the command name itself).
  ///
  /// Returns an integer exit code where 0 indicates success and non-zero
  /// indicates an error.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Future<int> execute(List<String> args) async {
  ///   try {
  ///     // Command logic here
  ///     return 0;
  ///   } catch (e) {
  ///     exitWithError(e.toString());
  ///     return 1;
  ///   }
  /// }
  /// ```
  Future<int> execute(List<String> args);

  /// Prints an error message to stderr and exits the process.
  ///
  /// The [message] parameter contains the error description to display.
  /// The [code] parameter specifies the exit code (default is 1).
  ///
  /// This method terminates the program execution with the specified exit code.
  ///
  /// Example:
  /// ```dart
  /// if (file == null) {
  ///   exitWithError('File not found', code: 2);
  /// }
  /// ```
  void exitWithError(String message, {int code = 1}) {
    stderr.writeln('Error: $message');
    exit(code);
  }

  /// Prints a success message to stdout.
  ///
  /// The [message] parameter contains the success message to display.
  /// Success messages are prefixed with a checkmark indicator.
  ///
  /// Example:
  /// ```dart
  /// printSuccess('Files generated successfully');
  /// ```
  void printSuccess(String message) {
    stdout.writeln('[SUCCESS] $message');
  }

  /// Prints an informational message to stdout.
  ///
  /// The [message] parameter contains the information to display.
  /// Info messages are prefixed with an info indicator.
  ///
  /// Example:
  /// ```dart
  /// printInfo('Processing 5 files...');
  /// ```
  void printInfo(String message) {
    stdout.writeln('[INFO] $message');
  }

  /// Prints a warning message to stdout.
  ///
  /// The [message] parameter contains the warning to display.
  /// Warning messages are prefixed with a warning indicator.
  ///
  /// Example:
  /// ```dart
  /// printWarning('Deprecated configuration option detected');
  /// ```
  void printWarning(String message) {
    stdout.writeln('[WARNING] $message');
  }
}
