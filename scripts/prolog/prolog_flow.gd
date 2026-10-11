extends Node2D
## Opening room dialogue, bridge conversation and arrival at the kedai.

signal location_changed(location: int)

enum Location { ROOM, BRIDGE, KEDAI, ESCAPE }

@export var starting_location: Location = Location.ROOM

const ROOM_SCENE: PackedScene = preload("res://scenes/prolog/room_layer_test.tscn")
const BRIDGE_SCENE: PackedScene = preload("res://scenes/prolog/bridge_layer_test.tscn")
const KEDAI_SCENE: PackedScene = preload("res://scenes/prolog/kedai_walk_scene.tscn")
const ESCAPE_SCENE: PackedScene = preload("res://scenes/prolog/bridge_escape_scene.tscn")
const TARA_SCENE: PackedScene = preload("res://scenes/prolog/tara_companion.tscn")
const ROOM_DOOR_X := 1480.0
const BRIDGE_EXIT_X := 180.0
const BRIDGE_ENTRY_X := 440.0
const EXIT_RADIUS := 100.0
const FADE_DURATION := 0.35

@onready var scene_container: Node2D = $Location
@onready var title: Label = $Interface/Title
@onready var prompt: Label = $Interface/Prompt
@onready var interaction_prompt: Control = $Interface/InteractionPrompt
@onready var fade: ColorRect = $Transition/Fade
@onready var dialogue: Control = $Interface/Dialogue
@onready var choice: Control = $Interface/Choice

var current_location: Location = Location.ROOM
var active_scene: Node2D
var saka: Node2D
var is_transitioning := false
var tara: Node2D
var dialogue_active := false
var room_intro_completed := false
var dialogue_index := 0
var room_lines: Array = []
var bridge_branch: Dictionary = {}
var bridge_lines: Array = []
var bridge_dialogue_index := 0
# Retained for later story consequences during this run; no save system yet.
var grandpa_safe_choice := ""
var bridge_branch_completed := false
var kedai_lines: Array = []
var kedai_dialogue_index := 0
var kedai_dialogue_completed := false
var kedai_disaster_triggered := false
var escape_lines: Array = []
var escape_dialogue_index := 0


func _ready() -> void:
	room_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/pro_01_room.json"))
	bridge_branch = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/pro_02_bridge_choice.json"))
	kedai_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/pro_02_kedai.json"))
	escape_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/pro_03_escape.json"))
	dialogue.advance_requested.connect(_advance_dialogue)
	dialogue.line_revealed.connect(_on_dialogue_line_revealed)
	choice.option_selected.connect(_select_bridge_answer)
	fade.color.a = 1.0
	_show_location(starting_location)
	if starting_location == Location.ROOM:
		_begin_room_intro()
	else:
		# The bridge test starts here; the regular prolog still starts in the bedroom.
		room_intro_completed = true
		is_transitioning = true
		var opening := create_tween()
		opening.tween_property(fade, "color:a", 0.0, FADE_DURATION)
		await opening.finished
		is_transitioning = false
		if current_location == Location.BRIDGE:
			active_scene.walk_dialogue.set_enabled(true)
		_update_prompt()


func _physics_process(delta: float) -> void:
	if is_transitioning or dialogue_active:
		return
	var right := Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
	var left := Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
	var direction := float(right) - float(left)
	if current_location != Location.ROOM:
		active_scene.advance(direction, delta)
	else:
		saka.advance(direction, delta)
		tara.follow(saka.position, delta)
	_update_prompt()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo or is_transitioning or dialogue_active:
		return
	if current_location == Location.ESCAPE:
		if event.physical_keycode == KEY_SPACE and active_scene.damaged and not active_scene.flashing:
			active_scene.jump_requested = true
			get_viewport().set_input_as_handled()
		return
	if event.physical_keycode != KEY_E:
		return
	if current_location == Location.KEDAI and not kedai_dialogue_completed:
		var seat_index: int = active_scene.get_nearby_seat()
		if seat_index >= 0:
			get_viewport().set_input_as_handled()
			_begin_kedai_dialogue(seat_index)
		return
	if _can_use_exit():
		get_viewport().set_input_as_handled()
		var destination := Location.ROOM if current_location == Location.BRIDGE else Location.BRIDGE
		if current_location == Location.KEDAI and kedai_disaster_triggered:
			destination = Location.ESCAPE
		_transition_to(destination)


