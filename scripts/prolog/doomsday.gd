extends "res://scripts/prolog/waterfront.gd"
## Narrative doomsday: possession, shot-based loss, grief and the walk home.

signal dialogue_requested(stage: String)
signal intro_completed
signal phase_changed(phase: int)
signal pendant_obtained
signal tara_hearing_changed(muffled: bool)

enum Phase { SAFE, FLASH, WARNING, WALK, SEPARATION, HEADACHE, POSSESSION, REACH, IMPACT, MAESTRO, ABSENCE, PENDANT, CRY, DESPERATE, RESONANCE, RESOLVE, COMPLETE, PORTAL_OPENING, ABSORBING, PORTAL_CLOSING }

const SAFE_SECONDS := 1.5
const PRE_FLASH_RUMBLE_SECONDS := 0.72
const WALK_SECONDS := 2.0
const HOME_WALK_SECONDS := 2.75
const HOME_EXIT_RADIUS := 18.0
const ESCAPE_START_X := 4200.0
const CLOSE_FOLLOW_DISTANCE := 145.0
const TARA_BRIEF_LIFT_HEIGHT := 52.0
const MAESTRO_LIFT_HEIGHT := 600.0
const MAESTRO_DISTANCE_SCALE := 0.52
const ART_PADDING := VIEW_SIZE.x
const FOREGROUND_DIR := "res://assets/world/ruins/"
const BACKDROP_DIR := "res://assets/world/ruins/"
const DEBRIS_DIR := "res://assets/props/debris/"
const PORTAL = preload("res://scripts/prolog/portal.gd")
const RUINED_RAIL: Texture2D = preload("res://assets/world/ruins/rail.tres")
# Center-to-center post spacing in the approved atlas crop. Adjacent panels share a post.
const RUINED_RAIL_POST_SPAN := 1327.5
const RUINED_LAMP_LEANING: Texture2D = preload("res://assets/world/ruins/lamp_leaning.tres")
const RUINED_LAMP_SNAPPED: Texture2D = preload("res://assets/world/ruins/lamp_snapped.tres")
const PROP_MATERIAL: ShaderMaterial = preload("res://assets/world/ruins/lamp_material.tres")
const GROUND_MATERIAL: ShaderMaterial = preload("res://assets/world/ruins/floor_material.tres")
const GLASS_MATERIAL: ShaderMaterial = preload("res://assets/world/ruins/glass_material.tres")
const DEBRIS_MATERIAL: ShaderMaterial = preload("res://assets/props/debris/material.tres")
# Approved review sizes keep the pedestal width consistent with the normal lamp.
const RUINED_LAMP_SCALES := Vector2(109.0 / 275.0, 109.0 / 314.0)
const CUTOUT: Shader = preload("res://assets/shaders/cutout.gdshader")
const POSSESSED: Shader = preload("res://assets/shaders/possession.gdshader")
const AURA = preload("res://scripts/prolog/tara_aura.gd")
const CINEMATIC = preload("res://scripts/prolog/cinematic.gd")
const PENDANT: Texture2D = preload("res://assets/items/pendant.tres")
const HOVER_MOTION = preload("res://scripts/prolog/tara_hover.gd")
const HEADACHE: Texture2D = preload("res://assets/characters/tara/headache.png")
const MAESTRO: Texture2D = preload("res://assets/characters/tara/maestro.png")
const LEVITATION: Texture2D = preload("res://assets/characters/tara/levitate.png")
const HEADACHE_REGION := Rect2(327, 228, 730, 828)
const MAESTRO_REGION := Rect2(46, 20, 933, 1434)
# Match the idle torso's horizontal anchor and the low shoe's baseline.
const LEVITATION_ANCHOR := Vector2(147, 567)
const LEVITATION_BODY_HEIGHT := 565.0

@onready var white_flash: ColorRect = $DisasterFlash/White
@onready var separation_thunder: AudioStreamPlayer = $SeparationThunder
@onready var warning_rumble: AudioStreamPlayer = $WarningRumble
@onready var pendant_drop: AudioStreamPlayer = $PendantDrop
@onready var portal_thunder: AudioStreamPlayer = $PortalThunder
@onready var kala_music: AudioStreamPlayer = $KalaMusic
@onready var tara_hearing: AudioStreamPlayer = $TaraHearing
@onready var tara_lift: AudioStreamPlayer = $TaraLift
var phase: Phase = Phase.SAFE
var damaged := false
var flashing := false
var completed := false
var elapsed_safe := 0.0
var elapsed_walk := 0.0
var ruined_art: Node2D
var pose_sprite: Sprite2D
var pose_material: ShaderMaterial
var aura: Node2D
var lightning: Node2D
var debris: Array[Sprite2D] = []
var debris_rest: Array[Vector2] = []
var effects_elapsed := 0.0
var hover_elapsed := 0.0
var maestro_rest := Vector2.ZERO
var pose_rest := Vector2.ZERO
var cinematic: CanvasLayer
var hearing_fade: Tween
var portal: Node2D
var pendant: Sprite2D
var pendant_fall: Tween
var portal_veil: ColorRect
var portal_lightning: Node2D
var debris_pull := 0.0
var portal_shock := 0.0
var reach_sequence: Dictionary = {}
var home_exit_x := 0.0


