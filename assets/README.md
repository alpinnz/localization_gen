# Assets examples (developer-readable)

This folder contains **developer-facing examples** used as a spec/dataset.

## Why `.jsonc`?
Standard JSON (`.json`) does not support comments.

We provide `.jsonc` (JSON with comments) so the dataset can explain:
- what each case tests
- how placeholders should be formatted
- how to attach metadata for documentation (dartdoc-friendly)

> The generator/parser in this repo reads `*.json`. Use `.jsonc` as a reference,
> then copy the structure into real `.json` files.

## Files
- `app_en.jsonc` — canonical spec + examples (English)
- `app_id.jsonc` — mirrored cases (Indonesian)

## Recommended workflow
1. Read `app_en.jsonc` to understand supported cases.
2. Keep your real app translations in `assets/localizations/*.json`.
3. Enable `strict_validation` to ensure:
   - same keys across locales
   - same placeholder sets across locales

## Metadata blocks (`@<key>`)
For any key `foo.bar.baz`, you can add a sibling metadata object:

- key: `foo.bar.baz`
- metadata: `@baz` (inside the same object)

Example:
- `"welcome_user": "Welcome, {name}."`
- `"@welcome_user": {"description": "...", "example": "..."}`

These metadata blocks are useful for documentation tooling and can be embedded
into generated Dart docs.
