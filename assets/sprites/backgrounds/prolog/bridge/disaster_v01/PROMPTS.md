# Prompt aset bencana jembatan v01

Metode: built-in imagegen. Semua PNG disalin ke folder ini tanpa modifikasi raster. Referensi utama: layer `cyberpunk_v01` yang sudah disetujui. Karakter hanya ditinjau untuk skala, tidak diberikan sebagai input generator.

## bg_pro_03_sky_t0_v01

```text
Use case: lighting-weather.
Asset type: opaque standalone SKY ONLY parallax background for the disaster escape on Astanapura bridge, 2150.
Input image 1 is the exact approved morning SKY layer and edit target. Preserve its 1672x941 canvas, camera, cloud band spacing, open center and central sun location (approximately x=875,y=440). Change ONLY the weather and lighting: dark violet/indigo sky, broad low-detail purple storm clouds occupying the old morning cloud bands, a few angular pale lavender fractures of anomalous light in the upper and central sky. Keep the old sun mostly obscured as a very dim muted violet disc at its former location so the scene clearly continues from morning. The central light fracture can provide a restrained lavender reflection source later. Whole canvas is opaque sky, including below the horizon; do not draw a horizon line or ground.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
No city/buildings, sea/water, bridge, railing, lamps or objects. Not a complete scene. No photoreal clouds, no particle clutter, no fine grain, no intricate lightning webs. Same exact 1672x941 image size as the target.
```

## bg_pro_03_city_t2_v01

```text
Use case: precise-object-edit.
Asset type: standalone DESTROYED CITY transparent parallax layer.
Input image 1 is the exact approved city cutout/edit target; image 2 is the new disaster sky, LIGHTING REFERENCE ONLY, must NOT appear in output.
Keep the exact 1672x941 canvas, every building footprint, camera, framing, relative size and left-right city groups of image 1. Keep the open central channel and transparent sky around all buildings. Keep the shore bases at original y~575-612, and the bottom third entirely transparent. Do not redesign or relocate this city.
Damage some EXISTING building tops with large simple jagged broken silhouettes, missing upper storeys and 2 or 3 broad exposed slab cuts; leave many structures recognizable. Crack and break the elevated maglev on the LEFT in the same old diagonal location. Keep the LEFT magenta cyan-circle billboard and RIGHT blue cyan-circle diagonal billboard in their existing locations but damage their top edges/screens. Some cyan lights go dark; leave a few cyan strips and muted amber windows. Apply dark violet storm lighting matching image 2. No enormous fires, no smoke hiding the skyline, no floating debris outside the city.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
Deliver ONLY city silhouettes with genuine transparent alpha wherever sky and sea were empty. Do NOT paint the purple sky, water, bridge, railing, street lamps, ground or characters. Preserve original exact resolution1672x941.
```

Koreksi generasi:

```text
Use case: precise-object-edit. Correct ONLY the alignment of this destroyed city transparent layer.
Image 1: destroyed city edit target. Image 2: original approved undamaged city, exact camera/geometry alignment reference.
Output canvas EXACT1672x941. Match image2's shoreline: left and right seawall bottom at y=612, center distant city baseline at y=578. In image1 the city base is too low (~666). Move the damaged city forms UP to those exact old base lines, while fitting the old landmark positions: left magenta cyan-circle billboard in x298..365,y44..260, right blue cyan-circle diagonal billboard in x1392..1464,y83..293. Keep damage, jagged broken towers, storm-purple palette, cracked maglev and same sparse detail. Use image2's layout as the invariant; damage its roofs and walls, not a new city layout. Keep bottom y613..940 entirely transparent. Keep open center sky and spaces between buildings truly transparent. ONLY CITY, no sky, water, bridge, lamps, characters. Do not add detail.
```

## bg_pro_03_sea_t1_v01

