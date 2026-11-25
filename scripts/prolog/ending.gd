extends Node2D
## Owns the approved belt/lens ending. The flow retains inventory and save ownership.

signal activation_ready
signal departed
signal phase_changed(phase: int)

enum Phase { IDLE, DIALOGUE, READY, ACTIVATING, PORTAL, PULL, COMPLETE, FRACTURE, RESTORE, CALM, REOPEN }

const VIEW := Vector2(1672, 941)
const PORTAL = preload("res://scripts/prolog/portal.gd")
const CUTOUT: Shader = preload("res://assets/shaders/cutout.gdshader")
const RIFT: Shader = preload("res://assets/shaders/rift.gdshader")
const PULL_EFFECT = preload("res://scripts/prolog/portal_pull.gd")
const REPLAY_HOLO: Shader = preload("res://assets/shaders/replay_holo.gdshader")
const SPLIT_SOUND: AudioStream = preload("res://assets/audio/prolog/portal_split.ogg")
const MERGE_SOUND: AudioStream = preload("res://assets/audio/prolog/portal_merge.ogg")
const CONNECT_SOUND: AudioStream = preload("res://assets/audio/prolog/belt_connect.ogg")
const SYNC_SOUND: AudioStream = preload("res://assets/audio/prolog/belt_sync.ogg")

var flow: Node2D
var phase: Phase = Phase.IDLE
var definition: Dictionary
var lines: Array = []
var line_index := 0
var clock := 0.0
var glow := 0.0
var suction := 0.0
var fracture := 0.0
var camera: Camera2D
var portal: Node2D
var picture_layer: CanvasLayer
var replay: Control
var replay_tara: Sprite2D
var replay_portal: Node2D
var caption: Label
var flash: ColorRect
var distortion: ColorRect
var distortion_material: ShaderMaterial
var end_card: Control
var pull_effect: Node2D
var tile_sound: AudioStreamPlayer
var belt_sound: AudioStreamPlayer


func _ready() -> void:
	definition = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/ending.json"))
	z_index = 3
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	portal = PORTAL.new()
	portal.name = "RoomPortal"
	portal.radius = Vector2(155, 235)
	portal.z_index = -2
	portal.sound_enabled = true
	add_child(portal)
	portal.hide()
	tile_sound = AudioStreamPlayer.new()
	tile_sound.name = "TileSound"
	add_child(tile_sound)
	belt_sound = AudioStreamPlayer.new()
	belt_sound.name = "BeltSound"
	add_child(belt_sound)
	camera = Camera2D.new()
	camera.name = "EndingCamera"
	camera.enabled = false
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_IDLE
	camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	add_child(camera)
	_build_overlays()
	_build_replay()
	flow.saka.z_index = 2


func _set_phase(value: Phase) -> void:
	phase = value
	phase_changed.emit(phase)


func is_running() -> bool:
	return phase != Phase.IDLE


func _label(parent: Node, size: int, at: Vector2, dimensions: Vector2) -> Label:
	var label := Label.new()
	label.position = at
	label.size = dimensions
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("fff1dc"))
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _build_overlays() -> void:
	picture_layer = CanvasLayer.new()
	picture_layer.layer = 15
	add_child(picture_layer)
	distortion = ColorRect.new()
	distortion.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	distortion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	distortion_material = ShaderMaterial.new()
	distortion_material.shader = RIFT
	distortion.material = distortion_material
	picture_layer.add_child(distortion)
	distortion.hide()
	var captions := CanvasLayer.new()
	captions.layer = 35
	add_child(captions)
	caption = _label(captions, 30, Vector2(96, 830), Vector2(1480, 88))
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.hide()
	flash = ColorRect.new()
	flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	flash.color = Color(0.84, 0.76, 0.94, 0)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	captions.add_child(flash)
	var ending_layer := CanvasLayer.new()
	ending_layer.layer = 105
	add_child(ending_layer)
	end_card = ColorRect.new()
	end_card.color = Color.BLACK
	end_card.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ending_layer.add_child(end_card)
	var title := _label(end_card, 44, Vector2(0, 375), Vector2(VIEW.x, 90))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.text = "PROLOG SELESAI"
	var return_hint := _label(end_card, 25, Vector2(0, 495), Vector2(VIEW.x, 70))
	return_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return_hint.text = "E — Kembali ke menu"
	end_card.hide()


func _image(parent: Node, texture: Texture2D, at: Vector2, dimensions: Vector2) -> TextureRect:
	var image := TextureRect.new()
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.texture = texture
	image.position = at
	image.size = dimensions
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	return image


