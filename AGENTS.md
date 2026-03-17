# AGENTS.md (localization_gen)

## 60-second orientation
- This repo is a **Dart/Flutter localization code generator**.
- Main data flow: **`pubspec.yaml` config → parse modular `.json` locale files → validate consistency → generate a single `*.gen.dart` file**.
- Canonical examples/spec live as **JSONC fixtures** in `assets/localizations/*.jsonc` (comments allowed), but the generator **reads `.json` only**.

## Key entry points (where to start reading)
- CLI entry: `bin/localization_gen.dart` → `CommandRouter.run(args)`
- Command routing: `lib/src/command/command_router.dart` (commands: `generate|init|validate|clean|coverage`)
- Orchestration: `lib/src/generator/localization_generator.dart` → `LocalizationGenerator.generate()`
- Parsing/validation: `lib/src/parser/json_parser.dart` → `parseDirectory()` / `_validateLocaleConsistency()`
- Codegen: `lib/src/writer/dart_writer.dart` → `DartWriter.generate(locales)`
- Watch mode implementation: `lib/src/watcher/file_watcher.dart` → `FileWatcher.start()`

## Architecture & invariants (project-specific)
- **Modular-only inputs**: each `.json` file must include `@@locale` and `@@module`.
  - Enforced in `JsonLocalizationParser._parseModularFiles()` (throws if `@@module` missing).
  - Files are merged by locale: `app_auth_en.json + app_home_en.json → LocaleData('en')`.
- **Flattening rule**: nested JSON objects become dot-keys.
  - Implemented by `JsonLocalizationParser._flattenJson()`.
  - Special keys are skipped: anything starting with `@@` or `@`.
- **Inline-only per-key metadata** (no “sibling metadata blocks”):
  - For string values with metadata, wrap as an object and store the translation in `@value`.
  - Parsed in `JsonLocalizationParser._readInlineKeyMetadata()`.
  - Example shape (from `assets/localizations/README.md`):
    - `{"welcome_user": {"@value": "Welcome, {name}.", "@description": "..."}}`
- **Structured translations** are signaled by wrapper keys:
  - `@plural`, `@gender`, `@context` (handled inside `_flattenJson`).
- **Cross-locale strictness**: when multiple locales exist, keys + placeholder params must match.
  - Implemented by `JsonLocalizationParser._validateLocaleConsistency()`.
  - Placeholder extraction uses `{name}` syntax via `_extractParameters()`.

## Generated code shape (useful when editing writer)
- `DartWriter` generates a **dictionary-first** implementation:
  - `static const Map<String,String> _t_<locale> = {"a.b": "..."}`
  - plus `_p_`, `_g_`, `_c_` tables for plural/gender/context.
- Locale switching is done by selecting the appropriate table (see comments near `_fallbackLocale` in `lib/src/writer/dart_writer.dart`).

## Canonical fixtures vs real inputs
- Canonical spec: `assets/localizations/app_common_{en,id}.jsonc` (commented, developer-readable).
- Real generator inputs: consuming apps provide strict `.json` (see `example/assets/localizations/`).
- Fixture docs:
  - `assets/localizations/README.md` (case index + metadata rules)
  - `assets/README.md`

## Workflows (commands that matter in this repo)
- Package tests (pure Dart):
  - `dart test` (suite entry: `test/all_test.dart`)
- Flutter-driven tests (recommended by `test/README.md`):
  - `flutter test` (useful for watcher/platform behavior)
- Convenience targets: `Makefile`
  - `make check` (analyze + format-check + test)
  - `make test-file FILE=test/parser/json_parser_test.dart`
  - `make generate` / `make validate`
  - `make test-examples` (runs `flutter test` in `example/`)

## “Where do I add/change behavior?”
- Add a new translation feature (parser semantics): start in `lib/src/parser/json_parser.dart`, then update writer in `lib/src/writer/dart_writer.dart`, then add focused tests under the mirrored folder in `test/`.
- Add a new CLI flag/subcommand: add a command under `lib/src/command/` and register it in `CommandRouter._commands`.
- Update config options: `lib/src/config/config_reader.dart` + `test/config/config_reader_test.dart`.

## Tests that encode the contracts
- Parser semantics (metadata, wrappers, validation): `test/parser/` (notably `inline_metadata_test.dart`, `validation_test.dart`).
- Generator end-to-end & locale consistency: `test/generator/` (e.g. `value_consistency_test.dart`, `placeholder_interpolation_test.dart`).
- Writer escaping/newline/symbol edge cases: `test/writer/` (e.g. `newline_escape_test.dart`, `symbol_escape_test.dart`).
- JSONC parity/fixtures: `test/fixtures/jsonc_parity_test.dart`.

