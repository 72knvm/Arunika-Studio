# Bridge cyberpunk v01

Revisi alur aktif 11 Oktober 2026: **F5** menjalankan tes bridge → kedai, dengan pilihan brankas dan transisi ke scene kedai terpisah. **F6** pada `prolog_flow.tscn` menjalankan alur lengkap dari kamar. Latar/kamera/geometri bersama berada di `waterfront_walk_scene.gd/.tscn`; batas gerak bridge berhenti sebelum badan kedai dan sesudah seluruh percakapan selesai. Lihat `outputs/BRIDGE_KEDAI_FLOW_GUIDE.md` untuk instruksi terbaru. Ukuran rute dan cara F5 pada riwayat revisi latar di bawah sudah digantikan oleh alur ini.

Master pengguna: C:/Users/marvi/OneDrive/Documents/arunika-studio/assets/sprites/backgrounds/prolog/bridge/cyberpunk_v01/bg_pro_02_bridge_master_v01.png.

Kelima aset aktif berada di C:/Users/marvi/OneDrive/Documents/arunika-studio/assets/sprites/backgrounds/prolog/bridge/cyberpunk_v01/:

- bg_pro_02_sky_t0.png — langit opaque, 1672×941.
- bg_pro_02_sea_t1.png — laut, 1672×941; AtlasTexture mulai y578.
- bg_pro_02_city_t2.png — panorama kedua bank kota, 1672×941; alpha cutout0.5.
- bg_pro_02_bridge_t3.png — pagar/lantai, 1672×941.
- bg_pro_02_lamp_t4.png — satu lampu, 1024×1536; alpha cutout0.5.

Dibuat melalui **built-in imagegen** dari master pengguna sebagai edit target. Pemisahan generatif dapat sedikit mengubah garis/warna. Master dan aset bridge sebelumnya tetap disimpan. Pillow hanya membaca alpha, ukuran dan bounding box; tidak mengedit gambar.

## Cara mencoba

F8 lalu F5 mulai di kamar. Jalan ke pintu kanan dengan D dan tekan E untuk masuk bridge. A/D atau panah menggerakkan Saka; Tara mengikuti. Uji langsung: buka C:/Users/marvi/OneDrive/Documents/arunika-studio/scenes/prolog/bridge_layer_test.tscn lalu F6. R reset, 1–5 toggle layer, 6 Saka, 7 Tara, F1 panel.

## Integrasi

Viewport1672×941, rute11352px, batas Saka x120..11172. Panjang rute kini dihitung dari durasi floating dialogue otomatis dan kecepatan Saka180px/detik, bukan lima segmen tetap. Jalan terus dari spawn preview565 membutuhkan~59detik; semua13halaman selesai sekitar56detik, lalu tersisa~3detik jalan. Saka380px, Tara~337px, kaki keduanya y870 pada lantai sempit baru. Lampu610px dengan dasar y828, dipasang setiap1100px hingga menutupi panjang rute yang dihitung.

Langit, laut dan kota memakai skala horizontal yang sama, margin120px per sisi, serta satu offset bersama: speed0.025× kamera dengan drift maksimum120px. Ketiganya bergerak searah dan berhenti bersama pada batas; tidak ada duplikasi maupun extension mirror. Bridge/lampu bergerak bersama dunia1×.

Laut dipotong mulai source y578, lalu ditempatkan pada y554 dan diskalakan vertikal sampai dasar viewport. Overlap ini menutup celah10–20px dari hasil ekstraksi di bawah siluet kota. Skala horizontal yang sama menjaga bank kota, matahari dan refleksi tetap sejajar sepanjang jalur.

Bridge memakai dua AtlasTexture dari PNG yang sama: pagar Rect2(358,701,384,131) dan lantai Rect2(358,832,384,109). Lantai tetap pada y832, sedangkan pagar diperpanjang vertikal dari y630 sampai y832. Puncak pagar240px di atas kaki Saka, sekitar63% tinggi Saka; lebih dekat pinggang dibanding pagar sebelumnya169px. Segmen384px memakai alternating mirror supaya sambungan bertemu pada tepi sumber yang sama. PNG pagar punya kaca opaque: C:/Users/marvi/OneDrive/Documents/arunika-studio/assets/shaders/bridge_glass.gdshader memberi alpha0.42 hanya pada kaca, sedangkan struktur/lantai tetap opaque. AtlasTexture/material tidak mengubah PNG. Segmen menutup rute tanpa gap.

Gerak Saka–Tara dan fade kamar–bridge tetap memakai controller sebelumnya. Dialog, kedai, collision dan endpoint pulau belum ditambahkan oleh revisi latar ini.

## Verifikasi

Godot4.7.2 impor berhasil. work/verify_bridge.gd lulus input, camera, batas/reset, cakupan seluruh jalur, material kaca, lantai opaque, baseline sprite, sambungan pagar/lantai, tinggi pagar terhadap Saka, tidak ada celah sky di bawah shoreline tengah, serta ketiga latar sinkron/tanpa duplikasi/berhenti pada batas. work/verify_prolog_flow.gd lulus setelah revisi. Pengujian follower sebelumnya juga lulus; controller Saka–Tara tidak diubah oleh revisi ini.

