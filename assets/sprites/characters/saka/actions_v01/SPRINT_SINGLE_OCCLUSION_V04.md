# Saka sprint single frame v04 — near/far leg correction

Authoritative user correction: straight leg is near/foreground and lighter; bent leg is far/background and black. Near/far refer to camera depth, not direction of motion. Earlier single-frame v03 swapped colors incorrectly and is superseded by v04.

The light-gray straight leg extends down-left in front of the black bent thigh at the hip. The black bent leg remains behind, knee toward right. Single-frame review only; no existing animation resource or other frame has been replaced.

Method: built-in image_gen edit; transparent alpha preserved, PNG copied unchanged.

Saved asset: assets/sprites/characters/saka/actions_v01/char_saka_sprint_frame03_occlusion_v04.png

Generated source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-12a608a8-c0ae-4ff6-8d92-fb0852a9484c.png

Prompt:

```text
Use case: precise-object-edit. Correct ONLY the layering/occlusion of the two pant legs in this single supplied Saka sprint sprite. VERY IMPORTANT: "front" and "back" mean near/far depth from CAMERA, NOT direction of motion.
IDENTITY OF LEGS:
1. The STRAIGHT leg extending diagonally DOWN-LEFT is the FRONT/NEAR leg. It must be LIGHT CHARCOAL GRAY, visibly OVERLAPPING IN FRONT of the other thigh.
2. The BENT leg with knee projecting RIGHT and foot tucked below it is the BACK/FAR leg. It must be BLACK / very dark charcoal, and its upper thigh must disappear BEHIND the light gray straight leg.
The reference already has the correct general leg COLORS. DO NOT swap those colors. Fix only which leg overlaps the other at the hip and upper-thigh crossing.
Precise anatomy: draw the light-gray near straight leg continuously from the NEAR side of the pelvis beneath the belt, diagonally across the FRONT of the black far thigh, down-left to the existing back-left shoe. The light-gray upper thigh is the uninterrupted foreground shape. Its near edge and outline must cross OVER the black bent thigh. The black bent thigh emerges from BEHIND the light-gray thigh toward the right knee, then folds down-left to the tucked shoe. At the crossing, the black thigh outline must be INTERRUPTED by the gray foreground thigh, never cutting in front of the gray leg. This should clearly read as GRAY STRAIGHT LEG IN FRONT, BLACK BENT LEG BEHIND.
Keep existing straight leg endpoint, bent knee position, both shoes and their locations, limb lengths and overall sprint silhouette. Preserve head, black hair shape, cyan eye, face, white hood, black-white jacket, torso, arms, fingers, belt exactly. Same LOW DETAIL chunky pixel art, flat solid colors, same stepped dark outline. No new highlights, texture, detail, gradients or soft shadows. One full-body character only, faces right, no other frames. True alpha0 transparent background; remove gray preview backdrop. No text, diagram, labels, guides or scenery.
```

