# Assets (localization examples)

Folder `assets/` berisi **fixture + dokumentasi pola** untuk package ini.

Saat ini struktur yang tersedia (faktual):
- `assets/localizations/` — kumpulan file contoh (JSONC) + README

> Catatan: package ini membaca `*.json` (JSON murni). File `.jsonc` disediakan untuk dokumentasi karena bisa berisi komentar.

---

## Kebijakan proyek: modular-only localization
Repo ini memakai **modular-only** agar konsisten dan menghindari migrasi “tricky” dari non-modular → modular.

### Aturan file modular
Setiap file modular **WAJIB** punya:
- `@@locale` (contoh: `"en"`, `"id"`)
- `@@module` (contoh: `"common"`, `"auth"`, `"home"`)

Generator akan:
- membaca semua file input
- mengelompokkan berdasarkan `@@locale`
- merge semua module untuk locale yang sama menjadi 1 map translation

### Penamaan file (rekomendasi)
Pola:
- `<prefix>_<module>_<locale>.json`

Contoh:
- `app_common_en.json`
- `app_common_id.json`

### Constraints penting
- **Tidak boleh ada collision key** setelah merge antar module.
- Untuk 1 key yang sama di semua bahasa, **placeholder set harus sama** (urutan boleh beda).
- Nested keys disarankan **maksimal depth 6**.

---

## Dataset contoh yang tersedia (faktual)
Dataset/case utama saat ini ada di folder `assets/localizations/`:
- `assets/localizations/app_common_en.jsonc` — canonical dataset (EN), module `common`
- `assets/localizations/app_common_id.jsonc` — mirror dataset (ID), module `common`

Catatan penting tentang struktur key:
- Namespace basic string memakai **`strings`** (contoh key path: `strings.app_title`).
- Semua case dirangkum sebagai `CASE INDEX (all cases appear once)` di masing-masing file JSONC.

Jika kamu ingin dataset ini bisa dipakai untuk real run generator/validator tanpa modifikasi:
- buat juga versi `.json` (tanpa komentar) dengan struktur yang sama.

---

## Metadata blocks (`@<key>`)
Pada object yang sama dengan key translation, kamu boleh menambahkan metadata untuk docs.

Contoh:
- `"welcome_user": "Welcome, {name}."`
- `"@welcome_user": { "description": "...", "example": "..." }`

Metadata ini berguna untuk tooling/dokumentasi dan bisa di-embed ke dartdoc hasil generate.