func _ready() -> void:
	spawn_x = ESCAPE_START_X
	route_length = 4800.0
	camera_lead_ratio = -0.13
	super._ready()
	# Portal/aura use z1, between the scenery at z0 and the actors at z2.
	saka.z_index = 2
	tara.z_index = 2
	tara.follow_distance = CLOSE_FOLLOW_DISTANCE
	saka.facing_left = true
	set_player_spawn(spawn_x)
	_build_ruined_art()
	_build_tara_pose()
	_build_lightning()
	_build_portal_and_pendant()
	var hearing_stream := tara_hearing.stream as AudioStreamOggVorbis
	if hearing_stream != null:
		hearing_stream.loop = true
	cinematic = CINEMATIC.new()
	cinematic.name = "DoomsdayCinematic"
	add_child(cinematic)
	# PrologFlow disables this scene's own physics callback; the child still ticks.
	var hover_motion := HOVER_MOTION.new()
	hover_motion.name = "MaestroHoverMotion"
	add_child(hover_motion)
	$Overlay/Panel/Margin/Rows/Help.text = "DOOMSDAY | A/D: jalan | E / Space / Enter: lanjut dialog"


func _set_phase(next: Phase) -> void:
	phase = next
	phase_changed.emit(phase)


func advance(direction: float, delta: float) -> void:
	if phase == Phase.COMPLETE:
		saka.advance(direction, delta)
		update_camera()
		return
	if phase not in [Phase.SAFE, Phase.WALK]:
		return
	var before: float = saka.position.x
	super.advance(direction, delta)
	# A reading pause or standing still never consumes the walking segment.
	var walking_seconds: float = absf(saka.position.x - before) / saka.move_speed
	if phase == Phase.SAFE:
		if elapsed_safe < PRE_FLASH_RUMBLE_SECONDS and elapsed_safe + walking_seconds >= PRE_FLASH_RUMBLE_SECONDS:
			warning_rumble.play()
		elapsed_safe += walking_seconds
		if elapsed_safe >= SAFE_SECONDS:
			_flash_city()
	else:
		elapsed_walk += walking_seconds
		if elapsed_walk >= WALK_SECONDS:
			_separate_characters()


func _process(delta: float) -> void:
	animate_effects(delta)


func animate_effects(delta: float) -> void:
	# The suspended beat belongs to this shot, never to global Engine.time_scale.
	effects_elapsed += delta * (0.18 if phase == Phase.PORTAL_OPENING else 1.0)
	aura.animate(delta)
	pose_material.set_shader_parameter("pulse", 0.5 + 0.5 * sin(effects_elapsed * 3.2))
	if phase in [Phase.HEADACHE, Phase.POSSESSION]:
		pose_sprite.position.x = pose_rest.x + sin(effects_elapsed * 22.0) * 1.4
	if phase in [Phase.IMPACT, Phase.MAESTRO, Phase.REACH, Phase.PORTAL_OPENING, Phase.ABSORBING]:
		for index in range(debris.size()):
			debris[index].position = debris_rest[index] + Vector2(sin(effects_elapsed + index) * 9.0, -35.0 - sin(effects_elapsed * 1.1 + index * 2.0) * 25.0)
			if phase == Phase.ABSORBING and absf(debris_rest[index].x - portal.position.x) < 700.0:
				var amount := clampf((debris_pull - (index % 3) * 0.06) * 1.2, 0.0, 1.0)
				var side := signf(debris_rest[index].x - portal.position.x)
				var curve := Vector2(side * 90.0, -110.0) * sin(amount * PI)
				debris[index].position = debris[index].position.lerp(portal.position, amount * amount) + curve
				debris[index].rotation = amount * PI * side
				debris[index].scale = Vector2(45, 24) / debris[index].texture.get_size() * lerpf(1.0, 0.15, amount)
				debris[index].visible = amount < 0.98
	if phase in [Phase.FLASH, Phase.SEPARATION, Phase.IMPACT]:
		var intensity := 6.0 if phase == Phase.FLASH else 16.0
		if phase == Phase.IMPACT:
			intensity *= white_flash.color.a
		camera.offset = Vector2(sin(effects_elapsed * 69.0), sin(effects_elapsed * 91.0)) * intensity
		camera.force_update_scroll()
	elif phase in [Phase.PORTAL_OPENING, Phase.ABSORBING]:
		var pull_shake: float = 0.5 + portal.intake * portal.intake * 7.0
		camera.offset = Vector2(sin(effects_elapsed * 31.0), sin(effects_elapsed * 41.0)) * pull_shake
		camera.force_update_scroll()
	elif phase == Phase.PORTAL_CLOSING:
		camera.offset = Vector2(sin(effects_elapsed * 39.0), sin(effects_elapsed * 51.0)) * portal_shock * 18.0
		camera.force_update_scroll()
	# Camera offset applies to both world art and the screen-space backdrop.
	get_node("Backdrop").offset = -camera.offset * camera.zoom


