# Floating text KALA v01

Dibuat 11 Oktober 2026 dengan built-in image_gen. Panel dan ekor versi lampiran pengguna dipasang di scene jembatan. PNG disalin utuh dari lampiran; atlas memilih area objek dan shader alpha cutout0.5 menghilangkan halo saat render.

## File

- `ui_floating_text_panel_v01.png`: panel kosong, PNG RGBA 2172 × 724.
- `ui_floating_text_tail_v01.png`: ekor menunjuk ke bawah, PNG RGBA 1586 × 992.
- Dua file `.tres` AtlasTexture mengacu ke PNG masing-masing dan memilih area objek tanpa sebagian besar padding transparan. PNG sumber tidak diedit.

Pemeriksaan dengan Pillow menemukan rentang alpha 0–255 pada keduanya. Bounds dengan alpha >= 128: panel (106,165)–(2066,558); ekor (260,277)–(1327,883). Alpha di tengah kedua gambar 254. Warna tengah panel (238,225,199); ekor (236,223,198). Gambar generatif memiliki sedikit variasi warna/tepi; ini skin percobaan, bukan jaminan pixel-perfect.

## Pemakaian Godot

- Gunakan panel untuk celetukan pendek saat berjalan atau interaksi: sekitar 1–2 baris, tanpa portrait atau nama.
- Tulisan merupakan Label/RichTextLabel terpisah dengan warna arang; jangan dibakar ke gambar.
- Gunakan `ui_floating_text_panel_v01.tres` sebagai texture NinePatchRect. Area center diregangkan; sudut dipertahankan.
- Karena sumber beresolusi besar, titik awal yang masuk akal adalah NinePatchRect berukuran lokal 1800 × 440, patch_margin 80 pada empat sisi, lalu scale 0.2 sehingga terlihat sekitar 360 × 88 piksel. Letakkan Label pada layer yang tidak ikut diperkecil. Lebar akhir mengikuti panjang teks; ukuran ini bukan batas wajib.
- Gunakan `ui_floating_text_tail_v01.tres` pada TextureRect dengan ukuran tampilan sekitar 24 × 14 piksel. Tepi atas ekor sengaja terbuka; gambar di atas panel dan tumpangkan sekitar 3 piksel ke border bawah agar sambungan tertutup.
- Gunakan texture filter nearest. Posisi dan ukuran dibulatkan ke piksel layar agar pinggir tidak bergetar saat karakter berjalan.
- Posisikan di atas kepala karakter. Saat balon mendekati tepi layar, geser panel ke dalam layar sambil menjaga ekor menunjuk karakter. Hindari menutup wajah atau indikator interaksi.
- Runtime sudah terpasang sebagai scenes/ui/floating_dialogue.tscn dan scripts/ui/floating_dialogue.gd: panel660×142px, font32px, ekor40×23px, nine-slice lokal diskalakan0.25 agar sudut tetap kecil. Panel dijaga masuk layar, ekor mengikuti pembicara melalui transform kamera, dan tidak menutup kepala kedua karakter.
- scripts/prolog/bridge_walk_dialogue.gd memicu empat ucapan dari data/dialogue/pro_02_bridge_walk.json. Tiga belas halaman pendek mempertahankan wording asli floating bubble STORY_FINAL.md. Data pause_before mengatur jeda awal2.5detik dan antarucapan0.8detik. Jarak pemicu dihitung dari durasi ketikan, baca, dan kecepatan jalan180px/detik: sekitar450,2732,4413,8156px dari spawn. Jarak belum dikonversi ke meter fisik.
- Floating bubble sepenuhnya otomatis dan tidak memiliki handler skip. Space, klik, Enter, dan E tidak mempercepat ketikan atau pergantian halaman. Teks mengetik42karakter/detik, lalu mendapat waktu baca3kata/detik ditambah0.45detik, minimal2detik sesudah teks lengkap. A/D tetap menggerakkan Saka dan Tara tetap mengikuti; E tetap khusus pintu. Pergantian ucapan menunggu halaman sebelumnya selesai dan jeda antarucapan, bukan menimpanya.
- Durasi rencana perjalanan58.92detik menentukan panjang rute11352px dan batas kanan11172. Dengan berjalan terus dari spawn preview565, semua dialog selesai56.23detik pada60fps atau56.33detik pada30fps, sebelum ujung tercapai58.93detik. Spawn alur F5 x440 menambah sekitar0.69detik perjalanan di rute yang sama. Saat pemain berhenti, ucapan aktif tetap selesai otomatis; ucapan berikutnya menunggu progres jarak yang sesuai. Panjang lantai dan jumlah lampu dihitung mengikuti durasi dialog agar penambahan teks nanti tidak memerlukan perubahan panjang manual.
- Backtracking tidak mengulang ucapan; R pada preview meresetnya. Di alur F5 balon berhenti/tersembunyi selama fade, lalu aktif setelah masuk bridge. Masuk ulang ke bridge memulai ulang balon. Setelah pertanyaan kode brankas selesai, on_finish:grandpa_safe meminta controller alur menghentikan gerakan dan membuka pilihan/textbox. Scheduler tidak menghitung jeda selama interaksi tersebut; setelah textbox selesai antrean balon dilanjutkan. Pilihan selesai hanya muncul sekali per run dan ID protective/honest diingat untuk konsekuensi cerita mendatang. Waktu membaca textbox tidak menambah panjang rute. Preview bridge F6 tetap balon saja; kedai belum terpasang.
- Tes work/verify_bridge_floating.gd mencakup input tidak dapat skip, queue, pembicara/anchor kamera, teks muat, gerak/follower, pergantian otomatis, backtracking, dan cleanup saat transisi. work/verify_bridge_pacing.gd menyimulasikan seluruh perjalanan pada30/60fps serta berhenti di tempat dan memastikan13halaman selesai sebelum ujung jalur. Preview di outputs/bridge_floating_tara.png, outputs/bridge_floating_saka.png, outputs/bridge_floating_end.png.

