# Assets (localization fixtures)

The `assets/` folder contains a **developer-readable fixture dataset** used to document and test this package.

Current structure (factual):
- `assets/localizations/` 
 JSONC fixtures + a short README

## JSONC vs JSON

- **JSONC (`.jsonc`)** is the canonical spec in this repo (commented, developer-readable).
- The generator consumes **strict JSON (`.json`)**.

## Key casing policy

- **JSON/JSONC keys** should be `snake_case` (example: `welcome_user`, `invalid_code_errors`).
- The **generated Dart API** uses `camelCase` by default (`field_rename: camel`):
  - JSON `welcome_user` -> Dart `welcomeUser(...)`
  - JSON `invalid_code_errors` -> Dart `invalidCodeErrors(context: ...)`

---

## Project policy: modular-only localization

This repo is **modular-only**.

### Required metadata (per file)
Every localization file **must** include:
- `@@locale` (e.g. `"en"`, `"id"`)
- `@@module` (e.g. `"common"`, `"auth"`, `"home"`)

Files are:
1. grouped by `@@locale`
2. merged across modules into one locale map

### Recommended file naming
Pattern:
- `<prefix>_<module>_<locale>.json`

Examples:
- `app_common_en.json`
- `app_common_id.json`

### Important constraints
- After merge, **no key collisions** are allowed.
- For the same key across locales, the **placeholder set** must match (order may differ).
- Recommended nesting depth: **1–6**.

---

## Canonical fixture dataset (CASE 1–15)

The canonical dataset lives under `assets/localizations/`:
- `assets/localizations/app_common_en.jsonc` 
 canonical dataset (EN), module `common`
- `assets/localizations/app_common_id.jsonc` 
 mirrored dataset (ID), module `common`

Key conventions used by the fixtures:
- Basic strings use the namespace **`strings.*`** (example key path: `strings.app_title`).
- All supported cases are listed once as `CASE INDEX (all cases appear once)` inside the JSONC files.

If you want to run the generator/validator against the same dataset:
- create equivalent `.json` files (same structure, without comments).

---

## Per-key metadata (inline-only)

This repo uses **inline-only metadata**.

### Inline metadata fields

- `@description`: String
- `@example`: String
- `@placeholders`: Map<String, String>
- Custom `@<name>` fields (e.g. `@since`, `@deprecated`, `@owner`)

### How to document a string key

JSON strings can't hold extra fields, so if you need documentation for a string key,
wrap it using `@value`:

```json
{
  "welcome_user": {
    "@value": "Welcome, {name}.",
    "@description": "Greets a user by name.",
    "@example": "Welcome, John.",
    "@placeholders": { "name": "User display name" }
  }
}
```

### Structured forms

Structured translations remain object-based and can carry inline metadata directly:

- `@plural`
- `@gender`
- `@context`

---

## Defaults (source of truth)

Some config values have defaults. Notably:
- `field_rename` default is **`camel`**.