func update_maestro_hover(delta: float) -> void:
	if phase != Phase.MAESTRO:
		return
	hover_elapsed += delta
	tara.position.y = maestro_rest.y + sin(hover_elapsed * 1.7) * 7.0


func _opaque_material() -> ShaderMaterial:
	var material := ShaderMaterial.new()
	material.shader = CUTOUT
	return material


func _add_art(texture: Texture2D, at: Vector2, display_size: Vector2, material: Material = null) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = at
	sprite.scale = display_size / texture.get_size()
	sprite.material = material if material != null else _opaque_material()
	ruined_art.add_child(sprite)
	return sprite


func _build_ruined_art() -> void:
	ruined_art = Node2D.new()
	ruined_art.name = "RuinedArt"
	add_child(ruined_art)
	move_child(ruined_art, tara.get_index())
	ruined_art.hide()
	var floor_texture: Texture2D = load(FOREGROUND_DIR + "floor.tres")
	# Dialogue zoom can see outside the walkable route. Keep art beyond both edges.
	var first_index := int(floor((world_origin_x - ART_PADDING) / 384.0))
	var last_index := int(ceil((world_origin_x + route_length + ART_PADDING) / 384.0))
	for index in range(first_index, last_index):
		var tile := _add_art(floor_texture, Vector2(index * 384.0 - world_origin_x, 832), Vector2(384, 109), GROUND_MATERIAL)
		tile.set_meta("surface", "deck")
		# Continue the deck below the camera when zooming out for the levitation.
		var foundation := Polygon2D.new()
		var top := floor_texture.get_height()
		var bottom := top + 750.0 / tile.scale.y
		foundation.polygon = PackedVector2Array([Vector2(0, top), Vector2(384 / tile.scale.x, top), Vector2(384 / tile.scale.x, bottom), Vector2(0, bottom)])
		foundation.color = Color("24313c")
		foundation.z_index = -1
		tile.add_child(foundation)
	var rail_factor: float = (RAIL_BASE_Y - RAIL_TOP_Y) / RUINED_RAIL.get_height()
	var rail_size: Vector2 = RUINED_RAIL.get_size() * rail_factor
	var rail_step := RUINED_RAIL_POST_SPAN * rail_factor
	for index in range(int(floor(-ART_PADDING / rail_step)), int(ceil((route_length + ART_PADDING) / rail_step))):
		var rail := _add_art(RUINED_RAIL, Vector2(index * rail_step, RAIL_TOP_Y), rail_size, GLASS_MATERIAL)
		rail.name = "RuinedRail%d" % index
		rail.set_meta("surface", "rail")
	var lamp_first := int(floor((world_origin_x - ART_PADDING) / 1100.0))
	var lamp_last := int(ceil((world_origin_x + route_length + ART_PADDING) / 1100.0))
	for index in range(lamp_first, lamp_last):
		var leaning := index % 2 == 0
		var texture: Texture2D = RUINED_LAMP_LEANING if leaning else RUINED_LAMP_SNAPPED
		var factor: float = RUINED_LAMP_SCALES.x if leaning else RUINED_LAMP_SCALES.y
		var size: Vector2 = texture.get_size() * factor
		var lamp := _add_art(texture, Vector2(70 + index * 1100 - world_origin_x, LAMP_BASE_Y - size.y), size, PROP_MATERIAL)
		lamp.name = "RuinedLamp%d" % index
	for index in range(14):
		var texture: Texture2D = load(DEBRIS_DIR + "concrete%02d.tres" % (index % 3 + 1))
		var position_on_deck := Vector2(500 + index * 310, 848 + index % 3 * 6)
		debris.append(_add_art(texture, position_on_deck, Vector2(45, 24), DEBRIS_MATERIAL))
		debris_rest.append(position_on_deck)


