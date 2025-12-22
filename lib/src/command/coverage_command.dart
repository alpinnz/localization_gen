import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'base_command.dart';
import '../config/config_reader.dart';
import '../parser/json_parser.dart';

/// Command to generate translation coverage report.
///
/// This command analyzes localization files and generates a coverage report
/// showing which translations are complete across all locales. Supports
/// multiple output formats including text, JSON, and HTML.
///
/// Usage:
/// ```bash
/// dart run localization_gen coverage
/// dart run localization_gen coverage --format=json
/// dart run localization_gen coverage --format=html --output=coverage.html
/// ```
class CoverageCommand extends BaseCommand {
  @override
  String get name => 'coverage';

  @override
  String get description => 'Generate translation coverage report';

  /// Executes the coverage command with the provided arguments.
  ///
  /// Analyzes all localization files and generates a coverage report.
  ///
  /// Supports the following options:
  /// - `--config` or `-c`: Path to pubspec.yaml
  /// - `--format` or `-f`: Output format (text, json, html)
  /// - `--output` or `-o`: Output file (stdout if not specified)
  /// - `--help` or `-h`: Show help information
  ///
  /// Returns 0 on success, 1 on error.
  @override
  Future<int> execute(List<String> args) async {
    final parser = ArgParser()
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to pubspec.yaml',
        defaultsTo: 'pubspec.yaml',
      )
      ..addOption(
        'format',
        abbr: 'f',
        help: 'Output format (text, json, html)',
        defaultsTo: 'text',
        allowed: ['text', 'json', 'html'],
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output file (stdout if not specified)',
      )
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Show help information',
        negatable: false,
      );

    try {
      final results = parser.parse(args);

      if (results['help'] as bool) {
        _printHelp(parser);
        return 0;
      }

      final configPath = results['config'] as String;
      final format = results['format'] as String;
      final outputPath = results['output'] as String?;

      printInfo('Generating coverage report...\n');

      final config = ConfigReader.read(configPath);

      // Parse all locales
      final locales = JsonLocalizationParser.parseDirectory(
        config.inputDir,
        modular: config.modular,
        filePrefix: config.filePrefix,
      );

      if (locales.isEmpty) {
        printWarning('No locales found');
        return 1;
      }

      // Generate coverage data
      final coverageData = _generateCoverageData(locales);

      // Format output
      final output = _formatOutput(coverageData, format);

      // Write output
      if (outputPath != null) {
        final file = File(outputPath);
        file.writeAsStringSync(output);
        printSuccess('Coverage report saved to: $outputPath');
      } else {
        print(output);
      }

      return 0;
    } catch (e) {
      exitWithError(e.toString());
      return 1;
    }
  }

  Map<String, dynamic> _generateCoverageData(List<dynamic> locales) {
    if (locales.isEmpty) {
      return {'locales': [], 'totalKeys': 0, 'coverage': {}};
    }

    // Use first locale as base
    final baseLocale = locales.first;
    final baseKeys = (baseLocale as dynamic).items.keys.toSet();
    final totalKeys = baseKeys.length;

    final coverage = <String, Map<String, dynamic>>{};

    for (final locale in locales) {
      final localeCode = (locale as dynamic).locale as String;
      final localeKeys = (locale as dynamic).items.keys.toSet();

      final missingKeys = baseKeys.difference(localeKeys);
      final extraKeys = localeKeys.difference(baseKeys);
      final coveragePercent =
          (localeKeys.length / totalKeys * 100).toStringAsFixed(2);

      coverage[localeCode] = {
        'total': totalKeys,
        'translated': localeKeys.length,
        'missing': missingKeys.length,
        'extra': extraKeys.length,
        'percentage': coveragePercent,
        'missingKeys': missingKeys.toList(),
        'extraKeys': extraKeys.toList(),
      };
    }

    return {
      'locales': locales.map((l) => (l as dynamic).locale).toList(),
      'totalKeys': totalKeys,
      'coverage': coverage,
    };
  }

  /// Formats coverage data according to the specified format.
  ///
  /// The [data] parameter contains the coverage data.
  /// The [format] parameter specifies the output format (text, json, html).
  ///
  /// Returns a formatted string ready for output.
  String _formatOutput(Map<String, dynamic> data, String format) {
    switch (format) {
      case 'json':
        return _formatJson(data);
      case 'html':
        return _formatHtml(data);
      case 'text':
      default:
        return _formatText(data);
    }
  }

  /// Formats coverage data as plain text.
  ///
  /// The [data] parameter contains the coverage data.
  ///
  /// Returns a human-readable text report.
  String _formatText(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    final totalKeys = data['totalKeys'] as int;
    final coverage = data['coverage'] as Map<String, dynamic>;

    buffer.writeln('Translation Coverage Report');
    buffer.writeln('=' * 60);
    buffer.writeln('Total translation keys: $totalKeys\n');

    for (final entry in coverage.entries) {
      final locale = entry.key;
      final info = entry.value as Map<String, dynamic>;

      buffer.writeln('Locale: $locale');
      buffer.writeln(
          '  Translated: ${info['translated']}/$totalKeys (${info['percentage']}%)');

      if (info['missing'] > 0) {
        buffer.writeln('  Missing: ${info['missing']} key(s)');
        final missingKeys = info['missingKeys'] as List;
        if (missingKeys.isNotEmpty) {
          for (final key in missingKeys.take(5)) {
            buffer.writeln('    - $key');
          }
          if (missingKeys.length > 5) {
            buffer.writeln('    ... and ${missingKeys.length - 5} more');
          }
        }
      }

      if (info['extra'] > 0) {
        buffer.writeln('  Extra: ${info['extra']} key(s)');
      }

      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Formats coverage data as JSON.
  ///
  /// The [data] parameter contains the coverage data.
  ///
  /// Returns a formatted JSON string with indentation.
  String _formatJson(Map<String, dynamic> data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// Formats coverage data as HTML.
  ///
  /// The [data] parameter contains the coverage data.
  ///
  /// Returns a complete HTML document with styled coverage table and
  /// progress bars for visualization.
  String _formatHtml(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    final totalKeys = data['totalKeys'] as int;
    final coverage = data['coverage'] as Map<String, dynamic>;

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html>');
    buffer.writeln('<head>');
    buffer.writeln('  <title>Translation Coverage Report</title>');
    buffer.writeln('  <style>');
    buffer
        .writeln('    body { font-family: Arial, sans-serif; margin: 20px; }');
    buffer.writeln('    h1 { color: #333; }');
    buffer.writeln(
        '    table { border-collapse: collapse; width: 100%; margin-top: 20px; }');
    buffer.writeln(
        '    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }');
    buffer.writeln('    th { background-color: #4CAF50; color: white; }');
    buffer.writeln('    tr:nth-child(even) { background-color: #f2f2f2; }');
    buffer.writeln(
        '    .progress-bar { background-color: #ddd; border-radius: 10px; overflow: hidden; }');
    buffer.writeln(
        '    .progress-fill { height: 20px; background-color: #4CAF50; text-align: center; color: white; line-height: 20px; }');
    buffer.writeln('  </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('  <h1>Translation Coverage Report</h1>');
    buffer.writeln(
        '  <p>Total translation keys: <strong>$totalKeys</strong></p>');
    buffer.writeln('  <table>');
    buffer.writeln('    <tr>');
    buffer.writeln('      <th>Locale</th>');
    buffer.writeln('      <th>Translated</th>');
    buffer.writeln('      <th>Missing</th>');
    buffer.writeln('      <th>Coverage</th>');
    buffer.writeln('    </tr>');

    for (final entry in coverage.entries) {
      final locale = entry.key;
      final info = entry.value as Map<String, dynamic>;

      buffer.writeln('    <tr>');
      buffer.writeln('      <td><strong>$locale</strong></td>');
      buffer.writeln('      <td>${info['translated']}/$totalKeys</td>');
      buffer.writeln('      <td>${info['missing']}</td>');
      buffer.writeln('      <td>');
      buffer.writeln('        <div class="progress-bar">');
      buffer.writeln(
          '          <div class="progress-fill" style="width: ${info['percentage']}%">${info['percentage']}%</div>');
      buffer.writeln('        </div>');
      buffer.writeln('      </td>');
      buffer.writeln('    </tr>');
    }

    buffer.writeln('  </table>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Prints help information for the coverage command.
  ///
  /// The [parser] parameter provides the argument parser configuration.
  ///
  /// Displays usage, options, and examples for generating coverage reports.
  void _printHelp(ArgParser parser) {
    print('Generate translation coverage report\n');
    print('Usage: $usage\n');
    print('Options:');
    print(parser.usage);
    print('\nExamples:');
    print('  dart run localization_gen coverage');
    print('  dart run localization_gen coverage --format=json');
    print(
        '  dart run localization_gen coverage --format=html --output=coverage.html');
  }
}
