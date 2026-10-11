# Scene 2 — master jembatan v03

Dibuat dengan built-in image_gen pada 10 Oktober 2026. File: assets/references/backgrounds/prolog/bg_pro_02_bridge_master_v03.png.

Revisi berdasarkan tanda putih pengguna: bangunan besar mengisi sisi kiri/kanan dari tepi atas hingga di belakang railing. Laut terlihat melalui celah tengah, bukan membentang di depan kedua city. Langit fajar dan jembatan v02 tetap menjadi acuan, namun generasi tidak menjamin piksel identik.

Status: master review, belum layer atau integrasi Godot. Jangan loop seluruh master; kota dan pylon bersifat komposisi lokasi. Perlu pemisahan city_left/city_right, sky, sea, bridge, dan lampu. Bangunan tampak lebih dekat dan lebih padat; masih bisa dikurangi detail jendelanya sesuai target sederhana. Main scene dan karakter tidak berubah.

## Prompt final

```text
Use case: precise-object-edit.
Edit the composition of the KALA dawn suspension bridge pixel-art background.
Input 1: user's WHITE-MARKED annotation, a layout guide only. The white curved strokes bound the LEFT CITY AREA and RIGHT CITY AREA. They are NOT objects to draw.
Input 2: clean original image, EDIT TARGET.
Change ONLY the two city areas and their coverage. Keep the orange dawn sky, pale yellow sun, central sea, suspension bridge pylons/cables, glass railing, lamp posts and level walkway composition as closely as possible.
MANDATORY correction: cities are not small remote skylines perched on the sea horizon. They are LARGE NEARBY BUILDING FACADES filling the outer LEFT and RIGHT regions ALL THE WAY DOWN behind the bridge and visible through the outer glass panels. The city is a tall urban wall on either side of a central sea channel. Buildings extend from the TOP edges right down to the bridge's walkway level, their bottoms hidden by the deck. Far-left/far-right tall towers cropped by top/side canvas. Inner city contours step down toward center following the white annotation. Left city fills x=0 to around x=25% at the bottom, and right city fills x=75% to 100% at bottom, with inward edges near the bridge pylons. At upper heights the city narrows to outer corners. NO WATER STRIP between side buildings and the bridge. Replace all left-side and right-side water behind outer railing panels with continuous solid building walls/lower urban blocks. The dark city facades should occupy the full side columns down to y=81%, even behind cables and glass. Side building windows continue DOWN below sea-horizon height, making it unmistakable these are nearer high-rises, not buildings on distant islands.
The blue SEA appears ONLY in the OPEN CENTRAL GAP x roughly25%-75%, from its horizon near y52% down to the bridge. This central opening looks along a sea strait between city walls. No skyline across the center. No city islands separated from us by water in the left/right side columns.
Style: preserve modest simple chunky pixel art, navy/slate/violet city palette, sparse large rectangular windows, very few details. No realistic texture or intricate tiny windows. No white strokes, borders, letters, UI, characters or maglev train. Wide 16:9 full bleed opaque master.
Summary of visual change: fill the whole left and right sides with MUCH LARGER CLOSE-UP CITY BUILDINGS from upper edges to behind the railing, leaving only the center as sea. Do not return the same distant skyline arrangement.
```