func _build_tara_pose() -> void:
	pose_sprite = Sprite2D.new()
	pose_sprite.name = "DoomsdayPose"
	pose_sprite.centered = false
	pose_sprite.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	pose_material = ShaderMaterial.new()
	pose_material.shader = POSSESSED
	pose_sprite.material = pose_material
	tara.add_child(pose_sprite)
	pose_sprite.hide()
	aura = AURA.new()
	aura.name = "ProceduralAura"
	aura.z_index = -1
	tara.add_child(aura)


func _set_tara_pose(maestro: bool) -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = MAESTRO if maestro else HEADACHE
	atlas.region = MAESTRO_REGION if maestro else HEADACHE_REGION
	atlas.filter_clip = true
	pose_sprite.texture = atlas
	# Distant levitation leaves sky between Tara and Saka without shrinking the player.
	var factor: float = tara.display_height * MAESTRO_DISTANCE_SCALE / 1104.0 if maestro else tara.display_height * 0.65 / HEADACHE_REGION.size.y
	var anchor_x: float = MAESTRO_REGION.size.x * 0.5 if maestro else 310.0
	# The headache PNG faces right; mirror it to face Saka on her left.
	pose_sprite.scale = Vector2(factor if maestro else -factor, factor)
	pose_sprite.position = Vector2(-anchor_x * factor if maestro else anchor_x * factor, -atlas.region.size.y * factor)
	pose_rest = pose_sprite.position
	tara.sprite.hide()
	pose_sprite.show()
	aura.position = Vector2(0, -atlas.region.size.y * factor * 0.5)
	aura.radius = Vector2(120, 185) * MAESTRO_DISTANCE_SCALE if maestro else Vector2(80, 100)
	_align_portal_to_pose()


func _show_tara_levitation() -> void:
	var factor: float = tara.display_height / LEVITATION_BODY_HEIGHT
	pose_sprite.texture = LEVITATION
	pose_sprite.scale = Vector2.ONE * factor
	pose_sprite.position = -LEVITATION_ANCHOR * factor
	pose_rest = pose_sprite.position
	tara.sprite.hide()
	pose_sprite.show()
	tara_lift.play()


func _align_portal_to_pose() -> void:
	var body := _sprite_bounds(pose_sprite)
	portal.global_position = body.get_center() + Vector2(body.size.x * 0.24, -body.size.y * 0.20)
	portal.set_radius(body.size * Vector2(0.75, 0.70) + Vector2(30, 24))


func _portal_bounds() -> Rect2:
	var radius: Vector2 = portal.radius * portal.global_scale * PORTAL.EFFECT_MARGIN
	return Rect2(portal.global_position - radius, radius * 2.0)


func set_maestro_anchor(x: float) -> void:
	# A shared world anchor keeps reveal, previews and restored saves at the same height.
	maestro_rest = Vector2(x, FOOT_Y - MAESTRO_LIFT_HEIGHT)
	hover_elapsed = 0.0
	tara.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	tara.position = maestro_rest
	tara.reset_physics_interpolation()
	_align_portal_to_pose()


func _build_lightning() -> void:
	lightning = Node2D.new()
	lightning.name = "SeparatingLightning"
	lightning.z_index = 10
	add_child(lightning)
	var points := PackedVector2Array()
	for index in range(17):
		points.append(Vector2(0 if index in [0, 16] else (28 if index % 2 else -22), -900 + index * 56.25))
	for width in [24.0, 10.0, 3.0]:
		var line := Line2D.new()
		line.points = points
		line.width = width
		line.default_color = Color(0.47, 0.10, 0.9, 0.45) if width > 10 else (Color(0.78, 0.4, 1.0) if width > 3 else Color.WHITE)
		lightning.add_child(line)
	lightning.hide()


func _flash_city() -> void:
	_set_phase(Phase.FLASH)
	flashing = true
	stop_characters()
	var flash := create_tween()
	flash.tween_property(white_flash, "color:a", 1.0, 0.08)
	flash.tween_callback(_apply_damage)
	flash.tween_interval(0.10)
	flash.tween_property(white_flash, "color:a", 0.0, 0.35)
	await flash.finished
	flashing = false
	camera.offset = Vector2.ZERO
	get_node("Backdrop").offset = Vector2.ZERO
	_set_phase(Phase.WARNING)
	dialogue_requested.emit("warning")


