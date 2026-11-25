extends "res://scripts/prolog/waterfront.gd"
## Solo entrance with a continuous first-person repeated-press interaction.

signal door_opened

enum Phase { APPROACH, MASHING, OPENING, OPEN }

const ENTRY_X := 1380.0
const INTERACT_X := 670.0
const INTERACT_RADIUS := 70.0
const DOOR_ORIGIN := Vector2(280, 420)
const DOOR_SIZE := Vector2(300, 450)
const MAX_PRESSURE := 100.0
const PRESSURE_PER_TAP := 5.0
const DECAY_DELAY := .04
const DECAY_PER_SECOND := 32.0
const POV = preload("res://scripts/ui/door_pov.gd")

@export var exterior_texture: Texture2D
@export var door_texture: Texture2D

@onready var strain_sound: AudioStreamPlayer = $StrainSound

var phase := Phase.APPROACH
var pressure := 0.0
var idle_seconds := 0.0
var midpoint_shown := false
var _mash_key_held := false
var _strain_started := false
var door_leaves: Array[Node2D] = []
var door_clip: Control
var gate_hud: CanvasLayer
var pov: Control
var progress: Range
var _lines: Dictionary


func _ready() -> void:
	spawn_x = ENTRY_X
	route_length = VIEW_SIZE.x
	camera_lead_ratio = 0.0
	super._ready()
	saka.left_limit = INTERACT_X
	saka.facing_left = true
	saka.advance(0, 0)
	saka.z_index = 2
	tara.hide()
	tara.stop_follow()
	$Backdrop.hide()
	bridge.hide()
	lamps.hide()
	_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/tower.json"))
	_build_entrance()
	gate_hud = CanvasLayer.new()
	gate_hud.name = "DoorCloseup"
	gate_hud.layer = 30
	add_child(gate_hud)
	pov = POV.new()
	gate_hud.add_child(pov)
	progress = pov.progress
	pov.progress.hint.text = "Tekan cepat!"
	gate_hud.hide()
	$Overlay/Panel/Margin/Rows/Help.text = "A/D: Jalan | E: Periksa pintu / tekan berulang"


func _build_entrance() -> void:
	var facade := Node2D.new()
	facade.name = "EntranceFacade"
	facade.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(facade)
	move_child(facade, saka.get_index())
	var art := Sprite2D.new()
	art.name = "Exterior"
	art.texture = exterior_texture
	art.centered = false
	art.scale = VIEW_SIZE / exterior_texture.get_size()
	facade.add_child(art)
	# Continue the opaque bottom edge beyond the walkable floor.
	var edge := AtlasTexture.new()
	edge.atlas = exterior_texture
	edge.region = Rect2(0, exterior_texture.get_height() - 1, exterior_texture.get_width(), 1)
	edge.filter_clip = true
	var foundation := Sprite2D.new()
	foundation.name = "GroundExtension"
	foundation.texture = edge
	foundation.centered = false
	foundation.position.y = VIEW_SIZE.y
	foundation.scale = Vector2(VIEW_SIZE.x / edge.get_width(), FLOOR_EXTENSION_HEIGHT)
	facade.add_child(foundation)
	door_clip = Control.new()
	door_clip.name = "DoorOpening"
	door_clip.position = DOOR_ORIGIN
	door_clip.size = DOOR_SIZE
	door_clip.clip_contents = true
	door_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	facade.add_child(door_clip)
	for side in range(2):
		var leaf := Node2D.new()
		leaf.position.x = side * DOOR_SIZE.x * .5
		door_clip.add_child(leaf)
		door_leaves.append(leaf)
		var atlas := AtlasTexture.new()
		atlas.atlas = door_texture
		atlas.region = Rect2(side * door_texture.get_width() * .5, 0, door_texture.get_width() * .5, door_texture.get_height())
		atlas.filter_clip = true
		var leaf_art := Sprite2D.new()
		leaf_art.texture = atlas
		leaf_art.centered = false
		leaf_art.scale = Vector2(DOOR_SIZE.x * .5, DOOR_SIZE.y) / atlas.get_size()
		leaf.add_child(leaf_art)


func advance(direction: float, delta: float) -> void:
	if phase == Phase.APPROACH:
		saka.advance(direction, delta)
		update_camera()


func can_interact() -> bool:
	return phase == Phase.APPROACH and absf(saka.position.x - INTERACT_X) <= INTERACT_RADIUS


func is_pov_active() -> bool:
	return phase != Phase.APPROACH


func handle_interaction_input(event: InputEventKey) -> void:
	if event.physical_keycode != KEY_E:
		return
	if not event.pressed:
		_mash_key_held = false
		pov.set_key_pressed(false)
		return
	if event.echo:
		return
	if can_interact():
		get_viewport().set_input_as_handled()
		_begin_effort()
	elif phase == Phase.MASHING and not _mash_key_held:
		_mash_key_held = true
		pov.set_key_pressed(true)
		get_viewport().set_input_as_handled()
		_tap()


func _begin_effort() -> void:
	phase = Phase.MASHING
	_mash_key_held = true
	pov.set_key_pressed(true)
	stop_characters()
	saka.facing_left = true
	gate_hud.show()
	pov.modulate.a = 0.0
	var closeup := create_tween()
	closeup.tween_property(pov, "modulate:a", 1.0, .22)
	_say_stage("gate_locked")


func _tap() -> void:
	pressure = minf(MAX_PRESSURE, pressure + PRESSURE_PER_TAP)
	idle_seconds = 0.0
	pov.set_pressure(pressure / MAX_PRESSURE)
	pov.tap()
	if not _strain_started:
		_strain_started = true
		strain_sound.play()
	if pressure >= MAX_PRESSURE:
		_open_door()
	elif not midpoint_shown and pressure >= MAX_PRESSURE * .5:
		midpoint_shown = true
		strain_sound.pitch_scale = 0.87
		strain_sound.volume_db = -7.0
		strain_sound.play()
		_say_stage("gate_strain")


func animate_effects(delta: float) -> void:
	if phase != Phase.MASHING:
		return
	var previous_idle := idle_seconds
	idle_seconds += delta
	var decay_seconds := maxf(0.0, idle_seconds - DECAY_DELAY) - maxf(0.0, previous_idle - DECAY_DELAY)
	pressure = maxf(0.0, pressure - DECAY_PER_SECOND * decay_seconds)
	pov.set_pressure(pressure / MAX_PRESSURE)
	var opening := pressure / MAX_PRESSURE * 48.0
	door_leaves[0].position.x = -opening
	door_leaves[1].position.x = DOOR_SIZE.x * .5 + opening


func _notification(what: int) -> void:
	if what == NOTIFICATION_UNPAUSED:
		# Releases while paused never reach the gameplay handler.
		_mash_key_held = Input.is_physical_key_pressed(KEY_E)
		if is_instance_valid(pov):
			pov.set_key_pressed(_mash_key_held)


func _say_stage(stage: String, replace := false) -> void:
	pov.say(_lines[stage][0].text, replace)


func _open_door() -> void:
	phase = Phase.OPENING
	strain_sound.stop()
	$DoorSound.play()
	_say_stage("gate_open", true)
	var opening := create_tween().set_parallel(true)
	opening.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	opening.tween_property(door_leaves[0], "position:x", -160.0, .85)
	opening.tween_property(door_leaves[1], "position:x", 310.0, .85)
	await pov.open_fully()
	await get_tree().create_timer(.8, false).timeout
	phase = Phase.OPEN
	door_opened.emit()


func help_text() -> String:
	return "A/D atau ←/→: Jalan · Dekati pintu megabuilding" if phase == Phase.APPROACH else ""
