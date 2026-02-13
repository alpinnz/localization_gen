/// Ensures generated Dart output preserves the *runtime* values from JSON.
///
/// Contract
/// - For every flattened translation key in the input JSON, the generated
///   translation table must contain the same runtime string value.
/// - Dart source escaping (e.g. `\$`, `\n`, `\\`) is permitted as long as the
///   decoded runtime value matches the JSON value.
library;

import 'dart:convert';

import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:test/test.dart';

import '../utils/test_helper.dart';

void main() {
  group('Generated value consistency', () {
    test('generated translation table matches JSON runtime values for all keys',
        () {
      final dir = TestHelper.createTempDir('value_consistency_');
      addTearDown(() => TestHelper.cleanupDir(dir));

      // Includes edge-cases: dollar sign, newlines, quotes, unicode, backslashes.
      TestHelper.createJsonFile(
        dir,
        'app_common_en.json',
        jsonEncode({
          '@@locale': 'en',
          '@@module': 'common',
          'symbols': {
            'currency_and_amount': r'Total: $12.50 / Rp 10.000',
            'bullet_list_like': '• Item 1\n• Item 2\n• Item 3',
          },
          'formatting': {
            'multiline': 'Line 1\nLine 2',
            'quotes': 'Enable "remember me" to stay signed in.',
            'unicode': 'Don’t worry… it’s fine – keep going.',
            'apostrophe': "It\'s ok — keep going.",
            'backslash_path': r'Path: C:\\Users\\test',
          },
        }),
      );

      final locales =
          JsonLocalizationParser.parseDirectory(dir.path, filePrefix: 'app');
      expect(locales, hasLength(1));

      final writer = DartWriter(className: 'TestLocalizations');
      final code = writer.generate(locales);

      final locale = locales.single;
      final expectedByKey = <String, String>{
        for (final e in locale.items.entries) e.key: e.value.value,
      };

      final generatedByKey = _extractGeneratedTranslationTable(code);

      for (final entry in expectedByKey.entries) {
        final key = entry.key;
        final expectedValue = entry.value;

        final generatedLiteral = generatedByKey[key];
        expect(
          generatedLiteral,
          isNotNull,
          reason: 'Missing key in generated translation table: $key',
        );

        final decoded = _decodeSingleQuotedDartStringLiteral(generatedLiteral!);
        expect(
          decoded,
          equals(expectedValue),
          reason: 'Value mismatch for key: $key\n'
              'Expected: ${jsonEncode(expectedValue)}\n'
              'Actual:   ${jsonEncode(decoded)}\n'
              'Literal:  ${jsonEncode(generatedLiteral)}',
        );
      }
    });
  });
}

/// Extracts key -> single-quoted Dart string literal from the generated `_t_xx` table.
///
/// We intentionally don't lock the entire generated file; we only parse the table
/// entries so tests remain stable across unrelated formatting changes.
Map<String, String> _extractGeneratedTranslationTable(String code) {
  // Example line:
  //   "symbols.currency_and_amount": 'Total: \$12.50 / Rp 10.000',
  // The literal can contain escaped quotes/backslashes.
  final entryPattern = RegExp(
    r'''\s*("(?:\\.|[^"\\])+")\s*:\s*(\'(?:\\.|[^\'])*\')\s*,''',
    multiLine: true,
  );

  final out = <String, String>{};
  for (final m in entryPattern.allMatches(code)) {
    final keyJson = m.group(1)!;
    final literal = m.group(2)!;
    out[jsonDecode(keyJson) as String] = literal;
  }
  return out;
}

/// Decodes a *single-quoted* Dart string literal produced by the generator.
///
/// Supports the escape sequences we emit:
/// - \\n, \\r, \\t
/// - \\\\ (backslash)
/// - \\\' (single quote)
/// - \\$ (dollar, to avoid interpolation)
String _decodeSingleQuotedDartStringLiteral(String literal) {
  if (!literal.startsWith("'") || !literal.endsWith("'")) {
    throw ArgumentError('Not a single-quoted literal: $literal');
  }

  final s = literal.substring(1, literal.length - 1);
  final buf = StringBuffer();

  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c != '\\') {
      buf.write(c);
      continue;
    }

    // Special-case: \\' is a common representation we see in our captured
    // literals (because backslashes are already escaped in the source). It
    // should decode to a single apostrophe.
    if (i + 2 < s.length && s[i + 1] == '\\' && s[i + 2] == "'") {
      buf.write("'");
      i += 2;
      continue;
    }

    if (i == s.length - 1) {
      buf.write('\\');
      break;
    }

    final next = s[++i];
    switch (next) {
      case 'n':
        buf.write('\n');
        break;
      case 'r':
        buf.write('\r');
        break;
      case 't':
        buf.write('\t');
        break;
      case "'":
        buf.write("'");
        break;
      case r'$':
        buf.write(r'$');
        break;
      case '\\':
        buf.write('\\');
        break;
      default:
        buf.write(next);
    }
  }

  return buf.toString();
}
