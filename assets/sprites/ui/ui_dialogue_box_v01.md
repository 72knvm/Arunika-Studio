# Textbox KALA v01

- File: `res://assets/sprites/ui/ui_dialogue_box_v01.png`
- Status: dipasang dan diuji untuk dialog apartemen pada scenes/ui/dialogue_panel.tscn. Artwork masih dapat dirapikan sesudah prolog berfungsi.
- Dibuat 11 Oktober 2026 memakai built-in image_gen.
- PNG RGBA, ukuran aktual 2172 × 724. Sampel sudut luar memiliki alpha 0; sampel tengah bidang krem memiliki alpha 254/255 (hampir opaque).
- Layout: panel dialog lebar di bawah layar, pelat nama di kiri atas. Portrait karakter merupakan aset terpisah, dapat ditempatkan di atas panel dengan torso tertutup panel.
- Nama karakter, isi dialog, dan indikator lanjut dirender sebagai node Godot terpisah. Jangan dibakar ke PNG.
- Usulan awal penempatan pada viewport project 1672 × 941: TextureRect sekitar 1536 × 512, kiri 68, atas 429. Area transparan PNG ikut dihitung dalam ukuran ini. Pertahankan aspect ratio 3:1 dan periksa kembali saat portrait tersedia.
- Usulan area nama relatif terhadap TextureRect: x 180–440, y 105–150. Area dialog: x 90–1420, y 195–370. Ini panduan visual awal, belum pengukuran di engine.
- Gunakan sampling nearest; hindari peregangan tidak proporsional. Nameplate menyatu dengan panel, jadi PNG ini belum merupakan tekstur nine-patch untuk resize bebas.
- Integrasi aktual: AtlasTexture Rect2(63,132,2046,460), ukuran1560×351 pada posisi(56,570), material alpha cutout0.5 untuk halo. Nama, dialog, petunjuk lanjut dirender node Godot terpisah. Teks40px dengan wrap, nama42px, rata tengah pada pelat nama, hint24px. Ucapan apartemen dipecah menjadi12 halaman pendek1–2 baris. Preview outputs/prolog_flow_long_dialogue.png diperbarui; tes memeriksa tinggi konten setiap halaman agar tidak terpotong.
- Referensi suasana: https://www.rpgfan.com/gallery/a-space-for-the-unbound-screenshots/

## Prompt generasi

```text
+Use case: ui-mockup.
Asset type: one isolated transparent PNG dialogue textbox skin for KALA, a 2D pixel art Indonesian narrative game made in Godot. This is an actual EMPTY UI asset, not a screenshot, presentation or mockup.
Primary request: a wide, quiet, friendly pixel art dialogue box inspired by the understated pale dialogue UI mood of A Space for the Unbound, adapted for a fixed bottom-of-screen visual novel panel. Original KALA design.
Composition: landscape canvas approximately 1536 x 512. A single broad horizontal dialogue panel occupies x=32..1504 and y=128..464. A small blank speaker nameplate approximately 272x72 sits above and touches the main panel at its upper left, inset 56 pixels from the main panel's left side. The nameplate is EMPTY. Keep 24+ pixels of transparent padding around the whole silhouette. No portrait frame inside the panel: character bust portraits are separate game objects positioned above the textbox. The whole main panel provides uninterrupted blank space for 3 lines of dialogue.
Style: deliberate clean low-resolution pixel art, crisp stepped corners (small 8px stair steps), consistent pixel grid, limited palette, absolutely flat orthographic front view. Double-line navy border, restrained ivory inner highlight, modest hard pixel shadow offset downward 8px. Cream paper-colored fill #f4ebd5, dark navy outline #152438, secondary blue gray #334155, a tiny restrained muted cyan #06b6d4 accent on the upper right border and the left edge of the nameplate to relate to KALA's technology. Nameplate fill also warm cream. Broad matte even fill for excellent dark-text contrast, almost no texture.
Constraints: fully transparent exterior RGBA background. Panel interior opaque cream. Empty asset only, no lettering, no words, no numbers, no logos, no watermark, no characters, no scenery, no sample text, no baked-in continuation arrow or buttons. No speech-bubble tail since this is anchored to the bottom, no elaborate ornament, no gradients, no glow, no blur, no perspective, no fake checkerboard. Main panel plus attached blank nameplate is ONE cohesive UI skin, not a contact sheet.
```