```text
Use case: lighting-weather.
Asset type: SEA ONLY transparent parallax layer for Astanapura bridge disaster.
Input image 1 is the approved sea cutout/edit target, image 2 the new storm SKY, illumination reference only.
Preserve EXACT 1672x941 canvas, horizontal sea horizon at y=578 (61.42% height) and the entire water footprint through the bottom edge. Everything ABOVE y=578 must be genuinely transparent, not purple sky, not black paint. Do not shift the horizon. Preserve the original sparse, broad horizontal pixel reflection bands and same central reflection axis x~875. Recolor the water into deep indigo-violet under purple storm light, replace the orange sun-reflection with muted lavender and magenta broken horizontal bands, retain a few scattered cyan city-light reflections in the same left/right positions. Make slightly rougher water using only broad horizontal bars; no huge waves, no realistic foam.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
ONLY water. Absolutely no city, shore architecture, clouds, sky, sun, bridge, railing, lamps, boats, rubble, text or people. True alpha transparent above the water. Match exact original resolution.
```

## prop_pro_03_floor_repeat_v01

```text
Use case: precise-object-edit.
Asset type: reusable DAMAGED WALKABLE BRIDGE FLOOR segment, transparent PNG, NOT a complete bridge.
Input image1: approved bridge floor+railing cutout, exact design/scale reference and edit target. Input image2: storm sky palette only.
Produce a 1672x941 canvas preserving ONLY the floor strip occupying x0..1671,y832..940. Everything y0..831 MUST be fully transparent, remove ALL glass rail, posts, lights. Keep the old floor's narrow shallow trapezoid paving top, front curb at y~889 and indigo vertical front fascia through941. Same camera/pixel scale; NOT an isometric standalone platform and NOT a floating island. Full-width continuous floor connects flush to both left/right canvas edges. Add 4-6 broad sparse cracks and small chipped curb corners, some misaligned slab joints, purple-grey damaged concrete with dark indigo shadow and muted violet highlights. WALKABLE TOP remains level, intact and clearly legible, NO HOLES in this repeating safe segment.
For repeating use, make the outermost 80px on both left and right plain matching material, identical flat level y832 top and y889 curb line; keep cracks within the interior so seams can align. No vertical end caps at the left/right crop boundaries. No rubble, no railing, no supports, no background, no characters.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
True transparent alpha above floor; exact1672x941.
```

## prop_pro_03_chasm_edge_left_v01

```text
Use case: stylized-concept.
Asset type: LEFT BANK of collapsed bridge gap, one isolated transparent modular floor-end sprite.
Image1 approved bridge design reference, image2 damaged FLOOR material reference. Draw ONLY a short indigo/violet walkway deck strip. Left side of the sprite is a clean vertical joining edge leading into intact bridge; RIGHT end is the abrupt ragged BROKEN edge facing the missing gap. Flat still-walkable surface leads from the left to the right fracture, with shallow paving top and front curb/fascia matching the reference floor. Right end has 2 or 3 large angular concrete bite-outs, a dark exposed inner fracture face and two short bent rebar ends protruding slightly RIGHT into transparent space. The broken end must be unmistakable and not look like a staircase. Do not draw the opposite bank or the whole chasm; Godot will leave an empty interval after this sprite.
Object proportions: a short strip about 300 game pixels wide and 109px high with minor rebar protrusions, same shallow straight-on bridge camera, full object visible, modest padding on a wide transparent canvas. It is NOT an isometric island or deep massive floating rock. No railing, glass panels, lamp, water, city, sky, shadows outside the object, particles or characters.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
One LEFT bank sprite, true alpha transparency around it.
```

## prop_pro_03_chasm_edge_right_v01

```text
Use case: stylized-concept.
Asset type: RIGHT BANK of collapsed bridge gap, one isolated transparent floor-end sprite.
Input image1 LEFT-bank sprite is exact material/camera/pixel-style reference, not output orientation. Make its matching RIGHT-bank counterpart: ragged broken end must face LEFT into missing gap, and a clean vertical joining end faces RIGHT into the intact floor. Single narrow bridge deck strip, shallow paving top/front curb and indigo fascia. A few large angular concrete bite-outs and two short bent rebar tips protruding LEFT. All damage concentrated at left end, right end plain continuous joining material. Keep same purple-grey concrete, 2-3 tones and simple broad cracks. Entire short strip visible, ample transparent padding; no second bank, no baked hole/chasm fill, no floor background below it, no rail, lamp, water, city, sky, characters or labels. Compact short floor-end shape, width about 3 times the height. Do not draw long intact span.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
Genuine transparent alpha; match first reference pixel contour thickness.
```

