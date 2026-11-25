extends Node2D
## Prolog locations and dialogue, including the narrative doomsday and return.

signal location_changed(location: int)

enum Location { ROOM, BRIDGE, KEDAI, ESCAPE, AFTERMATH_ROOM, MEGABUILDING }

@export var starting_location: Location = Location.ROOM
@export var start_at_reach_cutscene := false
@export var skip_aftermath_dialogue := false

const ROOM_SCENE: PackedScene = preload("res://scenes/prolog/room.tscn")
const BRIDGE_SCENE := "res://scenes/prolog/bridge.tscn"
const KEDAI_SCENE := "res://scenes/prolog/kedai.tscn"
const ESCAPE_SCENE := "res://scenes/prolog/doomsday.tscn"
const MEGABUILDING_SCENE := "res://scenes/prolog/tower.tscn"
const TARA_SCENE: PackedScene = preload("res://scenes/prolog/tara.tscn")
const COMPUTER_SCENE := "res://scenes/ui/computer.tscn"
const SAFE_SCENE := "res://scenes/ui/safe.tscn"
const ENDING := "res://scripts/prolog/ending.gd"
const ACT_ONE_INTRO := "res://scenes/act1/intro.tscn"
const COMPUTER_X := 900.0
const COMPUTER_RADIUS := 105.0
const SAFE_X := 1170.0
const SAFE_RADIUS := 175.0
const ROOM_DOOR_X := 1480.0
const BRIDGE_EXIT_X := 180.0
const BRIDGE_ENTRY_X := 440.0
const EXIT_RADIUS := 100.0
const FADE_DURATION := 0.35
const ESCAPE_APPROACH_MIX := {&"Wind": -18.0}
const LOCATION_CAPTIONS := {
	Location.ROOM: "Di kamar Saka...",
	Location.BRIDGE: "Jembatan Astanapura",
	Location.KEDAI: "Kedai Mak Inah",
	Location.ESCAPE: "Jembatan Astanapura\nPerjalanan pulang...",
	Location.AFTERMATH_ROOM: "Di kamar Saka...",
	Location.MEGABUILDING: "Di depan megabuilding...",
}

@onready var scene_container: Node2D = $Location
@onready var title: Label = $Interface/Title
@onready var prompt: Label = $Interface/Prompt
@onready var interaction_prompt: Control = $Interface/InteractionPrompt
@onready var fade: ColorRect = $Transition/Fade
@onready var transition_caption: Label = $Transition/Caption
@onready var dialogue: Control = $Interface/Dialogue
@onready var choice: Control = $Interface/Choice
@onready var alarm: AudioStreamPlayer = $Alarm
@onready var bowl: AudioStreamPlayer = $Bowl
@onready var door_sound: AudioStreamPlayer = $DoorSound
@onready var rumble: AudioStreamPlayer = $Rumble
@onready var computer_fan: AudioStreamPlayer = $ComputerFan
@onready var ambience: Node = $Ambience
@onready var footsteps: AudioStreamPlayer = $Footsteps

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
# Story choice is retained in checkpoint saves.
var grandpa_safe_choice := ""
var bridge_branch_completed := false
var kedai_lines: Array = []
var kedai_dialogue_index := 0
var kedai_dialogue_completed := false
var kedai_disaster_triggered := false
var escape_lines: Array = []
var escape_dialogue_index := 0
var escape_dialogue_stage := "warning"
var doomsday_dialogue: Dictionary = {}
var tara_pendant_obtained := false
var doomsday_completed := false
var entrance_door_opened := false
var archive_recovered := false
var computer: CanvasLayer
var safe: CanvasLayer
var belt_obtained := false
var belt_equipped := false
var aftermath_dialogue: Dictionary = {}
var aftermath_intro_completed := false
var archive_response_completed := false
var aftermath_stage := ""
var aftermath_lines: Array = []
var aftermath_dialogue_index := 0
var ending: Node2D
var belt_linked := false
var prolog_departed := false
var _last_step_frame := -6
var _near_kedai := false


