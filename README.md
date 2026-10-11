# KALA — Arunika Studio

Project game 2D Godot. Snapshot awal repository: 11 Oktober 2026.
Estimasi implementasi keseluruhan prolog saat ini sekitar **40%**.

## Menjalankan

Gunakan Godot 4.7 (project saat ini diuji dengan 4.7.2). Setelah clone, import
`project.godot`, tunggu impor aset selesai, lalu F5 untuk mulai dari apartemen.

| Tes langsung | Scene untuk dibuka, lalu F6 |
| --- | --- |
| Jembatan ke kedai | `scenes/prolog/bridge_to_kedai_test.tscn` |
| Kedai | `scenes/prolog/kedai_dialogue_test.tscn` |
| Fase kabur | `scenes/prolog/bridge_escape_test.tscn` |

A/D atau panah untuk bergerak, E untuk interaksi. Dialog textbox memakai
E/Space/Enter; floating bubble berjalan otomatis. Fase kabur memakai Shift
untuk sprint, Ctrl/C untuk slide, dan Space untuk lompat.

## Status prolog

Apartemen → jembatan → kedai sudah tersambung, termasuk dialog, pilihan jawaban,
Tara mengikuti Saka, pemilihan kursi, getaran, dan perjalanan pulang.
Fase kabur memiliki prototipe kilatan, kerusakan, collision, sprint/slide/jump
dan checkpoint. Tragedi Tara/Maestro, lorong, brankas/sabuk, audio dan perapihan
akhir belum selesai.

Aset jembatan rusak dan aksi Saka yang disiapkan untuk doomsday ikut repository,
tetapi belum menggantikan placeholder di gameplay. Lihat [inventaris aset](assets/README.md)
dan [panduan fase kabur](outputs/BRIDGE_ESCAPE_GUIDE.md).

## Kolaborasi aset

PNG dan master Pixelorama `.pxo` menggunakan **Git LFS**. GitHub Desktop dapat
dipakai untuk clone, commit, push dan pull. Jika memakai terminal, pasang Git LFS
lalu jalankan:

```sh
git lfs install
git clone https://github.com/72knvm/Arunika-Studio.git
cd Arunika-Studio
git lfs pull
```

1. Pull perubahan terbaru sebelum mulai mengedit.
2. Ekspor revisi PNG ke nama dan path yang sama di `assets/`.
3. Pertahankan ukuran canvas, jumlah/urutan frame, transparansi dan posisi kaki.
   Perubahan bentuk yang melewati crop atlas perlu penyesuaian resource Godot.
4. Simpan master `.pxo` di folder `art_sources/`, terpisah dari PNG runtime.
5. Kerjakan di branch sendiri, commit/push, lalu buat pull request untuk review.

Scene `.tscn`, resource `.tres`, script/shader `.uid`, dan konfigurasi `.import`
ikut version control. Cache `.godot/`, backup ZIP, draft yang sudah diarsipkan,
hasil render dan file sementara tetap lokal. Setelah pull, buka/fokuskan editor
Godot agar aset yang berubah diimpor ulang; jalankan scene terkait untuk mengecek
skala, transparansi, atlas dan pijakan kaki.

## Struktur

- `assets/`: PNG, atlas, shader dan paket aset persiapan.
- `scenes/`, `scripts/`: scene Godot dan logika game/UI.
- `data/dialogue/`: data dialog.
- `docs/`: naskah, GDD dan spesifikasi produksi.
- `outputs/*.md`: panduan implementasi dan tes yang sudah tersedia.

Backup lokal sebelum setup Git: `KALA_Prolog_40persen_2026-10-11.zip`.
Persentase adalah estimasi implementasi, bukan status penyelesaian naskah.
