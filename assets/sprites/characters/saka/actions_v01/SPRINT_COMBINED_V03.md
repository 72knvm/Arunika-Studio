# Sprint combined v03

Eight-frame right-facing transparent sprint sheet. Frames 3 and 4 incorporate the latest accepted leg-layer corrections: frame 3 light straight leg foreground, dark bent leg background; frame 4 light bent leg foreground, dark straight leg background. Six remaining poses follow the original sprint sheet. This is imagegen compositing, so pixels in the combined sheet are not guaranteed identical to the input sheets.

Latest PNG: `char_saka_sprint_right_v03.png`.

Godot resource: `saka_sprint_frames_v03.tres`, eight frames, 12fps loop, canvas 1100×520, anchor (550,500), uniform scale 0.81 for comparison with 380px IDLE/WALK.

Preview: `saka_sprint_review_v03.tscn`, F6. Space toggles playback; paused view returns to frames 1–8. Capture: `res://outputs/characters/saka_sprint_review_v03.png`.

Existing earlier versions, jump, slide and gameplay controllers are preserved. Only the independent v03 preview consumes this latest sprint resource.

Method: built-in image_gen compositing. Raw PNG copied unchanged into workspace. Source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-86c11c4c-04cf-4ff3-8903-3dfc273dadab.png

Inputs:
- char_saka_sprint_right_v01.png
- char_saka_sprint_frame03_occlusion_v04.png
- char_saka_sprint_frame04_occlusion_v05.png

Prompt:

```text
Use case: compositing. Assemble the approved Saka sprint frames into ONE transparent 8-frame sprite sheet, FOUR columns by TWO rows, chronological order left-to-right then next row.
INPUTS:
Image1: original eight-frame sprint sheet. Use its frames 1,2,5,6,7,8 unchanged.
Image2: corrected single frame3. Replace top-row third cell with exactly this pose.
Image3: corrected single frame4. Replace top-row fourth cell with exactly this pose.
Important: this is ASSEMBLY, not a redesign. Precisely preserve the supplied sprite designs, faces, hair, clothing, leg shading and thigh overlaps. No new poses, no anatomical reinterpretation, no changing arm swing, no recoloring pants, no increased detail, no brightening. Rescale the two replacement single sprites uniformly to match the head dimensions of original sheet sprites, not to match the entire pose bounding height. All eight head/hair shapes should occupy the same pixel size. Replacement frames were generated larger; reduce uniformly without changing human proportions.
Frame3 must retain image2's LIGHT gray straight leg extending down-left IN FRONT of BLACK bent leg toward right. Gray straight thigh is visibly continuous in foreground across black bent thigh at pelvis.
Frame4 must retain image3's LIGHT gray bent leg extending left/back IN FRONT of BLACK straight leg extending right/front. Gray bent thigh occludes root of black straight thigh at pelvis.
Keep all other six frames as in image1, including their existing colors, outlines, expressions, poses, arm/leg positions and shoes. Same low-detail chunky pixel art and dark outline thickness. No smoothing, no gradients, no extra textures. Each cell has full body with ample transparent space and NO overlap into neighboring cells. Consistent local horizontal head anchor and local foot baseline; airborne feet may rise a little naturally. Make a wide 4x2 sheet, ideally 1774x887. Genuine alpha0 transparent background. NO text, numbers, labels, borders, floor, shadow or motion lines. Exactly eight sprites, no extra frames.
```