func _apply_damage() -> void:
	damaged = true
	sky.texture = load(BACKDROP_DIR + "sky.png")
	sky.material = load(BACKDROP_DIR + "sky_material.tres")
	sea.texture = load(BACKDROP_DIR + "sea.tres")
	sea.material = load(BACKDROP_DIR + "sea_material.tres")
	city.texture = load(BACKDROP_DIR + "city.tres")
	city.material = _opaque_material()
	_fit_backdrop(sky, BACKDROP_SCROLL_LIMIT)
	_fit_backdrop(sea, BACKDROP_SCROLL_LIMIT)
	sea.position.y = SEA_SURFACE_Y
	sea.scale.y = (VIEW_SIZE.y - SEA_SURFACE_Y) / sea.texture.get_height()
	_fit_backdrop(city, BACKDROP_SCROLL_LIMIT)
	city.scale.y = 612.0 / city.texture.get_height()
	bridge.hide()
	lamps.hide()
	ruined_art.show()
	update_camera()


func finish_dialogue(stage: String) -> void:
	match stage:
		"warning":
			_set_phase(Phase.WALK)
		"headache":
			_request_stage("possession", Phase.POSSESSION)
		"possession":
			await _play_reach_cutscene()
		"departure":
			await _vanish_tara()
		"absence":
			await _take_pendant()
		"cry":
			await get_tree().create_timer(4.0, false).timeout
			cinematic.close()
			_request_stage("desperate", Phase.DESPERATE)
		"desperate":
			await get_tree().create_timer(0.7, false).timeout
			_request_stage("resonance", Phase.RESONANCE)
		"resonance":
			_request_stage("resolve", Phase.RESOLVE)
		"resolve":
			await _restore_solo_walk_camera()
			saka.facing_left = true
			saka.advance(0, 0)
			home_exit_x = maxf(saka.left_limit, saka.position.x - saka.move_speed * HOME_WALK_SECONDS)
			saka.left_limit = home_exit_x
			completed = true
			_set_phase(Phase.COMPLETE)
			intro_completed.emit()


func _separate_characters() -> void:
	_set_phase(Phase.SEPARATION)
	flashing = true
	stop_characters()
	# Cutscene movement is rendered each frame, independent of walking physics.
	saka.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	tara.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	lightning.position = Vector2((saka.position.x + tara.position.x) * 0.5, FOOT_Y)
	lightning.show()
	separation_thunder.play()
	white_flash.color = Color(0.87, 0.76, 1.0, 0.85)
	var separation := create_tween().set_parallel(true)
	separation.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	separation.tween_property(saka, "position:x", saka.position.x - 150.0, 0.30)
	separation.tween_property(tara, "position:x", tara.position.x + 100.0, 0.30)
	separation.tween_property(camera, "offset", Vector2(12, -9), 0.06)
	separation.tween_property(white_flash, "color:a", 0.0, 0.35)
	await separation.finished
	lightning.hide()
	camera.offset = Vector2.ZERO
	get_node("Backdrop").offset = Vector2.ZERO
	white_flash.color = Color(1, 1, 1, 0)
	saka.facing_left = false
	saka.advance(0, 0)
	tara.reset_physics_interpolation()
	saka.reset_physics_interpolation()
	# Sit only after Saka asks her to, rather than before the dialogue starts.
	aura.strength = 0.0
	flashing = false
	_set_phase(Phase.HEADACHE)
	dialogue_requested.emit("headache")


func _reveal_maestro() -> void:
	_set_phase(Phase.IMPACT)
	flashing = true
	white_flash.color = Color(1, 1, 1, 0)
	var impact := create_tween()
	impact.tween_property(white_flash, "color:a", 1.0, 0.08)
	await impact.finished
	# Change pose, height and framing only while the impact fully covers the view.
	_set_tara_pose(true)
	pose_material.set_shader_parameter("strength", 1.0)
	set_maestro_anchor(tara.position.x)
	aura.strength = 1.0
	portal.hide()
	cinematic.close()
	await focus_stage_camera("maestro")
	kala_music.play()
	var reveal := create_tween()
	reveal.tween_interval(0.06)
	reveal.tween_property(white_flash, "color:a", 0.0, 0.30)
	await reveal.finished
	flashing = false
	camera.offset = Vector2.ZERO
	get_node("Backdrop").offset = Vector2.ZERO
	camera.force_update_scroll()
	_set_phase(Phase.MAESTRO)
	await get_tree().create_timer(1.5, false).timeout


func sprite_local_rect(sprite: Node2D) -> Rect2:
	if sprite is AnimatedSprite2D:
		var size: Vector2 = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_size()
		return Rect2(sprite.offset - (size * 0.5 if sprite.centered else Vector2.ZERO), size)
	return sprite.get_rect()


func _sprite_bounds(sprite: Node2D) -> Rect2:
	var rect := sprite_local_rect(sprite)
	var first: Vector2 = sprite.global_transform * rect.position
	var result := Rect2(first, Vector2.ZERO)
	for corner in [rect.end, Vector2(rect.position.x, rect.end.y), Vector2(rect.end.x, rect.position.y)]:
		result = result.expand(sprite.global_transform * corner)
	return result