func _ready() -> void:
	room_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/room.json"))
	bridge_branch = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/bridge_choice.json"))
	kedai_lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/kedai.json"))
	doomsday_dialogue = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/doomsday.json"))
	aftermath_dialogue = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/aftermath.json"))
	dialogue.advance_requested.connect(_advance_dialogue)
	dialogue.line_revealed.connect(_on_dialogue_line_revealed)
	choice.option_selected.connect(_select_bridge_answer)
	var pause_menu := CanvasLayer.new()
	pause_menu.set_script(preload("res://scripts/ui/pause_menu.gd"))
	pause_menu.name = "PauseMenu"
	add_child(pause_menu)
	SaveManager.save_failed.connect(_on_save_failed)
	fade.color.a = 1.0
	var checkpoint := SaveManager.consume_pending_checkpoint()
	if not checkpoint.is_empty():
		await _restore_checkpoint(checkpoint)
		return
	if starting_location in [Location.MEGABUILDING, Location.AFTERMATH_ROOM]:
		room_intro_completed = true
		tara_pendant_obtained = true
		doomsday_completed = true
		entrance_door_opened = starting_location == Location.AFTERMATH_ROOM
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
		if current_location == Location.ESCAPE and start_at_reach_cutscene:
			active_scene.start_reach_preview()
		if current_location == Location.BRIDGE:
			active_scene.walk_dialogue.set_enabled(true)
		_update_prompt()
		_maybe_begin_aftermath_dialogue()


func _process(delta: float) -> void:
	if current_location == Location.ESCAPE and is_instance_valid(active_scene):
		active_scene.animate_effects(delta)
		title.visible = not active_scene.cinematic.visible
	elif current_location == Location.MEGABUILDING and is_instance_valid(active_scene):
		active_scene.animate_effects(delta)
		title.visible = not active_scene.is_pov_active()
	elif current_location == Location.BRIDGE and not is_transitioning and is_instance_valid(saka):
		var approaching: bool = saka.position.x >= active_scene.departure_x - 720.0
		if approaching != _near_kedai:
			_near_kedai = approaching
			_update_location_ambience()


func _physics_process(delta: float) -> void:
	if is_transitioning or dialogue_active or _computer_open() or _safe_open() or (is_instance_valid(ending) and ending.is_running()):
		return
	var right := Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
	var left := Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
	var direction := float(right) - float(left)
	if current_location not in [Location.ROOM, Location.AFTERMATH_ROOM]:
		active_scene.advance(direction, delta)
	else:
		saka.advance(direction, delta)
		if tara.visible:
			tara.follow(saka.position, delta)
	_update_prompt()


func _unhandled_key_input(event: InputEvent) -> void:
	if _computer_open() or _safe_open():
		return
	if not event is InputEventKey:
		return
	if is_instance_valid(ending) and ending.is_running():
		ending.handle_key(event)
		return
	if current_location == Location.MEGABUILDING:
		if not is_transitioning and not dialogue_active:
			active_scene.handle_interaction_input(event)
		return
	if not event.pressed or event.echo or is_transitioning or dialogue_active:
		return
	if current_location == Location.ESCAPE:
		if event.physical_keycode == KEY_E and active_scene.can_leave_bridge():
			get_viewport().set_input_as_handled()
			_transition_to(Location.MEGABUILDING)
		return
	if event.physical_keycode != KEY_E:
		return
	if current_location == Location.KEDAI and not kedai_dialogue_completed:
		var seat_index: int = active_scene.get_nearby_seat()
		if seat_index >= 0:
			get_viewport().set_input_as_handled()
			_begin_kedai_dialogue(seat_index)
		return
	if _can_use_safe():
		get_viewport().set_input_as_handled()
		_open_safe()
		return
	if _can_use_computer():
		get_viewport().set_input_as_handled()
		_open_computer()
		return
	if _can_use_exit():
		get_viewport().set_input_as_handled()
		var destination := Location.ROOM if current_location == Location.BRIDGE else Location.BRIDGE
		if current_location == Location.KEDAI and kedai_disaster_triggered:
			destination = Location.ESCAPE
		_transition_to(destination)


func _can_use_exit() -> bool:
	if current_location in [Location.ESCAPE, Location.AFTERMATH_ROOM, Location.MEGABUILDING]:
		return false
	if current_location == Location.KEDAI and not kedai_dialogue_completed:
		return false
	var exit_x := ROOM_DOOR_X if current_location == Location.ROOM else BRIDGE_EXIT_X
	return absf(saka.position.x - exit_x) <= EXIT_RADIUS


