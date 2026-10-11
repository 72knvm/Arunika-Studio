# Sprint v02 — koreksi kaki frame 3 dan 4

Metode: built-in image_gen, edit sheet sprint v01 dengan alpha transparan. Sumber hasil: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-8b396534-3634-46e1-86bc-8fd92bf8b1b6.png

Koreksi: kaki dekat kamera (abu-abu) bergerak ke belakang/kiri, kaki jauh (hampir hitam) bergerak ke depan/kanan pada frame 3 dan 4. Pose dan identitas Saka dipertahankan. Jump disetujui pengguna; slide ditunda, dengan catatan kaki terlalu panjang.

Resource `saka_sprint_frames_v02.tres` menggunakan frame 3–4 dari PNG baru dan enam frame lainnya dari PNG v01. Dengan demikian enam frame di luar koreksi tetap memakai piksel sumber sebelumnya. PNG hasil generasi v02 adalah sheet lengkap; imagegen dapat mengubah beberapa piksel di luar area koreksi. Tidak ada PNG yang disunting manual.

Preview khusus: `saka_sprint_review_v02.tscn`, F6. Delapan frame diberi nomor untuk review, Space menyalakan/mematikan playback. Render: `res://outputs/characters/saka_sprint_review_v02.png`. Nomor hanya ada di preview, tidak di aset mentah. Resource v01, jump, slide dan controller tetap memakai versi sebelumnya.

Prompt:

```text
Use case: precise-object-edit. Asset type: transparent pixel art Saka sprint sheet.
Edit the provided EXACT 8-frame sprint sheet, 4 columns x 2 rows. Change ONLY the TWO PANT LEGS in TOP ROW COLUMN 3 (frame3) and TOP ROW COLUMN 4 (frame4).
Problem: these two frames accidentally reverse the identity/depth of the legs. The NEAR leg is the LIGHTER CHARCOAL GRAY leg, and the FAR leg is the ALMOST BLACK leg. In frames1 and2 the lighter near leg starts forward and then swings BACKWARD.
Required correction in frame3 AND frame4: the leg that extends toward LEFT/back of the running character must be the NEAR/foreground leg, colored the SAME lighter charcoal gray used for the forward near leg in frame1. The leg that bends or stretches toward RIGHT/front must be the FAR/background leg, colored the same almost-black shade as far leg in frame1. At the hip/crotch crossing the LIGHTER GRAY back-swinging near leg visibly overlaps IN FRONT of the BLACK forward-swinging far leg. Keep both legs' existing spatial pose geometry/length and shoe locations. This is a local leg depth/identity correction, NOT horizontal mirroring. In frame3, left/down extended leg=GRAY foreground, right raised knee/foot=BLACK background. In frame4, left/back bent leg=GRAY foreground, right/forward stretched leg=BLACK background. Keep thick stepped dark outlines separating the two legs cleanly.
Preserve frame1,2,5,6,7,8 UNCHANGED. Preserve heads, hair, cyan eyes, face, hood, jacket, arms, hands, belts and shoes in ALL eight frames. No torso changes, no overall recolor, no new pose, no new animation sequence. Same original canvas 1774x887, positions, spacing, dark outlines, very simple flat pixel-art style, broad 1-2 shades per material. Do not add any details. True transparent background alpha0, no checkerboard baked in, no gray halo, no text, no labels, no guides, no watermark.
```