func focus_stage_camera(stage: String) -> void:
	if stage == "cry":
		return
	if stage == "warning":
		await focus_dialogue_camera()
		return
	dialogue_camera_active = true
	var bounds := _sprite_bounds(saka.sprite)
	if stage in ["headache", "possession", "maestro", "departure"]:
		var tara_bounds := _sprite_bounds(pose_sprite if pose_sprite.visible else tara.sprite)
		bounds = bounds.merge(tara_bounds)
		if portal.visible:
			bounds = bounds.merge(_portal_bounds())
	bounds = bounds.grow(25.0)
	# Main text starts below y660; keep bodies clear of it and of the left nameplate.
	var screen_area := Rect2(550, 65, 1060, 550) if stage in ["headache", "possession"] else Rect2(350, 50, 1100, 565)
	if stage == "maestro":
		# Use the full height until the departure textbox appears.
		screen_area = Rect2(230, 50, 1200, VIEW_SIZE.y - 140)
	var zoom_factor := minf(screen_area.size.x / bounds.size.x, screen_area.size.y / bounds.size.y)
	zoom_factor = minf(zoom_factor, 1.25)
	var target := bounds.get_center() + (VIEW_SIZE * 0.5 - screen_area.get_center()) / zoom_factor
	await _move_camera(target, Vector2.ONE * zoom_factor)


func _request_stage(stage: String, next: Phase) -> void:
	stop_characters()
	_set_phase(next)
	dialogue_requested.emit(stage)


func handle_dialogue_event(event: String) -> void:
	match event:
		"tara_sits":
			_set_tara_pose(false)
			aura.strength = 0.35
			pose_material.set_shader_parameter("strength", 0.35)
			await focus_stage_camera("headache")
		"anomaly_surge":
			aura.strength = 0.7
			pose_material.set_shader_parameter("strength", 0.65)
		"tara_recovers":
			aura.strength = 0.55
			pose_material.set_shader_parameter("strength", 0.35)
		"tara_closeup":
			aura.strength = 0.72
			pose_material.set_shader_parameter("strength", 0.75)
			cinematic.show_shot("headache")
			tara_hearing_changed.emit(true)
			tara_hearing.play()
			hearing_fade = create_tween()
			hearing_fade.tween_property(tara_hearing, "volume_db", -13.0, 1.0)
		"tara_levitates":
			# Tara gets up while the close-up covers the change from sitting.
			var standing_sprite: AnimatedSprite2D = tara.sprite
			standing_sprite.flip_h = true
			tara.stop_follow()
			standing_sprite.material = pose_material
			pose_sprite.hide()
			standing_sprite.show()
			aura.position.y = -tara.display_height * 0.5
			aura.radius = Vector2(85, 140)
			cinematic.close()
			if hearing_fade != null:
				hearing_fade.kill()
			tara_hearing.stop()
			tara_hearing_changed.emit(false)
			var lift := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			lift.tween_interval(0.20)
			lift.tween_property(tara, "position:y", tara.position.y - TARA_BRIEF_LIFT_HEIGHT, 0.55)
			lift.parallel().tween_callback(_show_tara_levitation).set_delay(0.08)
			await lift.finished


func _build_portal_and_pendant() -> void:
	portal = PORTAL.new()
	portal.name = "TemporalPortal"
	portal.z_index = 1
	portal.sound_enabled = true
	add_child(portal)
	portal.hide()
	var atmosphere := CanvasLayer.new()
	atmosphere.name = "PortalAtmosphere"
	atmosphere.layer = 70
	add_child(atmosphere)
	portal_veil = ColorRect.new()
	portal_veil.name = "Dimming"
	portal_veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portal_veil.color = Color(0.055, 0.035, 0.09, 0.0)
	portal_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	atmosphere.add_child(portal_veil)
	portal_lightning = Node2D.new()
	portal_lightning.name = "PortalLightning"
	atmosphere.add_child(portal_lightning)
	var stroke := PackedVector2Array([
		Vector2(-35, -32), Vector2(12, 55), Vector2(-18, 165), Vector2(30, 250),
		Vector2(-40, 345), Vector2(18, 430), Vector2(-9, 525), Vector2(45, 620),
		Vector2(-25, 728), Vector2(10, 815), Vector2(-24, 912), Vector2(0, VIEW_SIZE.y + 32)
	])
	for width in [24.0, 8.0, 3.0]:
		var line := Line2D.new()
		line.points = stroke
		line.width = width
		line.default_color = Color(0.45, 0.27, 0.64, 0.5) if width > 8.0 else (Color(0.75, 0.62, 0.89) if width > 3.0 else Color(0.94, 0.89, 1.0))
		portal_lightning.add_child(line)
	portal_lightning.hide()
	pendant = Sprite2D.new()
	pendant.name = "TaraPendant"
	pendant.texture = PENDANT
	pendant.scale = Vector2.ONE * 30.0 / PENDANT.get_height()
	pendant.material = _opaque_material()
	pendant.z_index = 3
	add_child(pendant)
	pendant.hide()