func _can_use_exit() -> bool:
	if current_location == Location.ESCAPE:
		return false
	if current_location == Location.KEDAI and not kedai_dialogue_completed:
		return false
	var exit_x := ROOM_DOOR_X if current_location == Location.ROOM else BRIDGE_EXIT_X
	return absf(saka.position.x - exit_x) <= EXIT_RADIUS


func _update_prompt() -> void:
	if is_transitioning or dialogue_active:
		interaction_prompt.hide()
		prompt.text = ""
		return
	prompt.text = "A/D atau ←/→: Jalan  ·  Pintu keluar di kanan" if current_location == Location.ROOM else "A/D atau ←/→: Jalan"
	if current_location == Location.ESCAPE:
		interaction_prompt.hide()
		if active_scene.completed:
			prompt.text = "Fase kabur selesai · Adegan Tara terangkat belum dipasang"
		elif active_scene.flashing:
			prompt.text = ""
		elif not active_scene.damaged:
			prompt.text = "A/←: Kembali ke rumah"
		else:
			prompt.text = "A/←: Kabur  ·  Shift: Sprint  ·  Ctrl: Slide  ·  Space: Lompat"
		return
	if current_location == Location.KEDAI and not kedai_dialogue_completed:
		prompt.text = "A/D atau ←/→: Jalan  ·  Pilih kursi untuk sarapan"
		var seat_index: int = active_scene.get_nearby_seat()
		if seat_index >= 0:
			interaction_prompt.show_above(saka, "Duduk")
		else:
			interaction_prompt.hide()
		return
	if not _can_use_exit():
		interaction_prompt.hide()
		return
	match current_location:
		Location.ROOM:
			interaction_prompt.show_above(saka, "Keluar ke jembatan")
		Location.BRIDGE:
			interaction_prompt.show_above(saka, "Kembali ke kamar")
		Location.KEDAI:
			interaction_prompt.show_above(saka, "Kembali ke jembatan")


func _show_location(destination: Location, arrival: Dictionary = {}) -> void:
	if is_instance_valid(active_scene):
		scene_container.remove_child(active_scene)
		active_scene.queue_free()
	# Remove the previous bridge camera transform before showing the fixed room.
	get_viewport().canvas_transform = Transform2D.IDENTITY
	current_location = destination
	match destination:
		Location.ROOM:
			active_scene = ROOM_SCENE.instantiate()
		Location.BRIDGE:
			active_scene = BRIDGE_SCENE.instantiate()
			active_scene.spawn_x = BRIDGE_ENTRY_X
		Location.KEDAI:
			active_scene = KEDAI_SCENE.instantiate()
			if arrival.has("world_position_x"):
				active_scene.world_origin_x = arrival.world_position_x - active_scene.ENTRY_X
				active_scene.backdrop_scroll_offset = arrival.backdrop_shift
		Location.ESCAPE:
			active_scene = ESCAPE_SCENE.instantiate()
			if arrival.has("world_position_x"):
				active_scene.world_origin_x = arrival.world_position_x - active_scene.ESCAPE_START_X
				active_scene.backdrop_scroll_offset = arrival.backdrop_shift
	scene_container.add_child(active_scene)
	# The flow owns input; standalone preview controls remain available via F6.
	active_scene.set_process(false)
	active_scene.set_physics_process(false)
	active_scene.set_process_unhandled_key_input(false)
	active_scene.get_node("Overlay/Panel").hide()
	saka = active_scene.get_node("SakaPreview")
	saka.set_physics_process(false)
	if destination == Location.BRIDGE:
		tara = active_scene.get_node("Tara")
		active_scene.walk_dialogue.set_enabled(false)
		active_scene.walk_dialogue.interactions_enabled = true
		active_scene.walk_dialogue.interaction_requested.connect(_begin_bridge_choice)
		active_scene.destination_reached.connect(_enter_kedai)
		if arrival.get("return_from_kedai", false):
			saka.facing_left = true
			active_scene.set_player_spawn(active_scene.departure_x - 120.0)
			active_scene.walk_dialogue.mark_complete()
		active_scene.update_camera()
		title.text = "JEMBATAN ASTANAPURA"
	elif destination == Location.ESCAPE:
		tara = active_scene.get_node("Tara")
		active_scene.disaster_started.connect(_begin_escape_dialogue)
		active_scene.escape_completed.connect(_update_prompt)
		title.text = "JEMBATAN ASTANAPURA"
	elif destination == Location.KEDAI:
		tara = active_scene.get_node("Tara")
		if arrival.has("tara_gap"):
			tara.position.x = saka.position.x - arrival.tara_gap
			tara.reset_physics_interpolation()
		title.text = "KEDAI MAK INAH"
	else:
		tara = TARA_SCENE.instantiate()
		active_scene.add_child(tara)
		tara.left_limit = saka.left_limit
		tara.right_limit = saka.right_limit
		tara.display_height = saka.display_height * 163.0 / 184.0
		tara.reset_follow(saka.position)
		title.text = "KAMAR SAKA"
	_update_prompt()
	location_changed.emit(current_location)