Render Forward+/D3D12 awal/tengah/ujung:

- C:/Users/marvi/OneDrive/Documents/arunika-studio/outputs/bridge_start_preview.png
- C:/Users/marvi/OneDrive/Documents/arunika-studio/outputs/bridge_middle_preview.png
- C:/Users/marvi/OneDrive/Documents/arunika-studio/outputs/bridge_end_preview.png

## Prompt set final

### sky

```text
Use case: background-extraction / precise-object-edit. Image 1 is the approved edit target for a Godot side-scrolling parallax game. Preserve its simple flat pixel-art style, limited broad color bands, dark navy outlines, squared corners. No added fine detail, noise, realism, text or characters. Extract/reconstruct ONLY the opaque orange dawn SKY. Full landscape canvas with exact same 1672:941 aspect and framing. Remove ALL buildings, haze city silhouettes, elevated railway, sea, lamps, bridge railing and pavement. Fill their occluded areas with uninterrupted sky. Preserve the stepped yellow clouds and single pixel sun at approximately x=880,y=435, using coordinates of the 1672x941 target. Orange lower sky continues to bottom. Entire canvas opaque.
```

### sea

```text
Use case: background-extraction / precise-object-edit. Image 1 is the approved edit target for a Godot side-scrolling parallax game. Preserve its simple flat pixel-art style, limited broad color bands, dark navy outlines, squared corners. No added fine detail, noise, realism, text or characters. Extract/reconstruct ONLY the SEA layer on transparent full landscape canvas SAME 1672:941 framing. Absolutely everything above source y=576 is transparent; the dark blue water starts at y=576 and fills full width continuously to bottom y=941. Remove all city buildings and seawalls, lamps, rail and pavement and fill occluded lower areas with sea. Keep broad horizontal block reflections: golden orange centered x=880, sparse cyan at sides. No sun disk, sky, coast, buildings, bridge or props. Water below horizon opaque; upper empty area actual alpha transparency. Do not crop or center the water.
```

### city

```text
Use case: background-extraction / precise-object-edit. Image 1 is the approved edit target for a Godot side-scrolling parallax game. Preserve its simple flat pixel-art style, limited broad color bands, dark navy outlines, squared corners. No added fine detail, noise, realism, text or characters. Extract ONLY the finite CITY panorama, preserving positions and full landscape canvas SAME 1672:941 framing. Keep BOTH left and right dense banks of boxy purple/navy skyscrapers, cyan/magenta rectangular billboards, sparse yellow rectangular windows, left elevated maglev railway, purple broad haze shapes and seawalls. Keep small distant city silhouettes near horizon. Remove orange sky, clouds, sun, ALL WATER, foreground bridge railing/pavement and both foreground streetlamps. All removed areas actual transparent alpha including central gap and lower area below seawalls. Reconstruct buildings where lamps blocked them. City remains predominantly far LEFT and far RIGHT with open central sky/water gap. No pasted orange sky between towers, no sea reflections. Keep canvas aligned to original, no floating smaller centered vignette.
```

### bridge

```text
Use case: background-extraction / precise-object-edit. Image 1 is the approved edit target for a Godot side-scrolling parallax game. Preserve its simple flat pixel-art style, limited broad color bands, dark navy outlines, squared corners. No added fine detail, noise, realism, text or characters. Extract/reconstruct ONLY foreground bridge RAILING AND FLOOR on transparent full landscape canvas SAME 1672:941 framing. Entire canvas above source y=703 empty actual alpha transparency. Keep continuous navy outlined railing from y=703 to832 with cyan glass panes and ordinary square navy posts, NO streetlamps or lamp bases. Reconstruct normal railing wherever lamps were. Clear semi-transparent cyan GLASS panels with one broad diagonal highlight each, so city/sea can show through, NEVER bake sun/water reflections inside glass. Thin opaque flat navy floor top band starts exactly y=832 down to891, lower solid fascia down to941. Floor full width opaque, no extra depth/perspective change. Regular repeating square posts and flat paving rectangles suited for horizontal tiling. Remove all sky/city/sea/lamps; no silhouettes, logos or glow outside bridge. Wide full-width foreground lower strip, not a centered isolated object.
```

### lamp

```text
Use case: background-extraction / precise-object-edit. Image 1 is the approved edit target for a Godot side-scrolling parallax game. Preserve its simple flat pixel-art style, limited broad color bands, dark navy outlines, squared corners. No added fine detail, noise, realism, text or characters. Extract ONLY ONE entire cyan streetlamp matching the right-facing arm streetlamps in the target. Portrait canvas transparent background. Single straight dark navy pole, cyan vertical stripe, short bent arm to the RIGHT, rectangular cyan-white light box, small square block base. Complete base and light fully inside canvas, minimal tight padding. Preserve coarse pixel blocks and simple 90-degree corners, no fuzzy glow or shadows. Remove absolutely all railing, floor, sky, city, water and other props. This is one separate transparent game prop, not scenery.
```