func _play_reach_cutscene() -> void:
	_set_phase(Phase.REACH)
	stop_characters()
	var alarm: Dictionary = reach_sequence.alarm
	# Cut to the reaching pose on Tara's scream, then hold until the impact.
	cinematic.show_shot("wide", "%s: %s" % [alarm.speaker, alarm.text])
	await get_tree().create_timer(float(alarm.seconds), false).timeout
	var grasp: Dictionary = reach_sequence.grasp
	cinematic.show_shot("wide", "%s: %s" % [grasp.speaker, grasp.text])
	await get_tree().create_timer(float(grasp.seconds), false).timeout
	# The impact covers the cut from the hands to the Maestro pose.
	await _reveal_maestro()
	dialogue_requested.emit("departure")


func _play_portal_storm() -> void:
	# Lightning belongs to the surrounding sky, with a clear lane around Tara.
	var tara_center: Vector2 = pose_sprite.get_global_transform_with_canvas() * pose_sprite.get_rect().get_center()
	var random := RandomNumberGenerator.new()
	random.randomize()
	var start_left := random.randf() < 0.5
	for i in range(3):
		var left_side := (i % 2 == 0) == start_left
		var lane := Vector2(100, VIEW_SIZE.x * 0.28) if left_side else Vector2(VIEW_SIZE.x * 0.72, VIEW_SIZE.x - 100)
		var strike_x := random.randf_range(lane.x, lane.y)
		if absf(strike_x - tara_center.x) < 230.0:
			strike_x = 120.0 if tara_center.x > VIEW_SIZE.x * 0.5 else VIEW_SIZE.x - 120.0
		portal_lightning.position.x = strike_x
		portal_lightning.scale.x = random.randf_range(0.8, 1.4) * (-1.0 if random.randf() < 0.5 else 1.0)
		portal_lightning.modulate.a = 1.0
		portal_lightning.show()
		portal_thunder.pitch_scale = 1.18 - i * 0.09
		portal_thunder.volume_db = -11.0 + i * 2.0
		portal_thunder.play()
		var strike := create_tween()
		strike.tween_property(portal_lightning, "modulate:a", 0.0, 0.12)
		await strike.finished
		portal_lightning.hide()
		await get_tree().create_timer(random.randf_range(0.12, 0.20), false).timeout
	# One screen-wide flash ends the storm and precedes the actual opening.
	white_flash.color = Color(0.84, 0.76, 0.94, 0.45)
	portal_thunder.pitch_scale = 0.88
	portal_thunder.volume_db = -4.0
	portal_thunder.play()
	var flash := create_tween()
	flash.tween_property(white_flash, "color:a", 0.0, 0.20)
	await flash.finished


