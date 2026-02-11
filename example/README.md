# Example (canonical)

This repository ships a single canonical Flutter example app under `example/`.

Facts:
- Locales: English (`en`), Indonesian (`id`)
- Input (strict JSON): `assets/localizations/app_common_<locale>.json` (module: `common`)
- Output (generated): `lib/assets/app_localizations.gen.dart`

## Key casing policy

- **JSON/JSONC keys**: recommended `snake_case` (example: `welcome_user`, `invalid_code_errors`).
- **Generated Dart API** (default `field_rename: camel`): becomes `camelCase`:
  - JSON `welcome_user` -> Dart `welcomeUser(...)`
  - JSON `invalid_code_errors` -> Dart `invalidCodeErrors(context: ...)`

## Generate + run (cross-platform)

```bash
flutter pub get

dart run localization_gen generate

flutter test
flutter run
```

## Usage style (recommended)

Prefer direct access (no temporary `localization` variable):
- `AppLocalizations.of(context).strings.appTitle`

### Runtime key lookup (resolveByKey)

If you need to resolve a translation from a dynamic key (e.g. backend-driven):
- `AppLocalizations.of(context).resolveByKey('strings.app_title')`
- `AppLocalizations.of(context).resolveByKey('app_title', namespace: 'strings', fallback: '...')`

## What to ignore (recommended)

This example is a normal Flutter project; it produces local build artifacts.

Recommended ignores:
- `example/.dart_tool/`
- `example/build/`
- `example/ios/Flutter/` (generated)
- `example/macos/Flutter/` (generated)
- `example/linux/flutter/ephemeral/` (generated)
- `example/windows/flutter/ephemeral/` (generated)
- `example/web/.dart_tool/` (generated)

(Keep this list aligned with your platform targets.)
