extends "res://scripts/prolog/waterfront_walk_scene.gd"
## Walking dialogue ends before the separate kedai location begins.

signal destination_reached

const KEDAI_APPROACH_GAP := 220.0

@onready var walk_dialogue: Node = $WalkDialogue
@onready var kedai: Node2D = $Kedai
var departure_x := 0.0
var _departure_sent := false


func _ready() -> void:
	walk_dialogue.configure_timeline(saka.move_speed)
	departure_x = ceilf(spawn_x + saka.move_speed * walk_dialogue.walk_duration)
	# Scenery continues beyond the exit, while the walkable route stops before the booth.
	route_length = departure_x + VIEW_SIZE.x * 0.63
	super._ready()
	saka.right_limit = departure_x
	tara.right_limit = departure_x
	kedai.position.x = departure_x + KEDAI_APPROACH_GAP
	update_camera()
	reset_physics_interpolation()


func advance(direction: float, delta: float) -> void:
	super.advance(direction, delta)
	if direction > 0.0 and saka.position.x >= departure_x and walk_dialogue.is_complete() and not _departure_sent:
		_departure_sent = true
		destination_reached.emit()


func set_player_spawn(x: float) -> void:
	super.set_player_spawn(x)
	walk_dialogue.reset(x)
	_departure_sent = false
