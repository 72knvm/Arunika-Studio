# Saka sprint v04 — waist connection

User flagged a disconnected-looking waist/pelvis in frames 3–4. This revision rounds and joins the upper gray thighs to one continuous pelvis under the belt, keeping the approved near-gray/far-black leg order and existing leg poses.

Method: built-in image_gen edit of combined v03 sheet, with the user's cropped image as a problem reference. PNG copied unchanged. Imagegen may alter some pixels outside the requested region; prior assets remain available.

Source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-272fa250-e234-4697-a0a9-f003ea919819.png

PNG: `char_saka_sprint_right_v04.png`

Latest resource: `saka_sprint_frames_v04.tres`, 8 frames, 12 fps, loop. Review: `saka_sprint_review_v04.tscn`, F6 and Space. This independent preview consumes v04; the existing gameplay controller and v01 action preview are unchanged.

Full render: `res://outputs/characters/saka_sprint_review_v04.png`. Hip detail render: `res://outputs/characters/saka_sprint_waist_detail_v04.png`. Review labels are outside the raw sprite asset.

Prompt:

```text
Use case: precise-object-edit. Asset: transparent 8-frame Saka sprint sprite sheet, 4 columns x 2 rows.
Image1 is the full current sheet to edit. Image2 is a zoomed problem reference showing the hips of frames3 and4; it contains preview smudges that must NOT be copied.
Fix ONLY the waist-to-pelvis-to-thigh connection in TOP ROW frames3 and4 (third and fourth columns). Their gray foreground upper thighs currently look like detached pasted strips attached to the belt instead of pants naturally wrapping a pelvis. There is a sharp disconnected-looking seam/outline at the belt and hip root.
Required local anatomy correction: make ONE continuous pants/hip mass directly below the existing gray belt, with a compact rounded hip volume that matches Saka's existing slim torso width. Both upper thighs must grow naturally out of this SAME pelvis. Smooth the outside contour from jacket/waist down to hip then thigh; connect broad areas, not a point. Remove the sticker-like full black border across the top of the gray foreground thigh. Replace it with a clean short internal crotch seam and appropriate near/far overlap ONLY where the two thighs actually separate. The waistband lies naturally on top of the hips without transparent slit, gap, floating belt, separated leg socket, or abrupt cutout shape. Simple flat dark charcoal pants material beneath belt, brighter gray near thigh transitions into the pelvis, almost-black far thigh hidden partly behind. Do not draw giant hips, armor, new details or folds. Keep original slim proportions.
CRITICAL preserve approved leg layering and colors:
Frame3: LIGHT gray STRAIGHT leg reaching diagonally down-left is the NEAR/FOREGROUND leg, in front of BLACK BENT knee/leg reaching right.
Frame4: LIGHT gray BENT leg reaching left/back is the NEAR/FOREGROUND leg, in front of BLACK STRAIGHT leg reaching right/front.
Do NOT exchange these colors, depths, leg poses or directions. Only improve their common upper hip connection. Keep knees, feet, ankles, shoes and all lower-leg lengths at EXACT current locations. Preserve head, face, cyan eye, hair, hoodie, jacket, arms, hands, gray belt/buckle exactly. Preserve all six other frames1,2,5,6,7,8, canvas1774x887, 4x2 layout, positions, head size, simple chunky pixel art, flat palette, stepped dark outline thickness. No gradients, no shadow/glow, no smudges, no increased detail, no background, no lettering or numbering. Genuine alpha0 transparent background. Exactly eight complete sprites.
```

