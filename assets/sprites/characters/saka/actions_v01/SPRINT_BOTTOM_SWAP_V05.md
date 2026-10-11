# Saka sprint v05 — swap all bottom-row legs

User correction applies to all four frames 5–8, not only 5–6. Near/far leg identity was swapped: left/back leg is lighter gray foreground and right/front leg is black background, with appropriate overlap at hip. Existing spatial poses and feet positions are retained. Frame 6 received an additional edit to make its gray near leg visible.

Raw sheet: `char_saka_sprint_right_v05.png`, true transparent PNG.

Godot: `saka_sprint_frames_v05.tres`, eight frames,12fps loop. Its frames1–4 use the exact v04 PNG and frames5–8 use v05. This preserves the accepted upper row exactly in the animation resource. The imagegen combined raw PNG can contain small changes outside the edit region; raw source images are preserved and never manually repainted.

Review scene: `saka_sprint_review_v05.tscn`, F6, Space toggles playback. Render: `res://outputs/characters/saka_sprint_review_v05.png`. Gameplay and other action assets are unchanged.

Method: built-in image_gen edit. Selected source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-4ef1a794-46f1-44b7-a651-91ffd0812182.png

Primary prompt:

```text
Use case: precise-object-edit. Transparent pixel-art Saka sprint sheet.
Edit ONLY the PANT LEGS in ALL FOUR BOTTOM-ROW frames (frames5,6,7,8) of this 4-column 2-row sheet. The user explicitly asks a simple SWAP of the two legs' near/far identity, coloring and occlusion, not new poses.
The lighter charcoal GRAY leg means NEAR/FOREGROUND from CAMERA. The nearly BLACK leg means FAR/BACKGROUND from CAMERA. Currently every bottom-row pose has these two leg identities reversed. Swap them in all four bottom cells:
FRAME5 bottom-left: leg stretching LEFT/back becomes LIGHT GRAY near/foreground; leg stretching RIGHT/front becomes BLACK far/background.
FRAME6 bottom-second: leg on LEFT/back/support side becomes LIGHT GRAY near/foreground; bent knee/thigh projecting RIGHT/front becomes BLACK far/background.
FRAME7 bottom-third: straight leg extending LEFT/down/back becomes LIGHT GRAY near/foreground; raised BENT leg/knee projecting RIGHT/front becomes BLACK far/background.
FRAME8 bottom-fourth: bent leg reaching LEFT/back becomes LIGHT GRAY near/foreground; straight leg reaching RIGHT/front becomes BLACK far/background.
In EVERY bottom-row frame, gray LEFT-side upper thigh must visibly OVERLAP IN FRONT of black RIGHT-side upper thigh at hip/crotch. Black far thigh emerges behind gray near thigh; its line is interrupted by the foreground gray thigh. Keep ONE contiguous slim pelvis below the belt; no pasted strips, floating legs or disconnected-looking hip seam. Keep palette shades exactly sampled from existing legs, don't make gray brighter than the original gray.
Keep actual knee locations, leg shape geometry, lengths, left/right foot positions, both sneaker shapes and white markings exactly as supplied. Only swap COLOR and LAYER ORDER of the existing legs. Do NOT mirror characters, exchange shoe locations, change pose, add frames or reposition limbs.
Preserve ENTIRE TOP ROW frames1,2,3,4 unchanged including their latest hip/leg corrections. Preserve head, cyan eye, face, hair silhouette, jacket/hood, arms, gloves, hands, torso, belt and shoes in ALL eight frames. Same canvas1774x887, 4x2 layout, figure scales, anchors, baseline, very simple chunky stepped pixel art and flat limited palette. No new outfit details, gradients, glow, shadows, motion streaks, lettering, numbers or borders. Genuine alpha0 transparent background; no scenery. Exactly eight full-body sprites.
```

Frame6 follow-up:

```text
Use case: precise-object-edit. Edit ONLY the pant leg in BOTTOM ROW COLUMN 2 of this 4x2 eight-frame Saka sprint sheet, which is FRAME6. Preserve other SEVEN frames exactly.
Frame6 (bottom-second) mistakenly has BOTH legs nearly black. The supporting leg on LEFT, with the shoe at the very bottom baseline, is the NEAR/FOREGROUND leg and must be LIGHT CHARCOAL GRAY exactly like the left-side near leg in adjacent bottom frames5,7,8. The raised bent leg/knee pointing RIGHT with the tucked shoe above the floor is the FAR/BACKGROUND leg and must remain BLACK.
Recolor the ENTIRE existing LEFT SUPPORT pant leg charcoal GRAY, starting from its hip root just beneath jacket and belt, its diagonal upper thigh running down-left, and its shin reaching the lowest support sneaker. Draw this gray supporting thigh IN FRONT OF the black bent thigh at the crotch. The black bent right thigh is partly occluded by gray foreground leg, not pasted above it. The gray support shin/ankle should be clearly visible down to the lowest shoe. Do not recolor the raised RIGHT-facing bent knee gray. No new leg, no added stripe, no skinny gray seam only: the actual support-leg surface must be gray.
Maintain EXACT existing pose geometry of frame6, knee and foot locations, pants lengths, both black/white sneakers, hips connected to belt, torso, arms, hands, hair, face, eye and all outfit details. Do not change skin or shoes. The only corrections are GRAY left support leg and correct front-layer overlap.
Keep frames1,2,3,4,5,7,8 untouched. Canvas1774x887, true alpha0 transparent background, same chunky simple pixel art, same dark stepped outlines and flat palette. No gradients, new details, labels, text, shadows, checkerboard or background. Exactly eight sprites.
```