func _update_prompt() -> void:
	if is_instance_valid(ending) and ending.is_running():
		prompt.text = ""
		if ending.phase == ending.Phase.READY and not is_transitioning:
			interaction_prompt.show_above(saka, "Aktifkan sabuk")
		else:
			interaction_prompt.hide()
		return
	if is_transitioning or dialogue_active or _computer_open() or _safe_open():
		interaction_prompt.hide()
		prompt.text = ""
		return
	prompt.text = "A/D atau ←/→: Jalan  ·  Pintu keluar di kanan" if current_location == Location.ROOM else "A/D atau ←/→: Jalan"
	if current_location == Location.ESCAPE:
		if active_scene.can_leave_bridge():
			interaction_prompt.show_above(saka, "Ke megabuilding")
		else:
			interaction_prompt.hide()
		prompt.text = active_scene.help_text()
		return
	if current_location == Location.MEGABUILDING:
		prompt.text = active_scene.help_text()
		if active_scene.can_interact():
			interaction_prompt.show_above(saka, "Periksa pintu")
		else:
			interaction_prompt.hide()
		return
	if current_location == Location.AFTERMATH_ROOM:
		prompt.text = "A/D atau ←/→: Jalan · Periksa komputer di meja kerja"
		if archive_recovered:
			prompt.text = "Kode brankas tercatat di komputer · Periksa brankas di bawah meja bengkel"
		if belt_obtained:
			prompt.text = "Sabuk Kakek ditemukan · Periksa brankas untuk memakainya"
		if belt_equipped:
			prompt.text = "Sabuk Kakek sudah dipakai · Arsip dapat dibaca kembali di komputer" if archive_recovered else "Sabuk terpasang · Periksa catatan Kakek di komputer"
		if _can_use_safe():
			interaction_prompt.show_above(saka, "Periksa brankas" if not belt_obtained or belt_equipped else "Pakai sabuk")
		elif _can_use_computer():
			interaction_prompt.show_above(saka, "Baca arsip" if archive_recovered else "Gunakan komputer")
		else:
			interaction_prompt.hide()
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


func _computer_open() -> bool:
	return is_instance_valid(computer) and computer.visible


func _can_use_computer() -> bool:
	return current_location == Location.AFTERMATH_ROOM and is_instance_valid(saka) and absf(saka.position.x - COMPUTER_X) <= COMPUTER_RADIUS


func _open_computer() -> void:
	if not _can_use_computer() or is_transitioning or dialogue_active or _safe_open():
		return
	saka.advance(0.0, 0.0)
	computer.open_computer(archive_recovered, belt_obtained)
	_update_prompt()


func _on_computer_closed() -> void:
	_maybe_begin_aftermath_dialogue()
	_update_prompt()


func _maybe_begin_aftermath_dialogue() -> void:
	if skip_aftermath_dialogue or current_location != Location.AFTERMATH_ROOM:
		return
	if is_transitioning or dialogue_active or _computer_open() or _safe_open():
		return
	if is_instance_valid(ending) and ending.is_running():
		return
	var stage := ""
	if not aftermath_intro_completed:
		stage = "arrival"
		computer_fan.play()
	elif archive_recovered and not archive_response_completed:
		stage = "archive_after_safe" if belt_obtained else "archive_found"
	if stage.is_empty():
		_maybe_begin_ending()
		return
	aftermath_stage = stage
	aftermath_lines = aftermath_dialogue[stage]
	aftermath_dialogue_index = 0
	dialogue_active = true
	dialogue.locked = false
	saka.advance(0.0, 0.0)
	_update_prompt()
	_show_aftermath_line()


func _maybe_begin_ending() -> void:
	if skip_aftermath_dialogue or current_location != Location.AFTERMATH_ROOM or not is_instance_valid(ending):
		return
	if is_transitioning or dialogue_active or _computer_open() or _safe_open() or ending.is_running():
		return
	if prolog_departed:
		ending.show_completed()
	elif belt_linked:
		ending.resume_ready()
	elif belt_equipped and archive_recovered and archive_response_completed:
		ending.begin(safe.state == "equipped")


func _on_belt_linked() -> void:
	belt_linked = true
	_save_room_progress()


func _on_prolog_departed() -> void:
	prolog_departed = true
	_save_room_progress()
	_start_act_one_intro.call_deferred()


func _start_act_one_intro() -> void:
	var previous_canvas := get_viewport().canvas_transform
	get_viewport().canvas_transform = Transform2D.IDENTITY
	if get_tree().change_scene_to_file(ACT_ONE_INTRO) == OK:
		return
	get_viewport().canvas_transform = previous_canvas
	if not is_instance_valid(ending):
		_show_location(Location.AFTERMATH_ROOM)
	ending.show_completed()


func _show_aftermath_line() -> void:
	var line: Dictionary = aftermath_lines[aftermath_dialogue_index]
	var text: String = line.text.replace("{safe_code}", str(computer.definition.get("safe_code", "")))
	dialogue.show_line(line.speaker, text)


func _advance_aftermath_dialogue() -> void:
	if not dialogue_active or is_transitioning:
		return
	aftermath_dialogue_index += 1
	if aftermath_dialogue_index < aftermath_lines.size():
		_show_aftermath_line()
		return
	if aftermath_stage == "arrival":
		aftermath_intro_completed = true
	else:
		archive_response_completed = true
	aftermath_stage = ""
	dialogue.hide()
	dialogue_active = false
	_save_room_progress()
	_maybe_begin_aftermath_dialogue()
	_update_prompt()


