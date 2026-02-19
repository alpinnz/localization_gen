/// Validates that the canonical JSONC specs in `assets/` match the JSON inputs
/// used for generation in `example/assets/`.
///
/// This ensures translation *values* stay consistent across:
/// - JSONC (developer-readable canonical spec)
/// - JSON (generator input)
///
/// Notes
/// - JSONC allows comments. This test strips `//` line comments.
/// - This test is intentionally strict about values.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

final _packageCwdAtLoadTime = Directory.current.path;

void main() {
  // Capture this at load time so other tests changing `Directory.current`
  // can’t affect our path resolution.
  final workspaceCwd = _packageCwdAtLoadTime;

  group('JSONC ↔ JSON value parity (canonical assets)', () {
    test('app_common_en.jsonc matches example/app_common_en.json', () {
      _assertJsoncMatchesJson(
        jsoncPath: p.join('assets', 'localizations', 'app_common_en.jsonc'),
        jsonPath:
            p.join('example', 'assets', 'localizations', 'app_common_en.json'),
        workspaceCwd: workspaceCwd,
      );
    });

    test('app_common_id.jsonc matches example/app_common_id.json', () {
      _assertJsoncMatchesJson(
        jsoncPath: p.join('assets', 'localizations', 'app_common_id.jsonc'),
        jsonPath:
            p.join('example', 'assets', 'localizations', 'app_common_id.json'),
        workspaceCwd: workspaceCwd,
      );
    });
  });
}

void _assertJsoncMatchesJson({
  required String jsoncPath,
  required String jsonPath,
  required String workspaceCwd,
}) {
  final root = _repoRootFrom(workspaceCwd);
  final jsoncFile = File(p.join(root, jsoncPath));
  final jsonFile = File(p.join(root, jsonPath));

  expect(jsoncFile.existsSync(), isTrue,
      reason: 'Missing JSONC spec: ${jsoncFile.path}');
  expect(jsonFile.existsSync(), isTrue,
      reason: 'Missing JSON input: ${jsonFile.path}');

  final jsoncRaw = jsoncFile.readAsStringSync();
  final jsonRaw = jsonFile.readAsStringSync();

  final jsoncNormalized = _stripJsoncComments(jsoncRaw);

  Map<String, dynamic> jsonc;
  Map<String, dynamic> json;
  try {
    jsonc = jsonDecode(jsoncNormalized) as Map<String, dynamic>;
  } catch (e) {
    throw StateError(
        'Failed to parse JSONC after stripping comments for $jsoncPath: $e');
  }

  try {
    json = jsonDecode(jsonRaw) as Map<String, dynamic>;
  } catch (e) {
    throw StateError('Failed to parse JSON for $jsonPath: $e');
  }

  // We compare only translation-relevant payload. Both include @@locale and @@module.
  // This is strict for all keys and values.
  expect(json, equals(jsonc));
}

String _stripJsoncComments(String input) {
  final lines = const LineSplitter().convert(input);
  final out = StringBuffer();
  for (final line in lines) {
    final trimmed = line.trimLeft();
    // Drop whole-line comments.
    if (trimmed.startsWith('//')) continue;

    // Drop trailing // comments only when they're outside string literals.
    // We keep it conservative: if we can't be sure, keep the line.
    final idx = _indexOfLineCommentOutsideString(line);
    out.writeln(idx == null ? line : line.substring(0, idx));
  }
  return out.toString();
}

int? _indexOfLineCommentOutsideString(String line) {
  var inString = false;
  var escaped = false;
  for (var i = 0; i < line.length - 1; i++) {
    final c = line[i];

    if (escaped) {
      escaped = false;
      continue;
    }

    if (c == '\\') {
      escaped = true;
      continue;
    }

    if (c == '"') {
      inString = !inString;
      continue;
    }

    if (!inString && c == '/' && line[i + 1] == '/') {
      return i;
    }
  }
  return null;
}

String _repoRootFrom(String startPath) {
  var current = Directory(startPath);

  while (true) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync()) {
      return current.path;
    }

    final parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }

  // Fallback: when tests operate in a temp directory, walking upwards won't
  // reach the repo root. Use the process working directory instead.
  final cwd = Directory.current;
  final cwdPubspec = File(p.join(cwd.path, 'pubspec.yaml'));
  if (cwdPubspec.existsSync()) {
    return cwd.path;
  }

  throw StateError(
      'Unable to locate repo root (pubspec.yaml) starting from $startPath');
}
