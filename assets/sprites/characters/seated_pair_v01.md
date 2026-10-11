# Pose duduk Saka–Tara untuk kedai

11 Oktober 2026. Dibuat dengan built-in imagegen dari `assets/sprites/backgrounds/prolog/kedai/kedai_user_master_v01.png`, tanpa mengubah gambar master. PNG disalin utuh dengan alpha asli; pemilihan region dilakukan lewat AtlasTexture di Godot, bukan pengeditan raster manual.

- Runtime: `assets/sprites/characters/char_saka_tara_seated_v03.png`, RGBA 1774×887.
- Atlas Saka: `saka_seated_v01.tres`, Rect2(404,140,386,717), pivot pinggul (74,515).
- Atlas Tara: `tara_seated_v01.tres`, Rect2(1016,227,419,630), pivot pinggul (288,440).
- `char_saka_tara_seated_v01.png` merupakan draft sebelum koreksi sepatu Saka dan iris cyan.
- V03 memakai sheet idle asli Saka dan Tara sebagai referensi utama desain. Rambut Saka lebih bulat, rambut Tara menjadi charcoal-purple redup; pakaian cropped Tara, kalung, sarung tangan, sabuk dan bentuk sepatu disesuaikan. V01–V02 tetap disimpan sebagai riwayat. Pose hasil generatif belum identik piksel demi piksel dengan sprite jalan.
- Kedai menempatkan pinggul pada marker kursi, memakai proporsi torso dari tinggi karakter jalan. Pasangan duduk pada meja yang sama. Saat Saka duduk menghadap kiri, shader `saka_seated_eye.gdshader` menampilkan iris abu-abu; saat menghadap kanan iris tetap cyan.

## Prompt awal

```text
Use case: background-extraction. Asset type: seated character pair sprite sheet for Godot KALA. Input image is the edit target. Extract ONLY Saka and Tara seated at the first dining table in the lower right. Produce two separate full-body transparent sprites next to each other, Saka on the LEFT facing RIGHT, Tara on the RIGHT facing LEFT, both naturally seated in profile with horizontal thighs and knees bent down, feet visible. Remove absolutely all chairs, tables, bowls, spoons, drinks, food, kiosks, pavement and background. Reconstruct hidden portions of bodies simply: arms bent forward with hands resting just above thighs, no held objects, backs upright, flat soles below bent knees. Preserve black messy hair Saka, long dark-purple hair Tara, white and black jackets, black pants Saka and black shorts Tara, white black shoes, simple low-detail pixel art and dark outlines. Match their existing chibi proportions and colors. Saka is visibly taller than Tara. One static seated pose per character, full bodies not cropped, substantial transparent gap between sprites, aligned foot baseline, crisp pixels, no gradients or tiny decorative detail, no labels, no furniture, no ground, actual transparent RGBA.
```

## Prompt koreksi v02

```text
Use case: precise-object-edit. This transparent seated sprite sheet is the EDIT TARGET. Keep pixel positions, composition, both full seated poses, body shapes, hair, jackets, Tara, transparency and canvas size unchanged. Fix ONLY Saka's shoes: replace every red accent with dark charcoal, so shoes are strictly black/white like Tara's. Fix ONLY Saka's visible eye iris to cool cyan blue (his right Arkeo-Optics eye) with a small dark pupil, not a white empty eye. No extra changes, no new details, labels, furniture, shadows or backdrop. Preserve original alpha transparency.
```


## Revisi v03 mengikuti sprite idle

Built-in imagegen mengedit PNG v02 dengan dua referensi otoritatif: `saka/char_saka_user_idle_right_v01.png` dan `tara/char_tara_user_idle4_right_v01.png`. PNG hasil disalin utuh sebagai v03, alpha asli dipertahankan. Atlas dan pivot pinggul diperbarui agar pose tetap menempel pada kursi. Tidak ada pengeditan raster melalui Python.

Pemeriksaan visual pada `outputs/kedai_seat_1_dialogue.png` dan `outputs/kedai_seat_4_dialogue.png`: rambut gelap, pakaian/gloves/sepatu mengikuti referensi dengan kaki utuh dan pasangan berhadapan. `work/verify_kedai_dialogue.gd` lulus untuk keempat kursi setelah pergantian aset: pemilihan E, meja/makanan, iris Saka, 17 halaman, penguncian gerak/akses kembali dan pemulihan kamera.

```text
Use case: identity-preserve / precise-object-edit.
Asset type: Godot seated character sprite pair, revision of Image 1.
Inputs: Image 1 EDIT TARGET, the current seated sheet; Image 2 authoritative SAKA idle sprite sheet for all design/colors; Image 3 authoritative TARA idle sprite sheet for all design/colors. Use only the FIRST idle character of each reference for visual identity.
Primary request: correct the seated characters to match the idle sprites faithfully in hair color and hairstyle, face, outfit, hands, footwear and pixel detail level. Image 1 supplies ONLY seating pose, placement, framing and transparent background; Images 2 and 3 override its incorrect character designs.
Saka: match the softer rounded messy black hair silhouette from Image 2, dark near-black hair base approximately #181615, cyan right eye, peach skin. White open hoodie/jacket with BLACK short upper sleeves/shoulder panels and WHITE lower sleeves, black inner shirt, gray belt, black/charcoal pants. Hands must wear black fingerless gloves with small exposed peach fingers as in the idle sprite, not fully bare hands. Shoes must match Image 2: compact simple black high-top sneakers, thin white sole with same angular white patch placement; avoid oversized chunky extra-white shoes.
Tara: hair must be very dark muted charcoal-purple approximately #2C2432, matching Image 3 exactly in saturation; absolutely NO vivid violet or bright purple. Preserve her long hair and side fringe, light gray-lavender eye, peach skin. Match her WHITE cropped open jacket with black short shoulder sleeves and white rolled forearm sleeves, BLACK crop top with visible small midriff, small pale cyan necklace, gray belt and black shorts. Add the black fingerless gloves seen in Image 3. Boots/sneakers must match Image 3's slim black/white footwear, dark uppers, modest white soles and angular white marks; NO added white socks or oversized shoe bulges. Use fewer large flat pixel color clusters like the idle references, no realism or added shading.
Pose invariants: still exactly two separated full-body seated sprites, Saka LEFT facing RIGHT, Tara RIGHT facing LEFT. Preserve upright backs, horizontal thighs, bent knees, hands resting on thighs, aligned foot baseline and ample transparent gap. Preserve approximate body bounding boxes and hip locations from Image 1 so existing chair anchors fit. Preserve original canvas 1774x887 if possible. Keep original seated head/body proportions unless a minor correction is required to match the references. No chairs, tables, food, ground, labels, grids, background or extra poses. Genuine transparent RGBA outside and between characters. No glow, gradient, new accessories or extra detail.
```
