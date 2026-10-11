extends Control
## Reusable screen-space speech bubble anchored to a world-space character.

signal advance_requested

const PANEL_WIDTH := 660.0
const PANEL_HEIGHT := 142.0
const EDGE_MARGIN := 28.0
const TOP_MARGIN := 86.0
# Leave room for the taller companion's head when Tara is speaking.
const HEAD_GAP := 56.0
const TYPE_SPEED := 42.0
const READ_WORDS_PER_SECOND := 3.0
const MIN_READING_HOLD := 2.0
const READING_PADDING := 0.45

@export var auto_advance := true
@onready var panel: NinePatchRect = $Panel
@onready var tail: TextureRect = $Tail
@onready var body: RichTextLabel = $Text

var speaker: Node2D
var _typing_elapsed := 0.0
var _reading_elapsed := 0.0
var _reading_duration := 0.0
var _previous_head := Vector2.ZERO
var _current_head := Vector2.ZERO


func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	# Sample after character movement, keeping the UI tail on the rendered head.
	process_physics_priority = 100


func _physics_process(_delta: float) -> void:
	if visible and is_instance_valid(speaker):
		_previous_head = _current_head
		_current_head = speaker.global_transform * Vector2(0, -speaker.display_height)


func show_line(character: Node2D, text: String) -> void:
	speaker = character
	_current_head = speaker.global_transform * Vector2(0, -speaker.display_height)
	_previous_head = _current_head
	body.text = text
	body.visible_characters = 0
	_typing_elapsed = 0.0
	_reading_elapsed = 0.0
	_reading_duration = _reading_hold(text)
	show()
	_update_position()


func reveal_all() -> void:
	body.visible_characters = -1
	_reading_elapsed = 0.0


func _reading_hold(text: String) -> float:
	return maxf(MIN_READING_HOLD, text.split(" ", false).size() / READ_WORDS_PER_SECOND + READING_PADDING)


func get_page_duration(text: String) -> float:
	return text.length() / TYPE_SPEED + _reading_hold(text)


func _process(delta: float) -> void:
	if not visible:
		return
	if not is_instance_valid(speaker):
		hide()
		return
	_update_position()
	if body.visible_characters != -1 and body.visible_characters < body.get_total_character_count():
		_typing_elapsed += delta
		body.visible_characters = mini(int(_typing_elapsed * TYPE_SPEED), body.get_total_character_count())
	elif auto_advance:
		_reading_elapsed += delta
		if _reading_elapsed >= _reading_duration:
			_reading_elapsed = 0.0
			advance_requested.emit()


func _update_position() -> void:
	var viewport_size := get_viewport_rect().size
	var width := minf(PANEL_WIDTH, viewport_size.x - EDGE_MARGIN * 2.0)
	# Convert the character's head through the world camera into this UI canvas.
	var world_head := speaker.global_transform * Vector2(0, -speaker.display_height)
	if speaker.is_physics_interpolated_and_enabled():
		world_head = _previous_head.lerp(_current_head, Engine.get_physics_interpolation_fraction())
	var head: Vector2 = get_global_transform_with_canvas().affine_inverse() * speaker.get_canvas_transform() * world_head
	var panel_x := clampf(head.x - width * 0.5, EDGE_MARGIN, viewport_size.x - EDGE_MARGIN - width)
	var panel_y := maxf(TOP_MARGIN, head.y - HEAD_GAP - tail.size.y + 8.0 - PANEL_HEIGHT)
	panel.position = Vector2(panel_x, panel_y).round()
	panel.size = Vector2(width, PANEL_HEIGHT) / panel.scale
	body.position = panel.position + Vector2(26, 22)
	body.size = Vector2(width - 52, PANEL_HEIGHT - 44)
	var tail_x := clampf(head.x - tail.size.x * 0.5, panel.position.x + 22, panel.position.x + width - tail.size.x - 22)
	tail.position = Vector2(tail_x, panel.position.y + PANEL_HEIGHT - 8.0).round()
