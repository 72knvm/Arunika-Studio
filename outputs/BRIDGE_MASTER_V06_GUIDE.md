# Scene 2 — master jembatan v06

Dibuat dengan built-in image_gen pada 10 Oktober 2026. File: assets/references/backgrounds/prolog/bg_pro_02_bridge_master_v06.png.

Edit dari v05: permukaan lantai dipersempit dalam arah kedalaman layar, dengan bagian belakang lantai/pagar bergeser ke bawah. Lebar horizontal tetap penuh. Target prompt pengurangan sekitar sepertiga; hasil generatif tidak menjamin ukuran persis. Secara visual hasil lebih sempit, sehingga perlu dicek bersama sprite Saka sebelum mengunci layout. Kota dan langit tetap acuan; bukan jaminan piksel identik.

Status master visual, belum parallax/seamless/integrasi. Main scene dan sprite tidak berubah.

## Prompt final

```text
Use case: precise-object-edit.
Edit the supplied KALA bridge background. Make ONLY a small geometry correction to the visible foreground walkway floor: reduce its screen-space front-to-back depth by approximately ONE THIRD (keep about two thirds of original depth). Preserve width edge-to-edge, pixel-art style, colors, orange sky, sun, clouds, left/right waterfront buildings, sea, lamp designs, glass railing design, and their scale. Do not zoom out or recompose the city.
The original ground top surface extends from approximately y=730 to y=865 in a 950px-high image (about 135px depth). New top surface should be around 90px deep. Keep foreground front curb near y=865, shift the floor REAR EDGE and railing/lamp bases DOWN by about45px to around y=775. Shift entire railing down together, retaining its height/panel proportions and side lamp height, with coherent feet on rear edge. Extend the existing sea behind this small downward railing movement as needed; everything above is unchanged.
Large slab seam lines on floor become shorter in depth, with matching mild perspective. The broad bottom fascia stays near its existing height/position; do not add a giant vertical concrete wall to consume the removed floor. Floor remains flat, level, clear and continuous across width, enough for future chibi walking characters. No characters.
This is a subtle edit of the same image, NOT a different bridge or background: approximately33% narrower top floor in depth, no change to horizontal span. Simple chunky pixel art, limited shading. Return one opaque master image, same wide framing, no text or UI.
```

