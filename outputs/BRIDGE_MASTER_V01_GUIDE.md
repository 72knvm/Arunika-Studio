# Scene 2 — master jembatan v01

Dibuat 10 Oktober 2026 dengan built-in image_gen. Sumber: assets/references/backgrounds/prolog/bg_pro_02_bridge_master_v01.png, 1672×941. Referensi gaya: outputs/room_layer_test.png. Brief cerita: bagian pro_02 dalam docs/STORY_FINAL.md dan docs/KALA_ASSET.md.

Komposisi: fajar oranye, skyline Astanapura, selat, rel maglev, pagar kaca, jalur jembatan datar. Kedai Mak Inah menjadi bagian khusus di ujung jalur nanti.

Status: master untuk review visual, belum layer parallax atau scene Godot baru. Main scene kamar dan sprite karakter tidak diubah. Gambar belum seamless terverifikasi. Matahari, kereta dan lampu masih menyatu; jangan mengulang seluruh gambar sebagai map panjang. Pisahkan sky, skyline, air/rel, bridge, dan lampu terlebih dahulu; kereta dapat menjadi prop bergerak. Uji sambungan tepi layer yang diulang.

Review: jalur terbuka dan datar, palet dekat dengan kamar. Air lebih rinci dan langit lebih bergradasi daripada target flat sederhana, sehingga masih bisa disederhanakan. Posisi kaki sprite perlu disejajarkan dengan lantai saat integrasi.

## Prompt final

```text
Use case: stylized-concept.
Asset type: master background concept for scene pro_02 of the 2D side-scrolling student game KALA. Use reference image ONLY as the established visual simplicity, pixel scale, limited palette and outline style; do not reproduce the bedroom or UI.
Primary request: an EMPTY pedestrian skybridge overlooking the futuristic Indonesian coastal city Astanapura in 2150 at calm orange dawn. A gameplay SIDE VIEW, left-to-right movement. Simple deliberately modest student pixel art with chunky clear clusters, dark outlines, broad flat fills, only one or two shadow tones, minimal detail comparable to the reference room. No painterly/realistic detailing, no dense tiny lights, no complex texture.
Composition: wide 16:9 landscape game camera view, fill canvas edge to edge, no frame, no UI, no lettering. Horizontal steel pedestrian deck occupies bottom 18% of image; flat uninterrupted walk surface at 82% height, constant level across entire width, no slopes, stairs, obstacles or vanishing-point corridor. A waist-high glass railing BEHIND the future characters crosses horizontally from edge to edge, top at 66% image height. Thin dark navy frame, evenly spaced supports and lightly blue tinted transparent panels. Clear open space above deck for chibi Saka/Tara and walking dialogue. No characters.
Depth groups, designed for later separation: (1) simple peach/orange dawn sky, a few broad flat clouds, one pale yellow sun offset to the left; (2) distant muted violet and slate blue rectangular skyline silhouettes with only a handful of larger distinctive futuristic tower shapes; (3) quiet blue coastal strait below skyline with a few horizontal warm reflections and a slim elevated maglev track over water in mid distance, small blue train silhouette; (4) main dark slate steel walkway and transparent railing; (5) sparse foreground accents confined to outer sides: small futuristic cyan-tipped bridge lamp posts, no thick pole blocking middle.
Palette matches bedroom: orange/peach sky, muted violet city, navy/slate metal, sparse cyan accents. Slight dawn haze represented by flat lighter bands, no cinematic volumetric lighting.
Bridge deck and railing structurally repeatable, same height at left and right; do NOT depict an entire bridge as an arch over water, do NOT show entrance/exit or perspective bridge disappearing toward horizon. This is one traversable side-view segment, not an aerial establishing shot. No shop in this first segment; Mak Inah's food stall will be a separate endpoint prop later. No storm, cracks, ruined buildings or purple portal: normal peaceful scene BEFORE tragedy.
Deliver one fully composed opaque master image, not a sheet, not exploded layers, not checkerboard.
```