func cancel_active_interface() -> bool:
	if _safe_open():
		safe.cancel()
		return true
	if not _computer_open():
		return false
	computer.cancel()
	return true


func _on_archive_recovered(_safe_code: String) -> void:
	archive_recovered = true
	_save_room_progress()


func _safe_open() -> bool:
	return is_instance_valid(safe) and safe.visible


func _can_use_safe() -> bool:
	if current_location != Location.AFTERMATH_ROOM or not is_instance_valid(saka):
		return false
	var distance := absf(saka.position.x - SAFE_X)
	return distance <= SAFE_RADIUS and (not _can_use_computer() or distance <= absf(saka.position.x - COMPUTER_X))


func _open_safe() -> void:
	if not _can_use_safe() or is_transitioning or dialogue_active or _computer_open():
		return
	saka.advance(0.0, 0.0)
	safe.open_safe(belt_obtained, belt_equipped)
	_update_prompt()


func _apply_safe_state() -> void:
	if current_location != Location.AFTERMATH_ROOM:
		return
	active_scene.set_safe_opened(belt_obtained)
	saka.set_belt_equipped(belt_equipped)


func _on_safe_unlocked() -> void:
	if current_location != Location.AFTERMATH_ROOM or belt_obtained:
		return
	belt_obtained = true
	_apply_safe_state()
	_save_room_progress()
	await get_tree().create_timer(0.5, false).timeout
	if _safe_open() and current_location == Location.AFTERMATH_ROOM:
		safe.show_item()


func _on_belt_equip_requested() -> void:
	if current_location != Location.AFTERMATH_ROOM or not belt_obtained or belt_equipped:
		return
	is_transitioning = true
	var out := create_tween()
	out.tween_property(fade, "color:a", 1.0, 0.18)
	await out.finished
	belt_equipped = true
	_apply_safe_state()
	_save_room_progress()
	var into := create_tween()
	into.tween_property(fade, "color:a", 0.0, 0.22)
	await into.finished
	is_transitioning = false
	if _safe_open():
		safe.show_equipped()
	_update_prompt()


func _save_room_progress() -> void:
	# Keep the room's saved entry position while updating discovered story flags.
	if current_location != Location.AFTERMATH_ROOM:
		return
	var checkpoint := SaveManager.read_checkpoint()
	if not checkpoint.is_empty() and int(checkpoint.location) == Location.AFTERMATH_ROOM:
		checkpoint.flags["archive_recovered"] = archive_recovered
		checkpoint.flags["belt_obtained"] = belt_obtained
		checkpoint.flags["belt_equipped"] = belt_equipped
		checkpoint.flags["aftermath_intro_completed"] = aftermath_intro_completed
		checkpoint.flags["archive_response_completed"] = archive_response_completed
		checkpoint.flags["belt_linked"] = belt_linked
		checkpoint.flags["prolog_departed"] = prolog_departed
		SaveManager.write_checkpoint(checkpoint)


