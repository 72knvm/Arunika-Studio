extends Control
## Screen-space key hint anchored to a world object or above a character.

const EDGE_MARGIN := 20.0
const TOP_MARGIN := 86.0
const HEAD_GAP := 22.0

@onready var key_label: Label = $Key
@onready var action_label: Label = $Action
@onready var background: Control = $Background

var target: Node2D
var anchor_position := Vector2.ZERO
var _above_character := false
var _previous_anchor := Vector2.ZERO
var _current_anchor := Vector2.ZERO
var _wide_keycap: Control


func _ready() -> void:
	process_physics_priority = 100
	_wide_keycap = Control.new()
	_wide_keycap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_wide_keycap)
	move_child(_wide_keycap, background.get_index() + 1)
	# Stretch only the middle of the supplied square keycap, preserving its corners.
	for patch in [Rect2(0, 0, 179, 684), Rect2(179, 0, 321, 684), Rect2(500, 0, 179, 684)]:
		var atlas := AtlasTexture.new()
		atlas.atlas = background.texture
		atlas.region = patch
		atlas.filter_clip = true
		var art := TextureRect.new()
		art.texture = atlas
		art.material = background.material
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_wide_keycap.add_child(art)
	_wide_keycap.hide()


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
	var wide_key := key_text.length() > 1
	var font_size := 28 if wide_key else 40
	key_label.add_theme_font_size_override("font_size", font_size)
	var text_width := key_label.get_theme_font("font").get_string_size(key_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var key_width := maxf(152.0, text_width + 40.0) if wide_key else 72.0
	var key_left := (size.x - key_width) * 0.5
	background.position.x = key_left
	background.size.x = key_width
	background.visible = not wide_key
	_wide_keycap.visible = wide_key
	_wide_keycap.position = Vector2(key_left, 0)
	var corner_width := 72.0 * 179.0 / 679.0
	var parts := [Vector2(0, corner_width), Vector2(corner_width, key_width - corner_width * 2), Vector2(key_width - corner_width, corner_width)]
	for index in range(3):
		_wide_keycap.get_child(index).position = Vector2(parts[index].x, 0)
		_wide_keycap.get_child(index).size = Vector2(parts[index].y, 72)
	key_label.position.x = key_left
	key_label.size.x = key_width
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
