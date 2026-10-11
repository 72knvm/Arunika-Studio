extends Control
## Screen-space key hint anchored to a world object or above a character.

const EDGE_MARGIN := 20.0
const TOP_MARGIN := 86.0
const HEAD_GAP := 22.0

@onready var key_label: Label = $Key
@onready var action_label: Label = $Action

var target: Node2D
var anchor_position := Vector2.ZERO
var _above_character := false
var _previous_anchor := Vector2.ZERO
var _current_anchor := Vector2.ZERO


func _ready() -> void:
	process_physics_priority = 100


func _physics_process(_delta: float) -> void:
	if visible and is_instance_valid(target):
		_previous_anchor = _current_anchor
		_current_anchor = target.global_transform * anchor_position


func show_at(object: Node2D, local_position: Vector2, action: String, key_text: String = "E") -> void:
	if target != object or anchor_position != local_position or not visible:
		_current_anchor = object.global_transform * local_position
		_previous_anchor = _current_anchor
	target = object
	anchor_position = local_position
	_above_character = false
	key_label.text = key_text
	action_label.text = action
	show()
	_update_position()


func show_above(character: Node2D, action: String, key_text: String = "E") -> void:
	show_at(character, Vector2(0, -character.display_height), action, key_text)
	_above_character = true
	_update_position()


func _process(_delta: float) -> void:
	if not visible:
		return
	if not is_instance_valid(target):
		hide()
		return
	_update_position()


func _update_position() -> void:
	var world_anchor := target.global_transform * anchor_position
	if target.is_physics_interpolated_and_enabled():
		world_anchor = _previous_anchor.lerp(_current_anchor, Engine.get_physics_interpolation_fraction())
	var screen_anchor := get_canvas_transform().affine_inverse() * target.get_canvas_transform() * world_anchor
	var viewport_size := get_viewport_rect().size
	var top := screen_anchor.y - size.y - HEAD_GAP if _above_character else screen_anchor.y - 36.0
	position = Vector2(
		clampf(screen_anchor.x - size.x * 0.5, EDGE_MARGIN, viewport_size.x - size.x - EDGE_MARGIN),
		clampf(top, TOP_MARGIN, viewport_size.y - size.y - EDGE_MARGIN)
	).round()
