# Saka action assets v01 — prompts

Method: built-in image_gen; actual transparent background. Raw selected PNGs copied without pixel manipulation. Existing approved idle and walk PNGs preserved. Right-facing actions only.

References:
- assets/sprites/characters/saka/char_saka_user_idle_right_v01.png
- assets/sprites/characters/saka/char_saka_user_walk8_v02.png

## sprint

Selected source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-75617aae-7c42-4d5a-986c-8e390473f429.png

Initial prompt:

```text
Use case: stylized-concept. Asset type: transparent pixel art animation sprite sheet for a Godot side scrolling game.
Input 1 is the EXACT approved Saka IDLE character design. Input 2 is the EXACT approved Saka WALK design, not a design suggestion. Create new motion frames of this SAME character with exceptionally faithful identity. Strictly reproduce the reference's head silhouette, unruly chunky black hair with forehead bangs and visible ear, small cyan eye looking right, peach face, small pointed profile nose, no mouth emphasis, no beard. White hood around neck, black shoulders/upper sleeves, off-white long lower sleeves, black fingerless gloves with bare peach fingertips, black open center jacket and shirt, narrow flat gray rectangular belt buckle, straight charcoal pants, black sneakers with white sole and little white side patch. No added accessories or gadgets. Same youthful slim proportions and head-to-body ratio as reference walk.
Style must be the same LOW DETAIL chunky pixel art, dark stepped outline, broad flat colors, white cloth, charcoal gray pants, black hair, peach skin, tiny cyan eye ONLY. At most 1-2 broad shades per material. No gradients, no glow, no fine texture, no painterly rendering, no soft outlines, no motion trails, no ground shadow. Do NOT invent a more detailed anime style. All frames face RIGHT in the same side/slight-threequarter profile. The head and hair shape and size, jacket details, limb thickness, shoe shape, colors must be identical in every frame. Preserve true transparent background everywhere outside character. NO letters, labels, numbering, guides, borders, floor, props or background. Full body visible in each cell with clear transparent separation and generous padding. Character silhouette must never touch cell borders.
Action: SPRINT, a complete smooth looping run cycle, eight DIFFERENT consecutive frames in EXACTLY 4 equal columns by 2 equal rows, read left to right top row then bottom row. Landscape sheet. All eight figures have the SAME scale, same head dimensions, consistent foot baseline at the bottom of each cell. Torso leans forward slightly with forceful bent elbow arm pumping and high knee lift. Not a walk cycle. Frame 1 right leg forward contact / left back, 2 recoil and compressed support, 3 passing knee, 4 airborne stride, 5 left leg forward contact / right back, 6 opposite recoil, 7 opposite passing, 8 opposite airborne stride. Arm swing must oppose legs. Footfall phases readable, some frames clearly both feet off ground. Frame 8 leads smoothly into frame 1. Keep the head looking right, rather than at camera. Do not enlarge the upper body or shorten legs.
```

Correction:

```text
Use case: identity-preserve. Edit the FIRST reference image, the 4-column 2-row sprint sheet. Second image is the approved Saka idle identity. Preserve the exact black hair/cyan eye face, same white hood and black/white jacket, gray buckle, charcoal pants, black-white shoes, exact chunky low-detail pixel style and true transparent background. Keep the 4x2 layout, all eight frames facing RIGHT, same head size throughout, top row preserved. Correct ONLY the bottom four frames so they are the OPPOSITE leg and arm phase of the top row. In the bottom row, the NEAR arm (the large white sleeve now behind on the left) must swing FORWARD visibly, elbow bent and fist in front of chest to the RIGHT; the FAR arm must swing BACKWARD with its fist to the LEFT behind hip. Also exchange which leg is forward, preserving perspective differentiation: near pant leg charcoal gray versus far pant leg nearly black. Thus frame5 is opposite foot contact, frame6 opposite recoil, frame7 opposite passing, frame8 opposite airborne. Do NOT duplicate top row poses. Smooth complete cyclic sprint, no glow, no shadow, no motion streaks, no labels. Do not alter identity, outfit or head.
```

## jump

Selected source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-bdd0db5c-eb6e-45aa-b97d-31d8c050b76c.png

Initial prompt:

```text
Use case: stylized-concept. Asset type: transparent pixel art animation sprite sheet for a Godot side scrolling game.
Input 1 is the EXACT approved Saka IDLE character design. Input 2 is the EXACT approved Saka WALK design, not a design suggestion. Create new motion frames of this SAME character with exceptionally faithful identity. Strictly reproduce the reference's head silhouette, unruly chunky black hair with forehead bangs and visible ear, small cyan eye looking right, peach face, small pointed profile nose, no mouth emphasis, no beard. White hood around neck, black shoulders/upper sleeves, off-white long lower sleeves, black fingerless gloves with bare peach fingertips, black open center jacket and shirt, narrow flat gray rectangular belt buckle, straight charcoal pants, black sneakers with white sole and little white side patch. No added accessories or gadgets. Same youthful slim proportions and head-to-body ratio as reference walk.
Style must be the same LOW DETAIL chunky pixel art, dark stepped outline, broad flat colors, white cloth, charcoal gray pants, black hair, peach skin, tiny cyan eye ONLY. At most 1-2 broad shades per material. No gradients, no glow, no fine texture, no painterly rendering, no soft outlines, no motion trails, no ground shadow. Do NOT invent a more detailed anime style. All frames face RIGHT in the same side/slight-threequarter profile. The head and hair shape and size, jacket details, limb thickness, shoe shape, colors must be identical in every frame. Preserve true transparent background everywhere outside character. NO letters, labels, numbering, guides, borders, floor, props or background. Full body visible in each cell with clear transparent separation and generous padding. Character silhouette must never touch cell borders.
Action: JUMP, six distinct ordered motion phases in EXACTLY 3 equal columns by 2 equal rows, left to right top row then bottom row. Same side profile right in every cell, same body scale and exact same head dimensions as reference. Frame1 launch anticipation knees bent modestly and torso forward, frame2 strong upward push-off one foot toe extending, frame3 airborne rise with front knee bent and other leg behind, frame4 compact airborne apex knees bent / feet behind, frame5 descending front foot reaches for landing, frame6 landing absorption crouch with both soles on baseline. Natural jumping arms with bent elbows, no superhero fly, no raised fists over head. These are body POSES, not a vertical trajectory drawn in sheet: keep feet near each cell's common bottom baseline, generous transparent headroom above, whole body within own cell. No floor or impact dust.
```