func _transition_to(destination: Location) -> void:
	if is_transitioning:
		return
	if current_location == Location.KEDAI and destination in [Location.BRIDGE, Location.ESCAPE] and not kedai_dialogue_completed:
		return
	var arrival: Dictionary = {}
	if destination in [Location.KEDAI, Location.ESCAPE]:
		arrival = {
			"world_position_x": active_scene.world_origin_x + saka.position.x,
			"tara_gap": saka.position.x - tara.position.x,
			"backdrop_shift": -active_scene.sky.position.x - active_scene.BACKDROP_SCROLL_LIMIT,
		}
	elif current_location == Location.KEDAI and destination == Location.BRIDGE:
		arrival["return_from_kedai"] = true
	is_transitioning = true
	if current_location == Location.BRIDGE:
		active_scene.stop_characters()
		active_scene.walk_dialogue.set_enabled(false)
	else:
		saka.advance(0.0, 0.0)
		tara.stop_follow()
	_update_prompt()
	var fade_out := create_tween()
	fade_out.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_out.tween_property(fade, "color:a", 1.0, FADE_DURATION)
	await fade_out.finished
	_show_location(destination, arrival)
	await get_tree().process_frame
	var fade_in := create_tween()
	fade_in.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_property(fade, "color:a", 0.0, FADE_DURATION)
	await fade_in.finished
	is_transitioning = false
	if current_location == Location.BRIDGE:
		active_scene.walk_dialogue.set_enabled(true)
	_update_prompt()


func _enter_kedai() -> void:
	if current_location == Location.BRIDGE and not is_transitioning and not dialogue_active:
		_transition_to(Location.KEDAI)


func _begin_room_intro() -> void:
	dialogue_active = true
	is_transitioning = true
	active_scene.set_saka_sleeping(true)
	tara.position = Vector2(610, 760)
	tara.sprite.flip_h = true
	tara.stop_follow()
	_update_prompt()
	var opening := create_tween()
	opening.tween_property(fade, "color:a", 0.0, FADE_DURATION)
	await opening.finished
	is_transitioning = false
	dialogue_index = 0
	_show_room_line()


func _show_room_line() -> void:
	var line: Dictionary = room_lines[dialogue_index]
	dialogue.show_line(line.speaker, line.text)


func _advance_dialogue() -> void:
	if current_location == Location.ROOM:
		_advance_room_dialogue()
	elif current_location == Location.KEDAI:
		_advance_kedai_dialogue()
	elif current_location == Location.ESCAPE:
		_advance_escape_dialogue()
	elif dialogue_active and not choice.visible and not is_transitioning:
		bridge_dialogue_index += 1
		if bridge_dialogue_index >= bridge_lines.size():
			dialogue.hide()
			is_transitioning = true
			await active_scene.restore_walk_camera()
			is_transitioning = false
			dialogue_active = false
			bridge_branch_completed = true
			active_scene.walk_dialogue.resume_after_interaction()
			_update_prompt()
		else:
			_show_bridge_line()


func _begin_bridge_choice(id: String) -> void:
	if id != bridge_branch.id or bridge_branch_completed:
		active_scene.walk_dialogue.resume_after_interaction()
		return
	dialogue_active = true
	active_scene.stop_characters()
	saka.facing_left = tara.position.x < saka.position.x
	saka.advance(0.0, 0.0)
	tara.sprite.flip_h = saka.position.x < tara.position.x
	tara.stop_follow()
	_update_prompt()
	is_transitioning = true
	await active_scene.focus_dialogue_camera()
	is_transitioning = false
	choice.show_choices(bridge_branch.prompt, bridge_branch.options)


