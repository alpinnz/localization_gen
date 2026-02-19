/// Validates that `example/assets/localizations` JSON inputs are faithfully
/// represented in the generated translation tables.
///
/// This protects against escaping bugs (\n, \\, \$, quotes) that could cause
/// runtime values to differ from the localized JSON.
library;

import 'dart:convert';
import 'dart:io';

import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('example/assets/localizations parity with generated translation tables',
      () {
    // Resolve paths relative to the repo root.
    final repoRoot = _repoRootFrom(Directory.current.path);
    final inputDir = Directory(p.join(repoRoot, 'example', 'assets', 'localizations'));

    expect(inputDir.existsSync(), isTrue,
        reason: 'Missing example localizations dir: ${inputDir.path}');

    final locales =
        JsonLocalizationParser.parseDirectory(inputDir.path, filePrefix: 'app');
    expect(locales, isNotEmpty);

    final code = DartWriter(className: 'AppLocalizations').generate(locales);

    // Extract generated _t_xx tables.
    final generated = _extractAllGeneratedTranslationTables(code);

    // Compare runtime values for every key/locale.
    for (final locale in locales) {
      final table = generated[locale.locale];
      expect(table, isNotNull, reason: 'Missing generated table for ${locale.locale}');

      for (final entry in locale.items.entries) {
        final key = entry.key;
        final expected = entry.value.value;
        final literal = table![key];

        expect(literal, isNotNull,
            reason:
                'Missing key in generated table. locale=${locale.locale} key=$key');

        final decoded = _decodeDartStringLiteral(literal!);
        expect(
          decoded,
          equals(expected),
          reason: 'Value mismatch. locale=${locale.locale} key=$key\n'
              'Expected: ${jsonEncode(expected)}\n'
              'Actual:   ${jsonEncode(decoded)}\n'
              'Literal:  ${jsonEncode(literal)}',
        );
      }
    }
  });
}

Map<String, Map<String, String>> _extractAllGeneratedTranslationTables(
    String code) {
  // Matches: static const Map<String, String> _t_en = { ... };
  final tableHeader = RegExp(
    r'static const Map<String, String> _t_([a-zA-Z_]+) = \{',
    multiLine: true,
  );

  // Matches entries inside the table.
  final entryPattern = RegExp(
    r'''\s*("(?:\\.|[^"\\])+")\s*:\s*((?:'(?:\\.|[^'])*')|(?:"(?:\\.|[^"])*"))\s*,''',
    multiLine: true,
  );

  final out = <String, Map<String, String>>{};

  final matches = tableHeader.allMatches(code).toList();
  for (var i = 0; i < matches.length; i++) {
    final m = matches[i];
    final locale = m.group(1)!;

    final start = m.end;
    final end = (i + 1 < matches.length) ? matches[i + 1].start : code.length;
    final slice = code.substring(start, end);

    final map = <String, String>{};
    for (final e in entryPattern.allMatches(slice)) {
      final keyJson = e.group(1)!;
      final literal = e.group(2)!;
      map[jsonDecode(keyJson) as String] = literal;
    }

    out[locale] = map;
  }

  return out;
}

String _decodeDartStringLiteral(String literal) {
  if (literal.length < 2) {
    throw ArgumentError('Not a string literal: $literal');
  }

  final quote = literal[0];
  if ((quote != '\'' && quote != '"') || !literal.endsWith(quote)) {
    throw ArgumentError('Not a quoted literal: $literal');
  }

  final s = literal.substring(1, literal.length - 1);
  final buf = StringBuffer();

  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c != '\\') {
      buf.write(c);
      continue;
    }

    if (i == s.length - 1) {
      buf.write('\\');
      break;
    }

    final next = s[i + 1];

    if (next == 'n') {
      buf.write('\n');
      i++;
      continue;
    }
    if (next == 'r') {
      buf.write('\r');
      i++;
      continue;
    }
    if (next == 't') {
      buf.write('\t');
      i++;
      continue;
    }
    if (next == '\\') {
      buf.write('\\');
      i++;
      continue;
    }
    if (next == r'$') {
      buf.write(r'$');
      i++;
      continue;
    }

    if (next == quote) {
      buf.write(quote);
      i++;
      continue;
    }

    buf.write(next);
    i++;
  }

  return buf.toString();
}

String _repoRootFrom(String startPath) {
  var current = Directory(startPath);

  while (true) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync()) return current.path;

    final parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }

  // Fallback: tests sometimes run from temp directories.
  final cwd = Directory.current;
  final cwdPubspec = File(p.join(cwd.path, 'pubspec.yaml'));
  if (cwdPubspec.existsSync()) return cwd.path;

  throw StateError(
      'Unable to locate repo root (pubspec.yaml) starting from $startPath');
}