func _build_replay() -> void:
	var frame := Panel.new()
	replay = frame
	replay.position = Vector2(96, 82)
	replay.size = Vector2(690, 416)
	replay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var frame_style := StyleBoxFlat.new()
	frame_style.bg_color = Color(0.035, 0.105, 0.145, 0.88)
	frame_style.border_color = Color(0.49, 0.76, 0.8, 0.92)
	frame_style.set_border_width_all(2)
	frame.add_theme_stylebox_override("panel", frame_style)
	picture_layer.add_child(replay)

	var screen := Control.new()
	screen.position = Vector2(14, 56)
	screen.size = Vector2(662, 344)
	screen.clip_contents = true
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	replay.add_child(screen)
	var sky := _image(screen, load("res://assets/world/ruins/sky.png"), Vector2.ZERO, screen.size)
	sky.modulate = Color(0.73, 0.94, 1.0, 0.78)
	var city := _image(screen, load("res://assets/world/ruins/city.tres"), Vector2(0, 102), Vector2(662, 242))
	city.modulate = sky.modulate
	replay_portal = PORTAL.new()
	replay_portal.position = Vector2(340, 170)
	replay_portal.radius = Vector2(100, 145)
	replay_portal.pixel_size = 3.0
	screen.add_child(replay_portal)
	var atlas := AtlasTexture.new()
	atlas.atlas = load("res://assets/characters/tara/maestro.png")
	atlas.region = Rect2(46, 20, 933, 1434)
	atlas.filter_clip = true
	replay_tara = Sprite2D.new()
	replay_tara.texture = atlas
	replay_tara.centered = false
	replay_tara.scale = Vector2.ONE * 0.16
	replay_tara.position = Vector2(245, 45)
	var cutout := ShaderMaterial.new()
	cutout.shader = CUTOUT
	replay_tara.material = cutout
	screen.add_child(replay_tara)
	var scanner := ColorRect.new()
	scanner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scanner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var projection := ShaderMaterial.new()
	projection.shader = REPLAY_HOLO
	scanner.material = projection
	screen.add_child(scanner)
	var tag := _label(replay, 23, Vector2(16, 11), Vector2(650, 36))
	tag.text = "ARKEO-OPTICS  /  REKAMAN JEMBATAN"
	tag.add_theme_color_override("font_color", Color("c1e8e9"))
	replay.hide()
	replay_portal.hide()


func _process(delta: float) -> void:
	if phase in [Phase.IDLE, Phase.COMPLETE]:
		return
	clock += delta
	if phase in [Phase.ACTIVATING, Phase.PORTAL, Phase.FRACTURE, Phase.RESTORE, Phase.REOPEN, Phase.PULL]:
		camera.offset = Vector2(sin(clock * 37), sin(clock * 49)) * suction * 8.0
		camera.force_update_scroll()
	if distortion.visible:
		distortion_material.set_shader_parameter("strength", fracture)
		distortion_material.set_shader_parameter("elapsed", clock)
	queue_redraw()


func _restore_room() -> void:
	_set_phase(Phase.RESTORE)
	caption.hide()
	var settling := create_tween().set_parallel(true)
	settling.tween_property(self, "suction", 0.0, 0.65)
	settling.tween_property(self, "glow", 0.15, 0.65)
	settling.tween_property(portal, "intake", 0.0, 0.65)
	tile_sound.stream = MERGE_SOUND
	for level in [0.75, 0.50, 0.25, 0.0]:
		tile_sound.pitch_scale = lerpf(0.87, 1.08, level)
		tile_sound.volume_db = lerpf(-5.5, -10.0, level)
		tile_sound.play()
		var restoration := create_tween()
		restoration.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		restoration.tween_property(self, "fracture", level, 0.24)
		await restoration.finished
		await get_tree().create_timer(0.10, false).timeout
	distortion.hide()
	var closure: Tween = portal.close_portal(0.30)
	await closure.finished
	camera.offset = Vector2.ZERO
	camera.force_update_scroll()
	_set_phase(Phase.CALM)
	await get_tree().create_timer(0.55, false).timeout
	await _say("false_calm", 0, 1.65)
	caption.hide()
	await get_tree().create_timer(0.25, false).timeout


func _reopen_portal() -> void:
	_set_phase(Phase.REOPEN)
	var full_radius: Vector2 = portal.radius * 1.5
	portal.set_radius(Vector2(8, 12))
	portal.openness = 1.0
	portal.show()
	var rise_seconds := 0.85
	portal.play_open_sound(rise_seconds)
	var resurgence := create_tween().set_parallel(true)
	resurgence.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	resurgence.tween_method(portal.set_radius, portal.radius, full_radius, rise_seconds)
	resurgence.tween_property(self, "suction", 0.9, rise_seconds)
	resurgence.tween_property(self, "glow", 1.0, rise_seconds)
	resurgence.tween_property(portal, "intake", 1.0, rise_seconds)
	await get_tree().create_timer(0.13, false).timeout
	await _say("portal", 1, 1.1)
	await _say("portal", 2, 1.7)