func _select_bridge_answer(id: String) -> void:
	if not dialogue_active or current_location != Location.BRIDGE:
		return
	for option: Dictionary in bridge_branch.options:
		if option.id == id:
			grandpa_safe_choice = id
			bridge_lines = option.lines
			bridge_dialogue_index = 0
			_show_bridge_line()
			return


func _show_bridge_line() -> void:
	var line: Dictionary = bridge_lines[bridge_dialogue_index]
	dialogue.show_line(line.speaker, line.text)


func _begin_kedai_dialogue(seat_index: int) -> void:
	if dialogue_active or is_transitioning or kedai_dialogue_completed:
		return
	if not active_scene.seat_characters(seat_index):
		return
	dialogue_active = true
	is_transitioning = true
	_update_prompt()
	await active_scene.focus_seated_camera()
	is_transitioning = false
	kedai_dialogue_index = 0
	_show_kedai_line()


func _show_kedai_line() -> void:
	var line: Dictionary = kedai_lines[kedai_dialogue_index]
	dialogue.show_line(line.speaker, line.text)


func _advance_kedai_dialogue() -> void:
	if not dialogue_active or is_transitioning:
		return
	kedai_dialogue_index += 1
	if kedai_dialogue_index < kedai_lines.size():
		_show_kedai_line()
		return
	dialogue.hide()
	is_transitioning = true
	active_scene.stand_characters(true)
	await active_scene.restore_walk_camera()
	is_transitioning = false
	dialogue_active = false
	kedai_dialogue_completed = true
	_update_prompt()


func _on_dialogue_line_revealed() -> void:
	if current_location != Location.KEDAI or not dialogue_active or is_transitioning:
		return
	if kedai_lines[kedai_dialogue_index].get("on_reveal", "") != "kedai_tremor":
		return
	kedai_disaster_triggered = true
	# Interrupt at the dash, whether the player reads the typewriter or reveals it.
	is_transitioning = true
	dialogue.locked = true
	dialogue.hide()
	_update_prompt()
	await active_scene.shake_screen()
	kedai_dialogue_index += 1
	dialogue.locked = false
	is_transitioning = false
	_show_kedai_line()


func _begin_escape_dialogue() -> void:
	dialogue_active = true
	is_transitioning = true
	active_scene.stop_characters()
	_update_prompt()
	await active_scene.focus_dialogue_camera()
	is_transitioning = false
	escape_dialogue_index = 0
	_show_escape_line()


func _show_escape_line() -> void:
	var line: Dictionary = escape_lines[escape_dialogue_index]
	dialogue.show_line(line.speaker, line.text)


func _advance_escape_dialogue() -> void:
	if not dialogue_active or is_transitioning:
		return
	escape_dialogue_index += 1
	if escape_dialogue_index < escape_lines.size():
		_show_escape_line()
		return
	dialogue.hide()
	is_transitioning = true
	await active_scene.restore_walk_camera()
	is_transitioning = false
	dialogue_active = false
	active_scene.jump_requested = false
	_update_prompt()


func _advance_room_dialogue() -> void:
	if not dialogue_active or is_transitioning:
		return
	# React after the player finishes this page, rather than when it first appears.
	if room_lines[dialogue_index].get("on_advance", "") == "wake_saka":
		await _wake_saka()
	dialogue_index += 1
	if dialogue_index >= room_lines.size():
		dialogue.hide()
		dialogue_active = false
		room_intro_completed = true
		_update_prompt()
		return
	_show_room_line()


func _wake_saka() -> void:
	is_transitioning = true
	dialogue.locked = true
	dialogue.hide()
	var out := create_tween()
	out.tween_property(fade, "color:a", 1.0, 0.10)
	await out.finished
	active_scene.set_saka_sleeping(false)
	saka.facing_left = true
	saka.advance(0.0, 0.0)
	tara.reset_follow(saka.position)
	# A small jolt and quicker cut convey the startled wake with existing sprites.
	var resting_y: float = saka.position.y
	saka.position.y -= 16.0
	var into := create_tween().set_parallel(true)
	into.tween_property(fade, "color:a", 0.0, 0.10)
	into.tween_property(saka, "position:y", resting_y, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await into.finished
	dialogue.locked = false
	is_transitioning = false
