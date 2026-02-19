# Localizations (`assets/localizations`)

Folder ini berisi file JSON terjemahan yang dipakai oleh GroApp Frontend library.

## Konvensi file

Repo ini memakai **namespace** per area, contoh:

- `core_common_en.json` / `core_common_id.json`
- `core_auth_en.json` / `core_auth_id.json`
- `core_home_en.json` / `core_home_id.json`
- `core_settings_en.json` / `core_settings_id.json`
- `core_exceptions_en.json` / `core_exceptions_id.json`

Aturan:
- Setiap namespace harus punya pasangan untuk semua locale yang didukung.
- Struktur key di semua locale harus konsisten.

## Code generation

Generator yang dipakai: `localization_gen`.

Konfigurasi ada di `pubspec.yaml` (section `localization_gen`). Output Dart biasanya ada di:

- `lib/assets/core_localizations.dart` (dan/atau file terkait di `lib/assets/`)

Jalankan generate:

```bash
dart run localization_gen:localization_gen
```

> Repo ini juga menggunakan `build_runner` untuk codegen lain. Lihat root `README.md` untuk command yang disarankan.

## Cara menambah namespace baru

1. Buat 2 file baru:
   - `assets/localizations/<namespace>_en.json`
   - `assets/localizations/<namespace>_id.json`
2. Isi struktur key dengan konsisten.
3. Jalankan generator.
4. Pakai hasil generated di `lib/assets/`.

## Cara menambah key baru

1. Tambahkan key yang sama ke **semua** locale file namespace itu.
2. Jalankan generator.
3. Update pemakaian di widget/feature.

## Related docs

- Root: `README.md`
- Generated assets: `lib/assets/`
