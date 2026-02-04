# Localization fixtures (`assets/localizations/`)

Folder ini berisi **fixture contoh** untuk kebutuhan demo/pengujian.

Saat ini isinya memang **hanya JSONC** (bukan `.json`), supaya developer bisa membaca komentar dan memahami polanya.

## Isi folder (faktual)
- `app_common_en.jsonc` — locale `en`, module `common`
- `app_common_id.jsonc` — locale `id`, module `common`

Kedua file di atas:
- **wajib modular metadata**: `@@locale` dan `@@module` (default module: `common`)
- punya namespace basic string bernama **`strings`** (contoh key: `strings.app_title`)

## Ringkasan case yang ada di file JSONC (faktual)
Semua case ada di `CASE INDEX (all cases appear once)` dalam file JSONC tersebut. Saat ini mencakup:

1) `@@locale` metadata
2) `@@module` metadata
3) Basic strings (namespace: `strings.*`)
4) Nested keys (flatten ke dot-keys, max depth 6)
5) Placeholders `{name}` (named parameters)
6) Multiple placeholders dalam 1 string
7) Placeholder reordering antar bahasa
8) Per-key metadata `@<key>` (dartdoc-friendly)
9) Newline `\\n`
10) Quote escaping `\\"`
11) Unicode punctuation (ellipsis, en-dash, dll)
12) Simbol di dalam string (URL/email/angka/simbol legal, bullet leader `••••••••`, dll)
13) Literal tokens yang *bukan* placeholder (mis. `{{...}}`, `[x]`)
14) Literal braces `{` dan `}`
15) Structured forms: `@plural`, `@gender`, `@context`

## Catatan penting
- Generator/package ini membaca `*.json` (JSON murni).
- Jadi, kalau kamu ingin folder ini dipakai untuk **real run** (generate/validate) tanpa modifikasi,
  buat juga versi `.json` (tanpa komentar) dengan struktur yang sama.

> Penjelasan lengkap workflow modular-only ada di `assets/README.md`.