func _show_location(destination: Location, arrival: Dictionary = {}) -> void:
	ending = null
	if _computer_open():
		computer.close_computer()
	if _safe_open():
		safe.dismiss()
	if is_instance_valid(active_scene):
		scene_container.remove_child(active_scene)
		active_scene.queue_free()
	# Remove the previous bridge camera transform before showing the fixed room.
	get_viewport().canvas_transform = Transform2D.IDENTITY
	current_location = destination
	_near_kedai = false
	if destination == Location.AFTERMATH_ROOM:
		_prepare_room_interfaces()
	title.show()
	match destination:
		Location.ROOM, Location.AFTERMATH_ROOM:
			active_scene = ROOM_SCENE.instantiate()
			active_scene.after_doomsday = destination == Location.AFTERMATH_ROOM
		Location.BRIDGE:
			active_scene = (load(BRIDGE_SCENE) as PackedScene).instantiate()
			active_scene.spawn_x = BRIDGE_ENTRY_X
		Location.KEDAI:
			active_scene = (load(KEDAI_SCENE) as PackedScene).instantiate()
			if arrival.has("world_position_x"):
				active_scene.world_origin_x = arrival.world_position_x - active_scene.ENTRY_X
				active_scene.backdrop_scroll_offset = arrival.backdrop_shift
		Location.ESCAPE:
			active_scene = (load(ESCAPE_SCENE) as PackedScene).instantiate()
			if arrival.has("world_position_x"):
				active_scene.world_origin_x = arrival.world_position_x - active_scene.ESCAPE_START_X
				active_scene.backdrop_scroll_offset = arrival.backdrop_shift
		Location.MEGABUILDING:
			active_scene = (load(MEGABUILDING_SCENE) as PackedScene).instantiate()
	if destination not in [Location.ROOM, Location.AFTERMATH_ROOM] and arrival.has("world_origin_x"):
		active_scene.world_origin_x = arrival.world_origin_x
		active_scene.backdrop_scroll_offset = arrival.backdrop_scroll_offset
	scene_container.add_child(active_scene)
	# The flow owns input; standalone preview controls remain available via F6.
	active_scene.set_process(false)
	active_scene.set_physics_process(false)
	active_scene.set_process_unhandled_key_input(false)
	active_scene.get_node("Overlay/Panel").hide()
	saka = active_scene.get_node("SakaPreview")
	saka.set_physics_process(false)
	saka.sprite.frame_changed.connect(_on_saka_frame_changed)
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
		active_scene.reach_sequence = doomsday_dialogue.reach
		active_scene.dialogue_requested.connect(_begin_escape_dialogue)
		active_scene.intro_completed.connect(_update_prompt)
		active_scene.phase_changed.connect(_on_escape_phase_changed)
		active_scene.pendant_obtained.connect(_on_tara_pendant_obtained)
		active_scene.tara_hearing_changed.connect(_on_tara_hearing_changed)
		title.text = "JEMBATAN ASTANAPURA"
	elif destination == Location.KEDAI:
		tara = active_scene.get_node("Tara")
		if arrival.has("tara_gap"):
			tara.position.x = saka.position.x - arrival.tara_gap
			tara.reset_physics_interpolation()
		title.text = "KEDAI MAK INAH"
	elif destination == Location.MEGABUILDING:
		tara = active_scene.get_node("Tara")
		tara.hide()
		tara.stop_follow()
		active_scene.door_opened.connect(_on_entrance_opened)
		title.text = "MEGABUILDING SEKTOR 4"
	else:
		tara = TARA_SCENE.instantiate()
		active_scene.add_child(tara)
		tara.left_limit = saka.left_limit
		tara.right_limit = saka.right_limit
		tara.display_height = saka.display_height * 163.0 / 184.0
		tara.reset_follow(saka.position)
		if room_intro_completed:
			active_scene.set_saka_sleeping(false)
		title.text = "KAMAR SAKA"
		if destination == Location.AFTERMATH_ROOM:
			active_scene.set_saka_sleeping(false)
			tara.hide()
			tara.stop_follow()
			saka.position = Vector2(1320, 760)
			saka.facing_left = true
			saka.advance(0, 0)
			saka.reset_physics_interpolation()
	if destination == Location.AFTERMATH_ROOM:
		ending = load(ENDING).new()
		ending.name = "PrologEnding"
		ending.flow = self
		active_scene.add_child(ending)
		ending.activation_ready.connect(_on_belt_linked)
		ending.departed.connect(_on_prolog_departed)
	_apply_safe_state()
	_update_prompt()
	_update_location_ambience()
	location_changed.emit(current_location)


func _update_location_ambience() -> void:
	match current_location:
		Location.ROOM:
			ambience.set_mix({&"Room": -7.0, &"City": -21.0})
		Location.BRIDGE:
			ambience.set_mix({&"City": -5.0, &"Cook": -18.0} if _near_kedai else {&"City": -5.0})
		Location.ESCAPE:
			ambience.set_mix(ESCAPE_APPROACH_MIX)
		Location.KEDAI:
			ambience.set_mix({&"City": -21.0, &"Cook": -23.0} if dialogue_active else {&"City": -17.0, &"Cook": -16.0})
		Location.MEGABUILDING:
			ambience.set_mix({&"Wind": -9.0})
		Location.AFTERMATH_ROOM:
			ambience.set_mix({&"Room": -13.0})


func _on_escape_phase_changed(phase: int) -> void:
	if phase == active_scene.Phase.FLASH:
		ambience.set_mix({&"Wind": -5.0}, 0.35)
	elif phase == active_scene.Phase.MAESTRO:
		ambience.set_mix({&"Wind": -14.0}, 0.6)
	elif phase == active_scene.Phase.PORTAL_OPENING:
		ambience.set_mix({&"Wind": -9.0}, 0.6)
	elif phase == active_scene.Phase.PORTAL_CLOSING:
		ambience.set_mix({&"Wind": -27.0}, 0.45)
	elif phase == active_scene.Phase.RESONANCE:
		ambience.set_mix({&"Wind": -9.0}, 1.2)
	_update_prompt()


