# Puing sederhana untuk QTE — v01

Dua tambahan aset untuk ide slow motion saat puing terlempar di fase kabur. Material mengikuti jembatan bencana: indigo, ungu beton, sedikit cyan. Bentuk besar dan detail jarang; tanpa karakter atau latar.

- `prop_pro_03_qte_metal_slide_v01.png`: logam panjang untuk terbang di area tubuh, menghindar lewat slide. Ukuran tampilan awal 420 px lebar dengan rasio gambar dipertahankan.
- `prop_pro_03_qte_concrete_jump_v01.png`: beton rendah untuk terbang dekat kaki, menghindar lewat lompat. Ukuran tampilan awal 240 px lebar dengan rasio gambar dipertahankan.

Pakai file `.tscn` masing-masing untuk langsung memasang sprite dengan AtlasTexture, skala, Nearest, dan material alpha cutout. Root Node2D menjadi titik tengah puing supaya rotasi saat terlempar berpusat pada bendanya. PNG dan `.tres` juga tersedia jika ingin merakit node sendiri. Gerak lintasan, rotasi, slow motion, batas waktu tombol, dan hasil QTE belum diimplementasikan; aset ini siap menjadi inputnya. Tidak ada collider atau prompt tertanam dalam gambar.

Preview di Godot: `qte_debris_preview_v01.tscn` (F6), menampilkan kedua sprite dengan label terpisah. Bentuk sumber tidak dimodifikasi lewat script; AtlasTexture hanya memilih region tampilan. `qte_debris_metadata_v01.json` mencatat dimensi dan batas alpha.

Metode: built-in imagegen, true transparent background, dua permintaan terpisah. Status AI placeholder untuk review sesuai catatan project.

## prop_pro_03_qte_metal_slide_v01

```text
Use case: stylized-concept. Asset type: very simple flying metal debris for a slow-motion SLIDE QTE in a 2D pixel-art game. Input1 damaged bridge floor and input2 small metal debris are STYLE/PALETTE REFERENCES only. Create ONE long narrow rectangular broken steel beam, lying horizontally, flat front face. Its silhouette is about FIVE times wider than it is tall. Slightly jagged blunt broken ends, just one large shallow notch near the right end, broad dark indigo front and a thin muted violet top rim. A single small dull cyan rectangular strip may remain on the left quarter; no circuitry. Do not make a billboard/sign or detailed girder assembly. This solid piece will fly toward the player at chest height, who slides underneath; animate motion and rotation later in Godot. No support legs or cables. Modest transparent padding, whole silhouette centered on a wide landscape canvas. Intended game size420x84px.
Style: extremely simple low-detail pixel-art platformer sprite matching the approved indigo Astanapura bridge. Large flat color regions, just three solid material colors plus a dark outline, hard stepped edges. No grain, gradients, texture noise, glow, glossy effects, fine cracks, tiny chips, complex machinery or many parts. Straight-on 2D side view with only a very shallow top-face strip. True transparent alpha around the silhouette. No characters, shadows, floor, buildings, sky, water, labels, symbols, UI or other objects. ONE object per PNG.
```

## prop_pro_03_qte_concrete_jump_v01

```text
Use case: stylized-concept. Asset type: very simple flying concrete debris for a slow-motion JUMP QTE in a 2D pixel-art game. Input1 damaged bridge floor is STYLE/PALETTE REFERENCE only. Create ONE low squat chunk of broken bridge concrete, lying horizontally, silhouette about2.3times wider than tall. Broad flat violet-grey face, tiny shallow lighter top face, dark indigo underside outline. Shape like a broken thick paving slab with three or four large simple angular corners, not a realistic rock. At most ONE broad dark crack. No pebbles, no exposed rebar, no bolts, no detailed fracture textures. This piece flies low near the player's feet, who jumps over it; motion and rotation later in Godot. Whole object centered with modest transparent padding on landscape canvas. Intended game size240x104px.
Style: extremely simple low-detail pixel-art platformer sprite matching the approved indigo Astanapura bridge. Large flat color regions, just three solid material colors plus a dark outline, hard stepped edges. No grain, gradients, texture noise, glow, glossy effects, fine cracks, tiny chips, complex machinery or many parts. Straight-on 2D side view with only a very shallow top-face strip. True transparent alpha around the silhouette. No characters, shadows, floor, buildings, sky, water, labels, symbols, UI or other objects. ONE object per PNG.
```

