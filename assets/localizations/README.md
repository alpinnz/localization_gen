# Localization fixtures (`assets/localizations/`)

Folder ini berisi **fixture contoh** untuk kebutuhan demo/pengujian.

Saat ini isinya memang **hanya JSONC** (bukan `.json`), supaya developer bisa membaca komentar dan memahami polanya.

## Isi folder (faktual)
- `app_common_en.jsonc` — locale `en`, module `common`
- `app_common_id.jsonc` — locale `id`, module `common`

Kedua file di atas sudah menyertakan metadata modular:
- `@@locale`
- `@@module` (default: `common`)

## Catatan penting
- Generator/package ini membaca `*.json`.
- Jadi, kalau kamu ingin folder ini dipakai untuk **real run** (generate/validate) tanpa modifikasi,
  buat juga versi `.json` (tanpa komentar) dengan struktur yang sama.

> Referensi canonical + penjelasan lengkap case ada di `assets/README.md`.
