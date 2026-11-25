extends Control
## A close-up of the central door seam. Hand and leaf motion share one offset.

const VIEW_SIZE := Vector2(1672, 941)
const LEFT_HAND: Texture2D = preload("res://assets/ui/door/left.png")
const RIGHT_HAND: Texture2D = preload("res://assets/ui/door/right.png")
const BUBBLE: PackedScene = preload("res://scenes/ui/floating_dialogue.tscn")
const KEY_PROGRESS = preload("res://scripts/ui/key_progress.gd")
const CLOSED_GAP := 244.0
const EFFORT_TRAVEL := 190.0
const OPEN_TRAVEL := 1040.0
const LEFT_CONTACT := 640.0
const RIGHT_CONTACT := 1032.0

var progress: Range
var bubble: Control
var spread := 0.0
var _target_spread := 0.0
var _kick := 0.0
var _elapsed := 0.0
var _finishing := false
var _bubble_queue: Array[String] = []


func _ready() -> void:
	name = "DoorPOV"
	size = VIEW_SIZE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_build_hud()
	bubble = BUBBLE.instantiate()
	add_child(bubble)
	bubble.advance_requested.connect(_advance_bubble)


func _build_hud() -> void:
	progress = KEY_PROGRESS.new()
	progress.position = Vector2((VIEW_SIZE.x - 224.0) * .5, 24)
	add_child(progress)


func set_pressure(ratio: float) -> void:
	progress.value = ratio * 100.0
	_target_spread = ratio * EFFORT_TRAVEL


func tap() -> void:
	_kick = 7.0


func set_key_pressed(pressed: bool) -> void:
	progress.set_pressed(pressed)


func say(text: String, replace := false) -> void:
	if replace:
		_bubble_queue.clear()
		bubble.hide()
	if bubble.visible:
		_bubble_queue.append(text)
	else:
		bubble.show_screen_line(text, Vector2(VIEW_SIZE.x * .5, 900))


func _advance_bubble() -> void:
	if _bubble_queue.is_empty():
		bubble.hide()
	else:
		bubble.show_screen_line(_bubble_queue.pop_front(), Vector2(VIEW_SIZE.x * .5, 900))


func _process(delta: float) -> void:
	_elapsed += delta
	_kick = move_toward(_kick, 0.0, delta * 32.0)
	if not _finishing:
		spread = lerpf(spread, _target_spread, 1.0 - exp(-18.0 * delta))
	queue_redraw()


func _draw() -> void:
	# The seam and both hands shake together, preserving contact on every frame.
	var shake := Vector2(sin(_elapsed * 61.0), cos(_elapsed * 47.0)) * _kick
	draw_rect(Rect2(Vector2(-30, -30), VIEW_SIZE + Vector2(60, 60)), Color("0b151c"))
	draw_set_transform(shake)
	var left_edge := VIEW_SIZE.x * .5 - CLOSED_GAP * .5 - spread
	var right_edge := VIEW_SIZE.x * .5 + CLOSED_GAP * .5 + spread
	_draw_leaf(left_edge, false)
	_draw_leaf(right_edge, true)
	draw_texture(LEFT_HAND, Vector2(left_edge - LEFT_CONTACT, 0))
	draw_texture(RIGHT_HAND, Vector2(right_edge - RIGHT_CONTACT, 0))
	draw_set_transform(Vector2.ZERO)


func _draw_leaf(edge: float, right: bool) -> void:
	# Oversized, cropped metal leaves: no outer frame, handles or threshold.
	var direction := 1.0 if right else -1.0
	var origin := edge if right else edge - 2000.0
	draw_rect(Rect2(origin, -30, 2000, VIEW_SIZE.y + 60), Color("253e48"))
	var bevel_x := edge if right else edge - 70.0
	draw_rect(Rect2(bevel_x, -30, 70, VIEW_SIZE.y + 60), Color("36535e"))
	var lip_x := edge if right else edge - 13.0
	draw_rect(Rect2(lip_x, -30, 13, VIEW_SIZE.y + 60), Color("142730"))
	var light_x := edge + 14.0 if right else edge - 19.0
	draw_rect(Rect2(light_x, -30, 5, VIEW_SIZE.y + 60), Color("607b81"))
	# A partial vertical panel bevel stays outside the main action area.
	draw_rect(Rect2(edge + direction * 620.0, -30, 18, VIEW_SIZE.y + 60), Color("2d4852"))


func open_fully() -> void:
	_finishing = true
	progress.hide()
	_kick = 10.0
	var opening := create_tween()
	opening.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	opening.tween_property(self, "spread", OPEN_TRAVEL, .85)
	await opening.finished

