# Saka — sprint, jump, slide v01

Sprint terbaru: `char_saka_sprint_right_v05.png`, dengan identitas/lapisan kaki seluruh frame 5–8 ditukar. Gunakan `saka_sprint_frames_v05.tres` dan buka `saka_sprint_review_v05.tscn` dengan F6. Resource ini mempertahankan frame 1–4 dari PNG v04. Catatan, sumber dan prompt ada di `SPRINT_BOTTOM_SWAP_V05.md`. Preview tiga aksi v01 di bawah masih memakai sprint versi awal.

Tiga sheet PNG transparan menghadap kanan, dibuat dengan built-in image_gen memakai IDLE dan WALK pengguna yang sedang aktif sebagai referensi. Gaya sederhana, rambut hitam, mata cyan, hoodie putih berpanel hitam, sabuk abu-abu, celana gelap, dan sepatu hitam-putih dipertahankan. Ini versi baru untuk ditinjau; bukan pengganti otomatis sprite yang sudah disetujui.

| Sheet | Frame | Susunan | Pemakaian |
|---|---:|---|---|
| `char_saka_sprint_right_v01.png` | 8 | 4 × 2 | Siklus sprint, 12 fps, loop |
| `char_saka_jump_right_v01.png` | 6 | 3 × 2 | Antisipasi, lepas landas, naik, puncak, turun, mendarat |
| `char_saka_slide_right_v01.png` | 4 | 2 × 2 | Masuk, tahan, tahan variasi, pemulihan rendah |

Urutan kiri ke kanan, lalu baris berikutnya. Hasil generasi tidak mempunyai jarak baris matematis yang sama: gunakan AtlasTexture yang disediakan, jangan membagi PNG dengan hframes/vframes secara otomatis. PNG dipertahankan utuh; seluruh crop dan padding dilakukan dengan resource Godot tanpa menyunting piksel.

## Review di Godot

Buka `saka_actions_preview_v01.tscn`, lalu F6. Preview menampilkan IDLE dan WALK asli berdampingan dengan tiga animasi baru. Tekan 1/2/3 untuk memilih sprint/jump/slide; Space untuk pause; panah kiri/kanan untuk melihat frame; R untuk ulang. Jump dan slide diulang oleh preview agar mudah ditinjau, sementara resource animasinya tidak loop.

Preview render: `res://outputs/characters/saka_actions_preview_v01.png`.

## Resource aset

- `saka_action_frames_v01.tres`: 18 AtlasTexture dengan canvas transparan virtual 1100 × 520 dan anchor (550,500).
- `saka_action_sprite_v01.tscn`: Node2D siap instance untuk tampilan aset. Origin adalah titik pijak untuk sprint/jump dan sekitar pelvis untuk slide. `show_action()` memilih animasi dan skala seragam.
- `manifest.json`: region setiap frame, anchor, baseline, ukuran visual, skala, dan susunan animasi.
- `source_metadata.json`: pemeriksaan dimensi, alpha, batas siluet, dan bagian wajah. Angka deteksi wajah bersifat bantuan inspeksi, bukan rig karakter.

Animasi: `sprint`, `jump`, `jump_start`, `jump_air`, `jump_fall`, `jump_land`, `slide`, `slide_enter`, `slide_hold`, `slide_exit`. Saat memasang gameplay, gunakan fase terpisah sesuai keadaan karakter. Animasi `jump_air` dan `slide_hold` loop; fase masuk/keluar tidak loop.

Skala preview: sprint 0.81, jump 0.78, slide 0.60. Skala selalu seragam pada kedua sumbu, dibandingkan dengan IDLE/WALK asli dengan tinggi nominal 380 px. Posisi rendah berasal dari pose, bukan pemampatan gambar. Tinggi siluet sprint sekitar 277–298 px; jump 254–321 px menurut fase; slide masuk sekitar 157 px dan tahan sekitar 132–135 px. Ukuran ini adalah batas gambar, bukan spesifikasi collision. Gerak vertikal jump mengikuti root karakter dari controller, tidak dibakar ke sheet.

Gunakan filter Nearest dan alpha cutout 0.5 yang disediakan untuk outline tegas. PNG asli memiliki alpha nyata; nilai RGB pada piksel alpha 0 harus diabaikan. Tidak ada karakter atau lingkungan lain di sheet.

Resource ini hanya untuk arah kanan. IDLE/WALK kiri yang disetujui mempunyai mata abu-abu, sehingga flip horizontal aksi kanan saja akan menghasilkan mata cyan yang berbeda dari referensi kiri. Aksi kiri khusus belum dibuat.

Tidak ada perubahan pada controller Saka, mekanik sprint/jump/slide, QTE, collision, atau main scene. Integrasi gameplay dikerjakan terpisah.

## Prompt dan validasi

Prompt lengkap dan metode tersimpan di `PROMPTS.md`, koreksi pose slide terakhir di `FINAL_SLIDE_PROMPT.md`. Script `work/inspect_saka_actions.py` hanya membaca PNG; `work/build_saka_action_resources.py` menulis resource dan manifest.

Impor Godot berhasil. Preview memvalidasi ukuran canvas seluruh atlas dan merender seluruh 8/6/4 frame dengan renderer Compatibility. Log: `work/saka_actions_capture_stdout.log` dan `work/saka_actions_capture_stderr.log`. PNG referensi dan PNG hasil generasi tidak dimodifikasi oleh proses pembuatan resource.