func _draw() -> void:
	if phase in [Phase.IDLE, Phase.COMPLETE, Phase.PULL] or not is_instance_valid(flow.saka) or not flow.saka.visible:
		return
	var buckle: Vector2 = flow.saka.position + Vector2(0, -flow.saka.display_height * 0.40) * flow.saka.scale
	var lens: Vector2 = flow.saka.position + Vector2(-16, -flow.saka.display_height * 0.83) * flow.saka.scale
	var intensity := glow * (0.8 + sin(clock * 3.0) * 0.2)
	var spark_size := maxf(2.0, roundf(6.0 * flow.saka.scale.x))
	for anchor in [buckle, lens]:
		draw_rect(Rect2(anchor.round() - Vector2.ONE * spark_size * 0.5, Vector2.ONE * spark_size), Color(0.55, 0.85, 0.88, intensity))
	if phase in [Phase.ACTIVATING, Phase.PORTAL, Phase.FRACTURE, Phase.REOPEN, Phase.PULL]:
		for i in range(18):
			var progress := fmod(clock * (0.3 + suction * 0.3) + i * 0.173, 1.0)
			var start := Vector2(550 + (i * 137) % 800, 650 + (i * 31) % 115)
			var target: Vector2 = portal.position
			var point := start.lerp(target, progress * suction)
			point.y -= sin(progress * PI) * 45.0
			draw_rect(Rect2(point.round(), Vector2(6 + i % 3 * 2, 4)), Color(0.53, 0.58, 0.62, suction * (1.0 - progress)))


func _focus(target: Vector2, zoom_factor: float) -> void:
	camera.enabled = true
	var half := VIEW / zoom_factor * 0.5
	target.x = clampf(target.x, half.x, VIEW.x - half.x)
	target.y = clampf(target.y, half.y, VIEW.y - half.y)
	var movement := create_tween().set_parallel(true)
	movement.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	movement.tween_property(camera, "position", target, 0.45)
	movement.tween_property(camera, "zoom", Vector2.ONE * zoom_factor, 0.45)
	await movement.finished
	camera.force_update_scroll()


func begin(skip_equipped_line := false) -> void:
	if phase != Phase.IDLE:
		return
	_set_phase(Phase.DIALOGUE)
	flow.is_transitioning = true
	flow.dialogue_active = true
	flow.dialogue.locked = true
	flow.title.hide()
	flow.saka.advance(0, 0)
	flow.saka.facing_left = true
	flow.saka.advance(0, 0)
	flow.saka.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	camera.position = VIEW * 0.5
	lines = definition.connection + definition.replay
	line_index = 1 if skip_equipped_line else 0
	await _focus(flow.saka.position + Vector2(-80, -160), 1.4)
	_show_line()


func advance_dialogue() -> void:
	if phase != Phase.DIALOGUE or flow.is_transitioning:
		return
	line_index += 1
	_show_line()


func _show_line() -> void:
	flow.is_transitioning = true
	flow.dialogue.locked = true
	while line_index < lines.size() and lines[line_index].has("event"):
		flow.dialogue.hide()
		await _event(lines[line_index].event)
		line_index += 1
	if line_index >= lines.size() or lines[line_index].has("prompt"):
		flow.dialogue.hide()
		replay.hide()
		await _focus(VIEW * 0.5, 1.0)
		flow.dialogue_active = false
		flow.dialogue.locked = false
		flow.is_transitioning = false
		_set_phase(Phase.READY)
		activation_ready.emit()
		flow._update_prompt()
		return
	flow.is_transitioning = false
	flow.dialogue.locked = false
	flow.dialogue.show_line(lines[line_index].speaker, lines[line_index].text)


func _event(name_text: String) -> void:
	match name_text:
		"connect", "pulse":
			if name_text == "connect":
				belt_sound.stream = CONNECT_SOUND
				belt_sound.play()
			var light := create_tween()
			light.tween_property(self, "glow", 0.65 if name_text == "connect" else 1.0, 0.55)
			await light.finished
		"replay":
			replay.show()
			replay_portal.open_portal(0.5)
			await get_tree().create_timer(0.5, false).timeout
		"trace_found":
			var intake := create_tween().set_parallel(true)
			intake.tween_property(replay_tara, "position", replay_portal.position, 0.75)
			intake.tween_property(replay_tara, "scale", Vector2.ONE * 0.005, 0.75)
			await intake.finished
			replay_tara.hide()
			var closure: Tween = replay_portal.close_portal(0.25)
			await closure.finished
		"close_replay":
			replay.hide()


func resume_ready() -> void:
	flow.title.hide()
	glow = 0.65
	camera.position = VIEW * 0.5
	camera.zoom = Vector2.ONE
	camera.enabled = true
	_set_phase(Phase.READY)
	flow._update_prompt()