func _on_tara_hearing_changed(muffled: bool) -> void:
	ambience.set_mix({&"Wind": -19.0 if muffled else -5.0}, 0.20)


func _on_saka_frame_changed() -> void:
	var sprite: AnimatedSprite2D = saka.sprite
	if is_transitioning or dialogue_active or not sprite.is_visible_in_tree():
		return
	# Both walk sheets plant a foot on these frames. Turning can restore the same frame.
	if sprite.animation not in [&"walk", &"walk_left"] or sprite.frame not in [1, 5]:
		return
	var frame := Engine.get_physics_frames()
	if frame - _last_step_frame < 6:
		return
	_last_step_frame = frame
	footsteps.play()


func _prepare_room_interfaces() -> void:
	# The computer and safe are only needed on the return after doomsday.
	if is_instance_valid(computer):
		return
	computer = (load(COMPUTER_SCENE) as PackedScene).instantiate()
	computer.closed.connect(_on_computer_closed)
	computer.recovery_completed.connect(_on_archive_recovered)
	add_child(computer)
	safe = (load(SAFE_SCENE) as PackedScene).instantiate()
	safe.closed.connect(_on_computer_closed)
	safe.unlocked.connect(_on_safe_unlocked)
	safe.equip_requested.connect(_on_belt_equip_requested)
	add_child(safe)


func _transition_to(destination: Location, caption := "") -> void:
	if is_transitioning:
		return
	if current_location == Location.KEDAI and destination in [Location.BRIDGE, Location.ESCAPE] and not kedai_dialogue_completed:
		return
	if caption.is_empty():
		caption = str(LOCATION_CAPTIONS[destination])
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
	if destination == Location.ESCAPE:
		ambience.set_mix(ESCAPE_APPROACH_MIX)
	var fade_out := create_tween()
	if current_location == Location.ROOM or destination == Location.ROOM:
		door_sound.play()
		fade_out.tween_interval(0.18)
	fade_out.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_out.tween_property(fade, "color:a", 1.0, FADE_DURATION)
	await fade_out.finished
	await _show_transition_caption(caption)
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
	_save_scene_checkpoint()
	_maybe_begin_aftermath_dialogue()


func _show_transition_caption(text: String) -> void:
	# Shared intertitle for location changes and time skips; callers own the input lock.
	transition_caption.text = text
	transition_caption.modulate.a = 0.0
	transition_caption.show()
	var caption := create_tween()
	caption.tween_property(transition_caption, "modulate:a", 1.0, 0.15)
	caption.tween_interval(1.1)
	caption.tween_property(transition_caption, "modulate:a", 0.0, 0.15)
	await caption.finished
	transition_caption.hide()
	transition_caption.text = ""


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
	alarm.play()
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
	if is_instance_valid(ending) and ending.is_running():
		ending.advance_dialogue()
	elif current_location == Location.ROOM:
		_advance_room_dialogue()
	elif current_location == Location.KEDAI:
		_advance_kedai_dialogue()
	elif current_location == Location.AFTERMATH_ROOM:
		_advance_aftermath_dialogue()
	elif current_location in [Location.ESCAPE, Location.MEGABUILDING]:
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
	if not active_scene.can_seat(seat_index):
		return
	dialogue_active = true
	is_transitioning = true
	active_scene.stop_characters()
	_update_prompt()
	_update_location_ambience()
	var out := create_tween()
	out.tween_property(fade, "color:a", 1.0, FADE_DURATION)
	await out.finished
	active_scene.seat_characters(seat_index)
	await active_scene.focus_seated_camera()
	await _show_transition_caption("Beberapa menit kemudian...")
	var into := create_tween()
	into.tween_property(fade, "color:a", 0.0, FADE_DURATION)
	await into.finished
	is_transitioning = false
	kedai_dialogue_index = 0
	bowl.play()
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
	_update_location_ambience()


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
	rumble.play()
	bowl.play()
	await active_scene.shake_screen()
	kedai_dialogue_index += 1
	dialogue.locked = false
	is_transitioning = false
	_show_kedai_line()


func _begin_escape_dialogue(stage: String) -> void:
	dialogue_active = true
	is_transitioning = true
	escape_dialogue_stage = stage
	escape_lines = doomsday_dialogue[stage]
	active_scene.stop_characters()
	_update_prompt()
	await active_scene.focus_stage_camera(stage)
	is_transitioning = false
	dialogue.locked = false
	escape_dialogue_index = 0
	_show_escape_line()


func _show_escape_line() -> void:
	var line: Dictionary = escape_lines[escape_dialogue_index]
	dialogue.show_line(line.speaker, line.text)