func _vanish_tara() -> void:
	if phase != Phase.MAESTRO:
		return
	_set_phase(Phase.PORTAL_OPENING)
	flashing = true
	stop_characters()
	var music_out := create_tween()
	music_out.tween_property(kala_music, "volume_db", -45.0, 0.65)
	music_out.tween_callback(kala_music.stop)
	cinematic.close()
	white_flash.color.a = 0.0
	tara.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	_align_portal_to_pose()
	portal.show()
	var anticipation := create_tween().set_parallel(true)
	anticipation.tween_property(portal_veil, "color:a", 0.30, 0.45)
	# A dedicated close shot gives Tara and the opening the frame freed by dialogue.
	await _move_camera(portal.position + Vector2(0, 20), Vector2.ONE * 1.45)
	await get_tree().create_timer(0.22, false).timeout
	await _play_portal_storm()
	var opening: Tween = portal.open_portal(0.65)
	await opening.finished
	await get_tree().create_timer(0.12, false).timeout
	_set_phase(Phase.ABSORBING)
	# Brief resistance makes the following acceleration read as a forceful pull.
	var resistance := create_tween().set_parallel(true)
	resistance.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	resistance.tween_property(tara, "position", tara.position + Vector2(-26, 24), 0.30)
	resistance.tween_property(portal, "intake", 0.45, 0.30)
	resistance.tween_property(self, "debris_pull", 0.30, 0.30)
	await resistance.finished
	await get_tree().create_timer(0.10, false).timeout
	var pull_seconds := 0.75
	portal.play_pull_sound(pull_seconds)
	var pull := create_tween().set_parallel(true)
	pull.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	pull.tween_property(tara, "position", portal.position, pull_seconds)
	pull.tween_property(tara, "scale", Vector2.ONE * 0.025, pull_seconds)
	pull.tween_property(aura, "strength", 0.0, 0.65)
	pull.tween_property(portal, "intake", 1.0, 0.65)
	pull.tween_property(self, "debris_pull", 1.0, 0.70)
	pull.tween_callback(_drop_pendant).set_delay(0.20)
	await pull.finished
	tara.hide()
	aura.hide()
	_set_phase(Phase.PORTAL_CLOSING)
	camera.offset = Vector2.ZERO
	var settling := create_tween().set_parallel(true)
	for i in range(debris.size()):
		settling.tween_property(debris[i], "position", debris_rest[i], 0.35)
	var closing: Tween = portal.close_portal(0.18)
	await closing.finished
	var wave: Tween = portal.release_wave(0.60)
	portal_shock = 1.0
	white_flash.color = Color(0.84, 0.76, 0.94, 0.60)
	var aftermath := create_tween().set_parallel(true)
	aftermath.tween_property(white_flash, "color:a", 0.0, 0.16)
	aftermath.tween_property(portal_veil, "color:a", 0.0, 0.60)
	aftermath.tween_property(self, "portal_shock", 0.0, 0.60)
	# Follow the falling pendant back toward Saka during the shockwave's decay.
	await _restore_solo_walk_camera()
	if wave.is_running():
		await wave.finished
	if is_instance_valid(pendant_fall) and pendant_fall.is_running():
		await pendant_fall.finished
	flashing = false
	white_flash.color = Color(1, 1, 1, 0)
	camera.offset = Vector2.ZERO
	get_node("Backdrop").offset = Vector2.ZERO
	_set_phase(Phase.ABSENCE)
	await get_tree().create_timer(3.0, false).timeout
	dialogue_requested.emit("absence")


func _drop_pendant() -> void:
	var start := _sprite_bounds(pose_sprite).get_center() + Vector2(-10, 10)
	var landing := saka.position + Vector2(100, -20)
	pendant.position = start
	pendant.show()
	pendant_fall = create_tween()
	pendant_fall.tween_method(_move_pendant_drop.bind(start, landing), 0.0, 1.0, 1.3)
	pendant_fall.tween_callback(pendant_drop.play)


func _move_pendant_drop(progress: float, start: Vector2, landing: Vector2) -> void:
	pendant.position = Vector2(lerpf(start.x, landing.x, progress), lerpf(start.y, landing.y, progress * progress) - sin(progress * PI) * 25.0)
	pendant.rotation = sin(progress * PI) * 0.35


func _take_pendant() -> void:
	_set_phase(Phase.PENDANT)
	saka.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	saka.facing_left = false
	saka.advance(1.0, 0.001)
	var approach := create_tween()
	approach.tween_property(saka, "position:x", pendant.position.x - 30, 0.65)
	await approach.finished
	saka.advance(0, 0)
	saka.reset_physics_interpolation()
	saka.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	pendant.hide()
	pendant_obtained.emit()
	# Let the small inventory notice clear before the emotional close-up.
	await get_tree().create_timer(1.8, false).timeout
	cinematic.show_shot("cry")
	_request_stage("cry", Phase.CRY)


func _restore_solo_walk_camera() -> void:
	var target := Vector2(clampf(saka.position.x + VIEW_SIZE.x * camera_lead_ratio, VIEW_SIZE.x * 0.5, route_length - VIEW_SIZE.x * 0.5), VIEW_SIZE.y * 0.5)
	await _move_camera(target, Vector2.ONE)
	dialogue_camera_active = false
	update_camera()


func start_reach_preview() -> void:
	_apply_damage()
	_set_phase(Phase.POSSESSION)
	saka.facing_left = false
	saka.advance(0, 0)
	_set_tara_pose(false)
	aura.strength = 0.55
	await _play_reach_cutscene()


func can_leave_bridge() -> bool:
	return completed and phase == Phase.COMPLETE and saka.position.x <= home_exit_x + HOME_EXIT_RADIUS


func help_text() -> String:
	match phase:
		Phase.SAFE: return "A/←: Kembali ke rumah"
		Phase.WALK: return "A/←: Jalan bersama Tara"
		Phase.COMPLETE: return "A/←: Jalan ke ujung jembatan"
	return ""


func reset_preview() -> void:
	get_tree().reload_current_scene()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_F1:
		panel.visible = not panel.visible
