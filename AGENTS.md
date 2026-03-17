# AGENTS.md (localization_gen)

## Big picture (what this repo does)
- This repo is a **Dart/Flutter localization code generator**.
- Main data flow: **`pubspec.yaml` config → parse modular `*.json` locale files → validate consistency → generate one `*.gen.dart` file**.
  - Orchestrator: `lib/src/generator/localization_generator.dart` (`LocalizationGenerator.generate()`).

## Key entry points (read these first)
- CLI entry: `bin/localization_gen.dart` → `CommandRouter.run(args)` in `lib/src/command/command_router.dart`.
- Parser/validation semantics: `lib/src/parser/json_parser.dart`.
- Generated Dart output + escaping policy: `lib/src/writer/dart_writer.dart`.

## Project-specific invariants (easy to break by accident)
- **Modular-only inputs**: every locale file must include `@@locale` and `@@module` (see `assets/README.md`).
- **Flattening rule**: nested JSON objects become dot-keys (e.g. `{ "auth": {"login": "Login"}} → "auth.login"`).
  - Implemented in `JsonLocalizationParser._flattenJson()`.
- **Special keys are skipped while flattening**: any key starting with `@@` or `@`.
- **Inline-only per-key metadata**: no sibling `@<key>` blocks.
  - If a string needs metadata, wrap it and store the translation in `@value` (see `assets/localizations/README.md`).
- **Structured translations** are signaled by wrapper keys: `@plural`, `@gender`, `@context` (handled inside `_flattenJson`).
- **Cross-locale strictness**: when multiple locales exist, keys + placeholder params must match.
  - Placeholder extraction uses `{name}` syntax (see `_extractParameters()` in `json_parser.dart`).

## Canonical fixtures vs real inputs
- Canonical spec/examples are **JSONC fixtures** (comments allowed): `assets/localizations/app_common_{en,id}.jsonc`.
- The generator consumes **strict `.json` only**; see real inputs under `example/assets/localizations/`.

## Generated code shape (writer mental model)
- `DartWriter` is **dictionary-first** per locale:
  - `static const Map<String, String> _t_<locale> = {"a.b": "..."}`
  - plus plural/gender/context tables (naming in `dart_writer.dart`).
- API note (breaking in 2.3.1): generated getters/methods return **`String?`**; missing keys/locale resolve to `null` (see `CHANGELOG.md`).

## Workflows (fast feedback)
- Tests mirror `lib/src/*` → `test/*` (see `test/README.md`).
- Common repo commands (see `Makefile`): `make check`, `make generate`, `make validate`, `make test-examples`.
- Direct equivalents:
  - `dart test` (pure Dart)
  - `flutter test` (recommended here; watcher/platform behavior)

## Where to change behavior (and where contracts live)
- Config parsing/defaults: `lib/src/config/config_reader.dart` (+ `test/config/config_reader_test.dart`).
- Parsing/validation rules: `lib/src/parser/json_parser.dart` (+ `test/parser/*`, especially `inline_metadata_test.dart`, `validation_test.dart`).
- Escaping/output/API: `lib/src/writer/dart_writer.dart` (+ `test/writer/*`, e.g. `newline_escape_test.dart`, `symbol_escape_test.dart`).

