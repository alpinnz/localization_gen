# Assets (localization examples)

Folder `assets/` berisi dua hal:

1) **Spec/dataset referensi (JSONC)**
   - File `.jsonc` dipakai untuk dokumentasi karena bisa punya komentar.
   - Ini jadi landasan pola, case, dan aturan validasi.

2) **Fixture contoh (folder `assets/localizations/`)**
   - Folder ini berisi file contoh yang bisa dipakai sebagai dataset/fixture untuk demo & pengujian.

> Catatan: package ini membaca `*.json`. File `.jsonc` hanya untuk dokumentasi/pola.

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
- `app_auth_en.json`
- `app_auth_id.json`

### Constraints penting
- **Tidak boleh ada collision key** setelah merge antar module.
- Untuk 1 key yang sama di semua bahasa, **placeholder set harus sama** (urutan boleh beda).
- Nested keys disarankan **maksimal depth 6**.

---

## Isi folder ini

### 1) Spec/dataset (JSONC)
Referensi utama untuk semua “case” yang didukung library:
- `assets/app_common_en.jsonc` — canonical spec + dataset (EN) untuk module `common`
- `assets/app_common_id.jsonc` — mirror dataset (ID) untuk module `common`

File berikut sengaja minimal (pointer) agar tidak redundant:
- `assets/app_en.jsonc` → menunjuk ke `assets/app_common_en.jsonc`
- `assets/app_id.jsonc` → menunjuk ke `assets/app_common_id.jsonc`

### 2) `assets/localizations/` (fixture contoh)
Saat ini folder `assets/localizations/` berisi:
- `assets/localizations/app_common_en.jsonc`
- `assets/localizations/app_common_id.jsonc`

Jika kamu ingin fixture yang benar-benar diparse generator (real run), simpan juga versi `.json`
(tanpa komentar) dengan struktur yang sama.

---

## Metadata blocks (`@<key>`)
Pada object yang sama dengan key translation, kamu boleh menambahkan metadata untuk docs.

Contoh:
- `"welcome_user": "Welcome, {name}."`
- `"@welcome_user": { "description": "...", "example": "..." }`

Metadata ini berguna untuk tooling/dokumentasi dan bisa di-embed ke dartdoc hasil generate.
