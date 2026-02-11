# Localization fixtures (`assets/localizations/`)

This folder contains the **canonical JSONC fixture dataset** for this repository.

Why JSONC?
- JSONC allows comments, so developers can read the supported patterns.
- JSONC (`.jsonc`) is treated as the canonical spec in this repo.

Generator input:
- The generator reads **`.json`** only (strict JSON).

## Contents (factual)
- `app_common_en.jsonc` 
 locale `en`, module `common` (spec + comments)
- `app_common_id.jsonc` 
 locale `id`, module `common` (spec + comments)

Strict JSON datasets (`.json`) are intentionally **not** stored here.
They live in the consuming app (see `example/assets/localizations/`).

## Key casing policy

- **JSON/JSONC keys**: recommended `snake_case` (example: `welcome_user`, `invalid_code_errors`).
- **Generated Dart API** (default `field_rename: camel`): becomes `camelCase`:
  - JSON `welcome_user` -> Dart `welcomeUser(...)`
  - JSON `invalid_code_errors` -> Dart `invalidCodeErrors(context: ...)`

This JSONC spec includes the latest cases (including `@context` multi-variant `register/verification`).

Both files:
- are **modular** and include required metadata: `@@locale` and `@@module`
- use the basic-string namespace **`strings.*`** (example JSON key path: `strings.app_title` 
 generated Dart: `strings.appTitle`)

## CASE INDEX (supported cases)

All supported cases are documented once inside each JSONC file under:
- `CASE INDEX (all cases appear once)`

Currently the dataset covers:

1) `@@locale` metadata
2) `@@module` metadata
3) Basic strings (`strings.*`)
4) Nested keys (flattened dot-keys, recommended max depth 6)
5) Placeholders `{name}` (named parameters)
6) Multiple placeholders in one message
7) Placeholder reordering across locales
8) Per-key metadata (inline-only: `@description/@example/@placeholders` + custom `@<name>`; use `@value` wrapper for string keys)
9) Newline escaping (`\n`)
10) Quote escaping (`\"`)
11) Unicode punctuation
12) Symbols inside strings (URLs, email, masked bullets, legal symbols, etc.)
13) Literal tokens that are not placeholders (e.g. `{{...}}`, `[x]`)
14) Literal braces `{` and `}`
15) Structured forms: `@plural`, `@gender`, `@context`

## Metadata (inline-only)

This package supports **inline-only** per-key metadata.

Supported fields:
- `@description`
- `@example`
- `@placeholders`
- Custom `@<name>` fields (`@since`, `@deprecated`, `@owner`, ...)

### Metadata for string keys

If a translation is a simple string but you want metadata, wrap it as an object and
store the actual text in `@value`:

```json
{
  "placeholders": {
    "welcome_user": {
      "@value": "Welcome, {name}.",
      "@description": "Greets a user by name.",
      "@example": "Welcome, John.",
      "@placeholders": { "name": "User display name" }
    }
  }
}
```

## Using this dataset for real generation

To run `generate`/`validate` against this dataset:
- create equivalent `.json` files with the same structure (remove comments)

See `assets/README.md` for the modular-only rules and constraints.
