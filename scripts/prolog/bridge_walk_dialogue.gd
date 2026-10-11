extends Node
## Distance-triggered ambient dialogue with optional interruptions owned by the flow.

signal interaction_requested(id: String)

const END_WALK_SECONDS := 3.0

@onready var bridge: Node2D = get_parent()
@onready var bubble: Control = $Interface/Bubble
var lines: Array = []
var enabled := true
var interactions_enabled := false
var interaction_paused := false
var start_x := 0.0
var furthest_distance := 0.0
var next_line := 0
var current_line := -1
var current_page := 0
var trigger_distances: Array[float] = []
var walk_duration := 0.0
var _pause_elapsed := 0.0


func _ready() -> void:
	lines = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/pro_02_bridge_walk.json"))
	bubble.advance_requested.connect(_advance_page)


func configure_timeline(walk_speed: float) -> void:
	trigger_distances.clear()
	var elapsed := 0.0
	for line: Dictionary in lines:
		elapsed += float(line.pause_before)
		trigger_distances.append(elapsed * walk_speed)
		for text: String in line.pages:
			elapsed += bubble.get_page_duration(text)
	walk_duration = elapsed + END_WALK_SECONDS


func reset(origin_x: float) -> void:
	start_x = origin_x
	furthest_distance = 0.0
	next_line = 0
	current_line = -1
	current_page = 0
	_pause_elapsed = 0.0
	interaction_paused = false
	bubble.hide()


func set_enabled(value: bool) -> void:
	enabled = value
	bubble.set_process(value)
	if not value:
		bubble.hide()


func is_complete() -> bool:
	return next_line >= lines.size() and current_line == -1 and not interaction_paused


func mark_complete() -> void:
	next_line = lines.size()
	current_line = -1
	interaction_paused = false
	bubble.hide()


func _process(delta: float) -> void:
	if not enabled or interaction_paused:
		return
	# Backtracking must not farm progress or repeat a completed conversation.
	furthest_distance = maxf(furthest_distance, bridge.saka.position.x - start_x)
	if current_line != -1 or next_line >= lines.size():
		return
	_pause_elapsed += delta
	if furthest_distance >= trigger_distances[next_line] and _pause_elapsed >= float(lines[next_line].pause_before):
		current_line = next_line
		next_line += 1
		current_page = 0
		_show_page()


func _show_page() -> void:
	var line: Dictionary = lines[current_line]
	var character: Node2D = bridge.tara if line.speaker == "Tara" else bridge.saka
	bubble.show_line(character, line.pages[current_page])


func _advance_page() -> void:
	if not enabled or current_line == -1:
		return
	current_page += 1
	if current_page >= lines[current_line].pages.size():
		var interaction: String = lines[current_line].get("on_finish", "")
		current_line = -1
		_pause_elapsed = 0.0
		bubble.hide()
		if interactions_enabled and not interaction.is_empty():
			interaction_paused = true
			interaction_requested.emit(interaction)
	else:
		_show_page()


func resume_after_interaction() -> void:
	interaction_paused = false
	_pause_elapsed = 0.0
