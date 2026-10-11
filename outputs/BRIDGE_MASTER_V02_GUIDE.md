# Scene 2 — master jembatan v02

Dibuat dengan built-in image_gen pada 10 Oktober 2026. File: assets/references/backgrounds/prolog/bg_pro_02_bridge_master_v02.png (1672×941).

Revisi mengikuti sketch pengguna: kota A di kiri, kota B di kanan, laut terbuka di tengah sebagai pemisah, jembatan gantung melintang horizontal. Suasana langit fajar dari v01 dipertahankan, tetapi susunan awan/matahari bukan salinan piksel identik. Skyline menyambung dan rel maglev v01 diganti sesuai komposisi baru. Sketch hanya referensi susunan, bukan tekstur atau warna collage Canva.

Ini master review komposisi, belum pemisahan layer atau integrasi Godot. Layer calon: sky, city_left, city_right, sea, bridge deck/rail/pylons, lamps. Pylon/cable dan deck perlu bergerak bersama jika bagian dari jembatan yang sama. Kota kiri/kanan dan matahari merupakan komposisi khusus lokasi, jangan loop seluruh master karena akan mengulang kedua kota dan dua pylon. Jalur bisa menjadi segmen berhingga dengan kamera mengikuti pemain, sementara layer laut/awan yang dibuat seamless boleh berulang. Karakter dan main scene kamar tidak diubah.

## Prompt final

```text
Use case: precise-object-edit.
Asset: revised master background pro_02 for the 2D side-scrolling game KALA.
Inputs: Image 1 is the user's ROUGH COMPOSITION SKETCH only; borrow its spatial layout and suspension bridge concept, NOT its collage textures, blue daytime colors, white border or clip-art lines. Image 2 is the existing master EDIT TARGET; retain its approved warm orange dawn sky, pale yellow sun, chunky pixel-art simplicity, navy/slate/cyan bridge palette. Change the CITY ARRANGEMENT, WATER OPENING, and BRIDGE STRUCTURE to follow Image 1.
Critical geography: TWO DISTINCT CITY BANKS, city A crowded along the far LEFT edge, city B along the far RIGHT edge. Buildings frame the image at the outer left/right thirds. A broad OPEN BLUE SEA STRAIT in the CENTER separates the two cities, narrowing into a clear distant open sea horizon. Absolutely no continuous city skyline behind the center, no tall building in middle, no land strip connecting both cities across the horizon. Sky behind everything; sea visible in middle and through bridge gaps.
Foreground: one large SIMPLE SUSPENSION PEDESTRIAN BRIDGE connects left city to right city across the full width. Strict gameplay side elevation: deck is level, horizontal left-to-right near bottom 80% image height; visible flat walkway top with a small amount of depth below, room for future chibi characters. Two clean solid navy/slate suspension pylons around x=23% and x=77%, extending up to about y=35%; continuous main suspension cables sag between their tops; sparse vertical hangers descend to deck. Keep pylons visually readable and uncomplicated, not huge baroque towers. Low glass railing at rear of walkway, cyan accents sparingly. This bridge is the playable plane, NOT a distant small bridge. Do not add a second maglev bridge crossing the central sea; remove the old central train/track. No characters, no vehicles.
Composition 16:9, full bleed, no white border, no text or UI. Keep sea as simple broad blue bands with only a few sparse warm horizontal reflection marks, not detailed ripples. Cities use a few slate/violet rectilinear buildings with minimal windows, no intricate greebles. Simple consistent pixel clusters and dark outlines like reference 2; modest student game art. No realistic textures, no collage, no painterly style, no atmospheric render. Calm sunrise before prolog tragedy.
Master is one opaque fully composed image, not exploded layers. Prioritize the sketch's left city / open central sea / right city geography over the old master's continuous skyline. Preserve the orange dawn mood of image 2.
```