## prop_pro_03_rail_broken_v01

```text
Use case: precise-object-edit.
Asset type: ONE broken glass bridge railing segment, separate transparent foreground prop.
Image1 approved bridge railing/floor is exact design reference; image2 new storm sky is palette only. Isolate just ONE short railing segment with two familiar chunky dark indigo rectangular posts and cyan glass between them. No floor whatsoever. Keep the approved sparse geometric panel and post design. Damage it: one post tilted slightly outward with broken top, top horizontal rail snapped toward its center, glass has a large missing triangular portion with a few simple angular fracture lines. Some glass remains faintly translucent pale cyan/turquoise; open missing areas true transparent alpha. Base metal runner also interrupted once. One cohesive broken railing fragment, not two disjoint illustrations and not an asset sheet. Straight-on side view with shallow original perspective, target game-space size around384px wide by202px high, full silhouette visible with modest padding on transparent canvas. Low detail, 2-3 tones, chunky sharp pixels. Retain remaining dim cyan strips so it belongs to the old bridge.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
No bridge deck/ground, sea, skyline, storm clouds, lamp, characters, labels or extra scattered debris.
```

## prop_pro_03_billboard_slide_v01

```text
Use case: stylized-concept.
Asset type: ONE toppled HOLO BILLBOARD for a slide-under obstacle, transparent standalone game sprite.
Input image1 approved bridge master is DESIGN reference only: use the blue rectangular holo billboard with cyan circle and diagonal cyan stripe on the right city. Image2 disaster sky is storm lighting reference only. Do not reproduce scenery from either input.
Draw that familiar thick indigo-metal rectangular billboard now rotated HORIZONTAL and tilted only about 5 degrees, toppled across the path. It has a damaged blue/muted magenta holo display, recognizable large cyan circular symbol and broad cyan diagonal stroke, big broken corner, 2 broad cracks and dark patches, no words. A short snapped support arm and a bent cable remain attached BEHIND/ABOVE its rear edge. The main board is wide, around 3 times its height, simple flat 2D front/side view, chunky low-detail pixel art.
Critical gameplay: the lower third of the PNG beneath the board must remain EMPTY TRANSPARENT SPACE, open from the left side all the way to the right side. NO vertical legs, braces, hanging bars, fallen poles, loose cables or rubble extending down into this passage. Do not add a ground platform to explain its support. This is a modular obstacle positioned above the floor separately by Godot. Canvas landscape, whole silhouette visible with generous alpha padding below; intended board game-space size about600x210 and lower edge155px above walking foot line870.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
ONLY billboard with its small snapped upper support. No characters/slide pose, bridge/railing/ground, sky, city, water, captions or UI. Actual transparent alpha.
```

## prop_pro_03_lamp_leaning_v01

```text
Use case: precise-object-edit.
Asset type: damaged bridge streetlamp variation A, one LEANING lamp transparent sprite.
Input image1 exact approved isolated lamp is the design identity reference and edit target; image2 storm sky palette only. Keep the familiar dark-indigo rectangular pedestal, slender rectangular cyan-strip pole, stepped diagonal right-facing arm and long rectangular cyan/white lamp head. Same minimal geometry and outline thickness, no new lamp design. Change only damage/pose/lighting: pole tilted about15 degrees RIGHT from its still-flat pedestal; a kink near the upper joint, lamp head canted slightly downward, one cyan strip interrupted by a dark break, cyan head dimmer with one dark section. Purple storm highlights replace brightest blue highlights. Whole base, tilted pole and head visible, no cropped parts. Simple few-tone pixel contours, no cables except one tiny snapped upper wire if needed. Base flat and aligns to ground when placed. Preserve overall tall proportions; target visual height610px in Godot, same as existing lamp. Transparent canvas with modest margins, ONLY ONE LAMP.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
No floor, city, water, sky, railing, other props, characters, labels, cast shadows, or fuzzy glow halo outside silhouette. Actual alpha transparent.
```

## prop_pro_03_lamp_snapped_v01