func handle_key(event: InputEventKey) -> void:
	if not event.pressed or event.echo or event.physical_keycode != KEY_E:
		return
	if phase == Phase.READY:
		get_viewport().set_input_as_handled()
		activate()
	elif phase == Phase.COMPLETE:
		get_viewport().set_input_as_handled()
		get_viewport().canvas_transform = Transform2D.IDENTITY
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _say(section: String, index: int, seconds: float) -> void:
	var spoken: Array = definition[section].filter(func(line: Dictionary): return line.has("speaker"))
	caption.text = "%s: %s" % [spoken[index].speaker, spoken[index].text]
	caption.show()
	await get_tree().create_timer(seconds, false).timeout


func activate() -> void:
	if phase != Phase.READY:
		return
	_set_phase(Phase.ACTIVATING)
	flow.is_transitioning = true
	flow._update_prompt()
	portal.position = Vector2(clampf(flow.saka.position.x - 300, 400, 1070), flow.saka.position.y - 190)
	var charging := create_tween().set_parallel(true)
	charging.tween_property(self, "glow", 1.0, 1.1)
	charging.tween_property(self, "suction", 0.25, 1.1)
	await _say("activation", 0, 2.0)
	belt_sound.stream = SYNC_SOUND
	belt_sound.play()
	await _say("activation", 1, 1.8)
	await _say("activation", 2, 2.5)
	var backing := create_tween()
	backing.tween_property(flow.saka, "position:x", flow.saka.position.x + 35.0, 0.35)
	await _say("activation", 3, 2.0)
	caption.hide()
	_set_phase(Phase.PORTAL)
	flash.color.a = 0.75
	var opening: Tween = portal.open_portal(0.65)
	var reveal := create_tween()
	reveal.tween_property(flash, "color:a", 0.0, 0.22)
	await opening.finished
	await _say("portal", 0, 2.2)
	var stronger := create_tween().set_parallel(true)
	stronger.tween_property(self, "suction", 0.75, 0.7)
	stronger.tween_property(portal, "intake", 0.8, 0.7)
	stronger.tween_property(flow.saka, "position:x", flow.saka.position.x - 40.0, 0.7)
	_set_phase(Phase.FRACTURE)
	distortion.show()
	caption.hide()
	# Each complete world view splits again: 1 -> 2 -> 4 -> 8 -> 16.
	tile_sound.stream = SPLIT_SOUND
	for level in [0.25, 0.50, 0.75, 1.0]:
		tile_sound.pitch_scale = lerpf(0.86, 1.18, level)
		tile_sound.volume_db = lerpf(-11.0, -2.5, level)
		tile_sound.play()
		var split := create_tween()
		split.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		split.tween_property(self, "fracture", level, 0.28)
		await split.finished
		await get_tree().create_timer(0.18, false).timeout
	flow.saka.facing_left = false
	flow.saka.advance(0, 0)
	await get_tree().create_timer(0.35, false).timeout
	flow.saka.facing_left = true
	flow.saka.advance(0, 0)
	if definition.has("confusion"):
		await _say("confusion", 0, 1.8)
	await _restore_room()
	await _reopen_portal()
	_set_phase(Phase.PULL)
	pull_effect = PULL_EFFECT.new()
	add_child(pull_effect)
	pull_effect.begin(flow.saka.sprite, portal.global_position)
	var pull_seconds := 1.2
	portal.play_pull_sound(pull_seconds)
	var pull := create_tween().set_parallel(true)
	pull.tween_property(pull_effect, "progress", 1.0, pull_seconds)
	pull.tween_property(self, "suction", 1.0, 0.9)
	await get_tree().create_timer(0.6, false).timeout
	caption.text = "Saka: " + definition.portal.filter(func(line: Dictionary): return line.has("speaker"))[3].text
	caption.show()
	await pull.finished
	flow.saka.hide()
	pull_effect.finish()
	caption.hide()
	var settling := create_tween().set_parallel(true)
	settling.tween_property(self, "suction", 0.0, 0.35)
	settling.tween_property(self, "glow", 0.15, 0.35)
	await settling.finished
	var closure: Tween = portal.close_portal(0.22)
	await closure.finished
	camera.offset = Vector2.ZERO
	camera.force_update_scroll()
	# The room remains after Saka disappears; fade only after the empty-room beat.
	await get_tree().create_timer(0.65, false).timeout
	var blackout := create_tween()
	blackout.tween_property(flow.fade, "color:a", 1.0, 0.45)
	await blackout.finished
	await get_tree().create_timer(1.2, false).timeout
	departed.emit()


func show_completed() -> void:
	_set_phase(Phase.COMPLETE)
	flow.is_transitioning = false
	flow.dialogue_active = false
	flow.dialogue.hide()
	flow.title.hide()
	flow.prompt.text = ""
	flow.interaction_prompt.hide()
	caption.hide()
	end_card.show()
