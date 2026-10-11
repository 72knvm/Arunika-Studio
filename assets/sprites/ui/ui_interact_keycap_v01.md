# Wadah tombol interaksi v01

Asset kosong untuk tutorial dan petunjuk interaksi. Huruf E, F, atau binding lain ditampilkan melalui Label terpisah di Godot.

- PNG: `ui_interact_keycap_v01.png`, 1254 × 1254, RGBA dengan alpha 0–255.
- Resource: `ui_interact_keycap_v01.tres`, AtlasTexture dengan region `(288, 285, 679, 684)` untuk mengabaikan padding transparan.
- Palet: krem hangat, bingkai arang kecokelatan, dan bibir bawah cokelat muda, mengacu pada `ui_floating_text_panel_v01.png`.
- Status: dipasang ke popup interaksi pintu pada alur prolog.

## Pemakaian

Gunakan resource `.tres` pada TextureRect sekitar 40 × 40 atau 48 × 48 px dengan texture filter Nearest. Letakkan Label yang memenuhi area tombol dan rata tengah horizontal/vertikal. Atur teks Label dari binding input agar wadah yang sama bisa menampilkan E atau F. Teks instruksi seperti “Interaksi” dapat diletakkan di sebelah tombol.

Runtime memakai `scenes/ui/interaction_prompt.tscn`: tombol 72 × 72 pada viewport dasar 1672 × 941, sekitar 50 × 50 pada jendela 1152 × 648. Huruf terpisah dari gambar; aksi ditampilkan di bawah. `show_above(karakter, aksi, huruf)` mengikuti kepala Saka dengan jarak 22px di layar, memakai posisi karakter yang diinterpolasi agar selaras dengan gerak dan kamera. `show_at(target, posisi_lokal, aksi, huruf)` tetap tersedia untuk anchor objek. UI dijaga di dalam layar. Alur prolog menampilkannya hanya saat Saka dekat pintu/akses kembali dan tidak sedang dialog atau fade. Tombol tetap E; input F belum ditambahkan. Komponen siap dipakai untuk kursi saat interaksi duduk dibuat.

## Metode dan prompt

Dibuat memakai built-in imagegen, dengan referensi panel floating text dan `transparent_background: true`. PNG asli disalin tanpa modifikasi raster. AtlasTexture hanya memilih region tampilan.

```text
Create a single empty keyboard keycap holder asset for a pixel-art game interaction prompt/tutorial. Use the referenced warm-cream floating dialogue panel ONLY as the palette, border and pixel-corner style reference. One isolated approximately square keycap, straight-on front view, crisp chunky pixel edges, stepped corners, simple warm cream flat face, thin dark brown-charcoal outline, subtle light cream inner rim, and a small muted brown lower lip suggesting a pressed keyboard key shape. Keep the blank central face very spacious to overlay a game-rendered E or F later. No letters, text, glyphs, icons, symbols, decorative marks, multiple buttons or UI sheets. Low detail and readable at 40 to 48 pixels tall. Flat 2D sprite, no perspective, no realistic texture, no gradients, no glow, no navy/cyan. Center the single square object on a square transparent canvas with modest padding; actual transparent alpha background. Match the simple few-color pixel art character of the reference.
```