Correction:

```text
Use case: background-extraction. Edit FIRST reference image, the Saka 3x2 jump sheet. Preserve all SIX characters' pose geometry, outlines, head, hair, face, outfit, size and EXACT same 3 columns 2 rows layout. Remove ONLY ALL soft glowing gray halos/shadows behind each character and ANY background pixels. Every pixel outside the actual dark outline of the character must be true alpha ZERO transparency, including holes between arms/legs. No gray aura or shadow even faint. Characters should be opaque and crisp pixel art. Second reference approved idle identity; do not change characters. No other changes.
```

## slide

Selected source: C:\Users\marvi\.codex\generated_images\01a1291c-d8a5-7cf1-a696-f914be33df4c\exec-33ec121a-1871-450a-bbd5-0a615fbe8da5.png

Initial prompt:

```text
Use case: stylized-concept. Asset type: transparent pixel art animation sprite sheet for a Godot side scrolling game.
Input 1 is the EXACT approved Saka IDLE character design. Input 2 is the EXACT approved Saka WALK design, not a design suggestion. Create new motion frames of this SAME character with exceptionally faithful identity. Strictly reproduce the reference's head silhouette, unruly chunky black hair with forehead bangs and visible ear, small cyan eye looking right, peach face, small pointed profile nose, no mouth emphasis, no beard. White hood around neck, black shoulders/upper sleeves, off-white long lower sleeves, black fingerless gloves with bare peach fingertips, black open center jacket and shirt, narrow flat gray rectangular belt buckle, straight charcoal pants, black sneakers with white sole and little white side patch. No added accessories or gadgets. Same youthful slim proportions and head-to-body ratio as reference walk.
Style must be the same LOW DETAIL chunky pixel art, dark stepped outline, broad flat colors, white cloth, charcoal gray pants, black hair, peach skin, tiny cyan eye ONLY. At most 1-2 broad shades per material. No gradients, no glow, no fine texture, no painterly rendering, no soft outlines, no motion trails, no ground shadow. Do NOT invent a more detailed anime style. All frames face RIGHT in the same side/slight-threequarter profile. The head and hair shape and size, jacket details, limb thickness, shoe shape, colors must be identical in every frame. Preserve true transparent background everywhere outside character. NO letters, labels, numbering, guides, borders, floor, props or background. Full body visible in each cell with clear transparent separation and generous padding. Character silhouette must never touch cell borders.
Action: LOW FEET-FIRST SLIDE toward RIGHT for passing underneath debris, four distinct consecutive poses in EXACTLY 2 equal columns by 2 equal rows on a wide landscape sheet. Every cell is wider than tall. Low body silhouette ~one third of standing height, roughly 2.5-3 times as wide as tall. Preserve ORIGINAL human anatomy and exact original head size: achieve low height through pose, NEVER squash/stretch the character. Frame1 entering slide: hips low, one leg extending forward right, torso strongly reclines, rear knee tucked. Frame2 sustained slide: one straight leg extends right, other bent close, hips nearly ground, torso reclined back left, head still faces right. Frame3 sustained slide with very small natural variation of rear arm/hood and tucked knee. Frame4 recovery begins but remains LOW with front leg retracting and rear hand near ground, head never rises to standing height. The black-haired head lies on the left half of silhouette, shoes on the right; bare face and CYAN eye still visible. Clear white sleeves and original white hood, fingerless gloves, gray belt visible. All four same scale with pelvis/shoes grounded at the same local baseline. No dust, streaks, props, obstacles, upright kneeling or standing frames.
```

Correction:

```text
Use case: identity-preserve. Edit FIRST reference image, four Saka feet-first slide poses 2x2. Second reference is approved Saka idle design. Preserve the EXACT same character identity: black shaggy hair, cyan eye, peach skin, off-white hood and sleeves, black upper sleeve panels, fingerless gloves, gray buckle, charcoal pants, black sneakers with white soles. Same very simple chunky pixel art, dark stepped outline, no extra details. Correct the POSE ONLY in ALL four cells: Saka must recline MUCH further backwards, torso almost horizontal, shoulders and head only slightly above hips. He is doing a very LOW limbo-like feet-first slide under a low obstacle, NOT seated upright. Head remains on the left, shoes extend right. One leg straight, other tucked, one hand trailing near ground behind head/shoulder, other near torso. Entire silhouette HEIGHT no more than 1.15 times the black-hair-to-chin HEAD height, width about 4 times height. Head size anatomically unchanged, never squash the drawing. Head looking to RIGHT, face recognizable, head and chest both very close to floor level. Keep four subtle phases: entry, low hold, low hold variation, low recovery. ALL frames remain comparably low. Same scale each cell, 2 columns 2 rows generous transparent padding. Pure alpha0 transparency outside the character, no floor, no dust, no motion lines, no shadow, no text.
```