func _advance_escape_dialogue() -> void:
	if not dialogue_active or is_transitioning:
		return
	var finished_stage := escape_dialogue_stage
	var line: Dictionary = escape_lines[escape_dialogue_index]
	is_transitioning = true
	dialogue.locked = true
	if line.has("on_advance") or line.has("pause_after"):
		dialogue.hide()
	if line.has("on_advance"):
		await active_scene.handle_dialogue_event(line.on_advance)
	if line.has("pause_after"):
		await get_tree().create_timer(float(line.pause_after), false).timeout
	escape_dialogue_index += 1
	if escape_dialogue_index < escape_lines.size():
		is_transitioning = false
		dialogue.locked = false
		_show_escape_line()
		return
	dialogue.hide()
	dialogue_active = false
	if finished_stage == "warning":
		await active_scene.restore_walk_camera()
	await active_scene.finish_dialogue(finished_stage)
	# A completed stage may already have opened the next modal asynchronously.
	# Never clear that new stage's lock or dialogue_active flag on return.
	if escape_dialogue_stage == finished_stage:
		is_transitioning = false
		dialogue.locked = false
	if current_location == Location.ESCAPE and finished_stage == "resolve":
		doomsday_completed = true
	_update_prompt()


func _on_entrance_opened() -> void:
	if current_location != Location.MEGABUILDING or is_transitioning:
		return
	entrance_door_opened = true
	await _transition_to(Location.AFTERMATH_ROOM)


func _on_tara_pendant_obtained() -> void:
	tara_pendant_obtained = true
	var notice := Label.new()
	notice.name = "TaraPendantNotice"
	notice.text = "Liontin Tara diperoleh."
	notice.position = Vector2(50, 100)
	notice.add_theme_font_size_override("font_size", 27)
	notice.add_theme_color_override("font_shadow_color", Color.BLACK)
	notice.add_theme_constant_override("shadow_offset_x", 2)
	notice.add_theme_constant_override("shadow_offset_y", 2)
	$Interface.add_child(notice)
	await get_tree().create_timer(1.6, false).timeout
	if is_instance_valid(notice):
		notice.queue_free()


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
	_update_prompt()
	alarm.stop()
	await active_scene.startle_saka()
	var out := create_tween()
	out.tween_property(fade, "color:a", 1.0, 0.18)
	await out.finished
	active_scene.set_saka_sleeping(false)
	saka.facing_left = true
	saka.advance(0.0, 0.0)
	tara.reset_follow(saka.position)
	await _show_transition_caption("Saka pun terbangun.")
	var into := create_tween()
	into.tween_property(fade, "color:a", 0.0, 0.25)
	await into.finished
	dialogue.locked = false
	is_transitioning = false


func _save_scene_checkpoint() -> Error:
	# Called only after a scene transition, before gameplay in the new location.
	# The first New Game checkpoint is bridge entry; the opening room is unsaved.
	if is_transitioning or dialogue_active or not room_intro_completed:
		return ERR_BUSY
	var kind: String = ["room_free", "bridge_free", "kedai_free", "escape_start", "room_after_doomsday", "megabuilding_entry"][current_location]
	var walk_state: Dictionary = {}
	if current_location == Location.BRIDGE:
		var walk: Node = active_scene.walk_dialogue
		walk_state = {"start_x":walk.start_x, "furthest_distance":walk.furthest_distance, "next_line":walk.next_line}
	return SaveManager.write_checkpoint({
		"scope":"scene_entry",
		"checkpoint":kind, "location":current_location, "choice":grandpa_safe_choice,
		"flags":{
			"room_intro_completed":room_intro_completed,
			"bridge_branch_completed":bridge_branch_completed,
			"kedai_dialogue_completed":kedai_dialogue_completed,
			"kedai_disaster_triggered":kedai_disaster_triggered,
			"tara_pendant_obtained":tara_pendant_obtained,
			"doomsday_completed":doomsday_completed,
			"entrance_door_opened":entrance_door_opened,
			"archive_recovered":archive_recovered,
			"belt_obtained":belt_obtained,
			"belt_equipped":belt_equipped,
			"aftermath_intro_completed":aftermath_intro_completed,
			"archive_response_completed":archive_response_completed,
			"belt_linked":belt_linked,
			"prolog_departed":prolog_departed,
		},
		"saka_x":saka.position.x, "saka_y":saka.position.y,
		"tara_x":tara.position.x, "tara_y":tara.position.y,
		"facing_left":saka.facing_left, "tara_flip_h":tara.sprite.flip_h,
		"world_origin_x":active_scene.world_origin_x if current_location not in [Location.ROOM, Location.AFTERMATH_ROOM] else 0.0,
		"backdrop_scroll_offset":active_scene.backdrop_scroll_offset if current_location not in [Location.ROOM, Location.AFTERMATH_ROOM] else 0.0,
		"bridge_walk":walk_state,
	})