## Prompt panel

```text
Use case: ui-mockup.
Asset type: ONE empty floating-dialogue panel texture for the 2D pixel art game KALA in Godot; used for short remarks above a walking character's head. This is a standalone reusable asset, not an interface screenshot.
Primary request: a small, restrained warm cream speech-bubble BODY ONLY, without the pointing tail. The tail is a separate asset. No nameplate and no portrait frame.
Composition: landscape canvas approximately 1536x512, exactly one horizontally elongated panel, 3:1 overall proportions, centered, modest transparent margin. Rectangular body with small symmetrical stepped pixel corners, straight flat horizontal and vertical edges. Interior contains generous completely empty space for one or two lines of game-rendered text.
Style: crisp deliberate pixel art with a consistent square pixel grid and hard edges. Simple 2D front-facing flat UI skin. Interior uniform muted warm cream #f0e5cc. Thin single dark brown-charcoal outline #352d28, quiet inner light cream rim #faf1dd. Outline must look only 2 pixels thick when this asset is displayed at roughly 360x120 game pixels. No heavy layered borders. Low detail, calm and readable at small size. Neutral palette appropriate to both an ancient historical setting and a cyberpunk city.
Technical constraints: designed for nine-slice resizing: four clean identical corners, perfectly straight simple edges, perfectly flat solid-color stretchable center. Small corners and narrow borders; no marks in the center or along straight edges. Exterior is truly transparent RGBA, fill opaque. No tail, no text, no glyphs, no name tab, no characters, no icon, no layout guides, no checkerboard, no watermark. No navy, cyan, neon, bronze ornaments, glow, gradients, texture, blur, perspective or soft shadow. This is only the blank speech-bubble body, isolated.
```

## Prompt ekor

Gambar panel dipakai sebagai referensi gaya pada generasi ekor.

```text
Use case: ui-mockup.
Asset type: ONE separate pointing tail texture for a Godot floating speech bubble in the KALA pixel art game.
Input image 1: reference image ONLY for the warm cream fill, dark brown-charcoal outline, pale inner rim and stepped pixel style. Do not reproduce its rectangular panel.
Primary request: a small downward-pointing speech bubble tail, isolated on true transparent RGBA background. A broad short inverted isosceles triangle built entirely from clean pixel stair steps, not smooth diagonals. Approximate visible width-to-height ratio 1.6:1. Flat top horizontal OPEN connection edge: NO dark outline across its top, because this cream edge must overlap the bottom border of the rectangular bubble to conceal the seam. Dark brown outline ONLY on the two stair-stepped sloping sides and tiny tip; pale cream inner rim adjacent to those sides. Fill matches warm muted cream of the reference panel.
Composition: square canvas, a single tail centered, relatively large with ample transparent padding. No bubble body, no panel, no other assets. It will be displayed about 24x16 pixels in-game.
Constraints: identical palette and edge style to reference, simple symmetric pixel geometry, crisp edges, flat orthographic 2D. No text, icons, frame, sheet, labels, checkerboard, watermark, navy, cyan, neon, glow, gradient, blur, shadow or scenery. The top connection must stay cream all the way to the top edge of the triangle. Transparent exterior.
```