```text
Use case: precise-object-edit.
Asset type: damaged streetlamp variation B, one BROKEN lamp stump transparent sprite.
Input image1 exact approved streetlamp is identity/design reference and edit target; image2 storm sky is palette only. Show the SAME indigo rectangular pedestal and lower cyan-strip pole, but snapped at about55% of its original height, with a ragged angular metal break and a short bent wire at its top. The familiar stepped right-facing arm and rectangular lamp HEAD are still partly attached by a bent hinge, hanging diagonally down and RIGHT along the stump's upper side; dark inactive head with only one tiny cyan emergency segment. It must read as one broken lamp object, not a separate detached pole lying far away, not a full-height leaning lamp. Keep base horizontal. Match original block proportions and sparse low-detail 2D pixel style, purple storm highlights. Full silhouette visible with modest transparent padding on a portrait canvas, game-space remaining height about340px compared with intact610px.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
ONLY broken lamp, true alpha background. No ground, bridge, rail, city, water, sky, characters, extra loose props, particles or text. No fuzzy halos outside silhouette.
```

## prop_pro_03_debris_concrete_sheet_v01

```text
Use case: stylized-concept. Asset type: small CONCRETE RUBBLE sprite atlas on genuine transparent background. Image1 is the exact damaged bridge concrete material/style reference. Draw exactly THREE separate small concrete fragments in ONE HORIZONTAL ROW, each centered inside its own equal-width third of a landscape canvas, all around the same vertical baseline, with large transparent spacing between pieces. Left: squat angular wedge. Middle: small broken rectangular slab. Right: short jagged chunk with one tiny exposed rebar tip. Small decoration only, intended widths28..64px in game; keep very simple 2-3 flat tones, violet-grey top face and dark indigo front face, crisp broad chunky pixels, sparse one crack each. Not mountains, not giant floating islands, no gravel piles, no tiny extra chips. Full silhouettes with transparent padding, all three isolated so each third can be selected by AtlasTexture. No text/cell borders, labels, floor, scenery, shadows outside objects or characters.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
```

## prop_pro_03_debris_glass_sheet_v01

```text
Use case: stylized-concept. Asset type: small GLASS SHARDS sprite atlas with genuine transparent alpha. Image1 approved cyan bridge glass is material/style reference only. Draw exactly THREE separate glass fragments in ONE HORIZONTAL ROW, one centered in each equal-width third of a landscape canvas, same vertical baseline, with large transparent spacing. Left: triangular cyan shard. Middle: shallow trapezoid broken panel chip. Right: bent angular polygon shard. Each a simple faint cyan translucent face, dark-blue pixel rim and one broad pale cyan highlight stroke; only2-3 tones. Intended widths20..52px in game, very simple chunky pixel art, full silhouettes with padding, all three isolated for AtlasTexture selection. NO extra specks, no labels, cell borders, text, railing, floor, sky, water, other objects, shadows or characters. True transparent background and slightly translucent glass faces.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
```

## prop_pro_03_debris_metal_sheet_v01

```text
Use case: stylized-concept. Asset type: small METAL DEBRIS sprite atlas, true transparent PNG. Image1 approved indigo lamp is exact metal palette/style reference only. Draw exactly THREE separate small damaged metal fragments in ONE HORIZONTAL ROW, centered one in each equal-width third of a landscape canvas on the same baseline, large transparent gaps between. Left: short bent L-shaped rectangular steel bar. Middle: small indigo jagged panel plate with one muted cyan strip. Right: short bent pipe segment with exposed dark end. Intended game-space widths24..60px, extremely low detail2-3 flat tones, sparse violet highlights, dark indigo contour, crisp broad pixel edges. Full silhouettes with alpha padding, each third independently selectable as AtlasTexture. NO bolts everywhere, tiny extra fragments, piles, labels, cells, text, lamp/other scenery, floor, shadows outside object or characters.
Match the approved Astanapura 2150 bridge art exactly: very low-detail 2D pixel art, broad simple rectangular forms, crisp stepped contours, dark indigo outlines, only 2-3 shading tones per material, sparse large accents, no intricate small texture. Use indigo/navy steel and purple disaster lighting with restrained broken cyan lights, magenta holo accents and a few amber emergency lights. The art must remain readable beside the approved roughly 380px-tall Saka on the 1672x941 game canvas. Absolutely no characters, people, creatures, UI, captions, watermark or baked scenery in isolated object assets.
```