func _restore_checkpoint(data: Dictionary) -> void:
	is_transitioning = true
	room_intro_completed = data.flags.room_intro_completed
	bridge_branch_completed = data.flags.bridge_branch_completed
	kedai_dialogue_completed = data.flags.kedai_dialogue_completed
	kedai_disaster_triggered = data.flags.kedai_disaster_triggered
	tara_pendant_obtained = data.flags.get("tara_pendant_obtained", false)
	doomsday_completed = data.flags.get("doomsday_completed", false)
	entrance_door_opened = data.flags.get("entrance_door_opened", false)
	archive_recovered = data.flags.get("archive_recovered", false)
	belt_obtained = data.flags.get("belt_obtained", false)
	belt_equipped = data.flags.get("belt_equipped", false)
	belt_linked = data.flags.get("belt_linked", false)
	prolog_departed = data.flags.get("prolog_departed", false)
	# Existing saves that already found the archive must not replay a new arrival.
	aftermath_intro_completed = data.flags.get("aftermath_intro_completed", archive_recovered or belt_obtained)
	archive_response_completed = data.flags.get("archive_response_completed", archive_recovered)
	grandpa_safe_choice = data.choice
	# Old return-room saves predate the entrance. Give them the new door scene.
	var restored_location := int(data.location) as Location
	if restored_location == Location.AFTERMATH_ROOM and not data.flags.has("entrance_door_opened"):
		restored_location = Location.MEGABUILDING
	if restored_location == Location.AFTERMATH_ROOM and prolog_departed:
		_start_act_one_intro.call_deferred()
		return
	_show_location(restored_location, data)
	if current_location == Location.ESCAPE:
		# All old doomsday saves restart at the narrative scene entry. They must
		# never restore the removed action driver or an already airborne companion.
		active_scene.set_player_spawn(active_scene.ESCAPE_START_X)
		saka.facing_left = true
		tara_pendant_obtained = false
		doomsday_completed = false
		entrance_door_opened = false
		archive_recovered = false
		belt_obtained = false
		belt_equipped = false
		belt_linked = false
		prolog_departed = false
		aftermath_intro_completed = false
		archive_response_completed = false
	elif current_location == Location.MEGABUILDING:
		active_scene.set_player_spawn(active_scene.ENTRY_X)
		entrance_door_opened = false
		archive_recovered = false
		belt_obtained = false
		belt_equipped = false
		belt_linked = false
		prolog_departed = false
		aftermath_intro_completed = false
		archive_response_completed = false
	else:
		if current_location in [Location.ROOM, Location.AFTERMATH_ROOM]:
			saka.position = Vector2(clampf(data.saka_x, saka.left_limit, saka.right_limit), data.saka_y)
		else:
			active_scene.set_player_spawn(data.saka_x)
	if current_location == Location.MEGABUILDING:
		saka.facing_left = true
	elif current_location != Location.ESCAPE:
		saka.facing_left = data.facing_left
	saka.advance(0.0, 0.0)
	saka.reset_physics_interpolation()
	tara.reset_follow(saka.position, saka.facing_left)
	if current_location != Location.ESCAPE:
		tara.position = Vector2(data.tara_x, data.tara_y)
		tara.sprite.flip_h = data.tara_flip_h
	tara.reset_physics_interpolation()
	if current_location == Location.BRIDGE:
		var walk: Node = active_scene.walk_dialogue
		walk.start_x = data.bridge_walk.start_x
		walk.furthest_distance = data.bridge_walk.furthest_distance
		walk.next_line = clampi(int(data.bridge_walk.next_line), 0, walk.lines.size())
		walk.set_enabled(true)
	if current_location not in [Location.ROOM, Location.AFTERMATH_ROOM]:
		active_scene.update_camera()
	var opening := create_tween()
	opening.tween_property(fade, "color:a", 0.0, FADE_DURATION)
	await opening.finished
	is_transitioning = false
	_update_prompt()
	_maybe_begin_aftermath_dialogue()


func _on_save_failed(message: String) -> void:
	if _computer_open():
		computer.show_save_warning(message)
	if _safe_open():
		safe.show_save_warning(message)
	var notice := Label.new()
	notice.text = message
	notice.position = Vector2(900, 30)
	notice.add_theme_font_size_override("font_size", 28)
	$Interface.add_child(notice)
	await get_tree().create_timer(6.0, false).timeout
	if is_instance_valid(notice):
		notice.queue_free()
