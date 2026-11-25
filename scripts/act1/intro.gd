extends Node2D
## The title sequence and Saka's first moments on the shore.

const MAIN_MENU := "res://scenes/menu/main_menu.tscn"
const DAWN_LIGHT := Color("f8ddba")
const WATERLINE_Y := 563.0
const OPENING_PAN_SPEED := 7.0
const PAN_END_X := -389.0
const PAN_DURATION := 7.1
const BIRD_STARTS := [Vector2(515, 185), Vector2(1095, 145), Vector2(1535, 228)]
const BIRD_FRAMES := [
	["#.........#", "##.......##", ".##.....##.", "..###.###..", "....###...."],
	["...........", "####...####", "..#######..", "....###....", "..........."],
	["...........", "....###....", "..#######..", ".##.....##.", "##.......##"],
]
const SHORE_LINES := [
	"Uhuk... Asin. Ini... bau laut asli?",
	"Tara... kamu bener. Laut asli indah banget. Kakak janji bakal bawa kamu ke sini."
]

@onready var ocean: Node2D = $Ocean
@onready var water: Sprite2D = $Ocean/Water
@onready var drifter: Sprite2D = $Ocean/Saka
@onready var wake: Node2D = $Ocean/Wake
@onready var birds: Node2D = $Ocean/Birds
@onready var shore: Node2D = $Shore
@onready var resting: Sprite2D = $Shore/SakaResting
@onready var resting_shadow: Sprite2D = $Shore/RestingShadow
@onready var standing: Sprite2D = $Shore/SakaStanding
@onready var standing_shadow: Polygon2D = $Shore/StandingShadow
@onready var veil: ColorRect = $Interface/Veil
@onready var studio: Label = $Interface/Studio
@onready var presents: Label = $Interface/Presents
@onready var title: Control = $Interface/Title
@onready var chapter: Control = $Interface/Chapter
@onready var dialogue: Control = $Interface/Dialogue
@onready var action: Button = $Interface/Action
@onready var surf: AudioStreamPlayer = $Surf
@onready var gulls: AudioStreamPlayer = $Gulls

var _timeline: Tween
var _elapsed := 0.0
var _drift_start_x := 0.0
var _reveal_progress := 0.0
var _on_shore := false
var _complete := false
var _line := 0


func _ready() -> void:
	get_viewport().canvas_transform = Transform2D.IDENTITY
	var ocean_waterline_y := ocean.to_global(Vector2(0.0, WATERLINE_Y)).y
	(water.material as ShaderMaterial).set_shader_parameter("waterline_y", ocean_waterline_y)
	(drifter.material as ShaderMaterial).set_shader_parameter("waterline_y", ocean_waterline_y)
	_drift_start_x = drifter.position.x
	wake.draw.connect(_draw_wake)
	birds.draw.connect(_draw_birds)
	dialogue.advance_requested.connect(_advance_dialogue)
	action.pressed.connect(_handle_action)
	if not MobileInput.enabled:
		action.text = "Esc · Lewati sinematik"
		action.grab_focus()
	(surf.stream as AudioStreamOggVorbis).loop = true
	surf.play()
	_play_intro()


func _play_intro() -> void:
	_timeline = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_timeline.tween_property(veil, "color:a", 0.0, 1.35)
	_timeline.parallel().tween_property(surf, "volume_db", -6.0, 1.35)
	_timeline.tween_callback(_play_gulls.bind(-12.0))
	_timeline.tween_interval(2.55)
	_timeline.tween_property(veil, "color:a", 0.48, 0.7)
	_queue_credit(studio, 1.9)

	_timeline.tween_callback(_play_gulls.bind(-16.0))
	_timeline.tween_property(surf, "volume_db", -3.5, 0.9)
	_timeline.tween_property(surf, "volume_db", -6.0, 1.4)

	_timeline.tween_property(presents, "modulate:a", 1.0, 0.65)
	_timeline.tween_interval(1.25)
	_timeline.tween_property(self, "_reveal_progress", 1.0, PAN_DURATION)
	_timeline.parallel().tween_property(presents, "modulate:a", 0.0, 0.85)
	_timeline.parallel().tween_property(veil, "color:a", 0.0, 1.4)

	_timeline.tween_interval(1.35)
	_queue_credit(title, 2.9)
	_timeline.tween_interval(0.35)
	_timeline.tween_callback(func() -> void:
		veil.color = Color(DAWN_LIGHT, 0.0)
	)
	_timeline.tween_property(veil, "color:a", 1.0, 0.78)
	_timeline.tween_callback(_show_shore)
	_timeline.tween_property(veil, "color:a", 0.0, 1.25)
	_timeline.tween_interval(0.6)
	_timeline.tween_callback(_start_dialogue)


func _queue_credit(card: CanvasItem, hold: float) -> void:
	_timeline.tween_property(card, "modulate:a", 1.0, 0.65)
	_timeline.tween_interval(hold)
	_timeline.tween_property(card, "modulate:a", 0.0, 0.55)


func _play_gulls(volume: float) -> void:
	gulls.volume_db = volume
	gulls.play()


func _process(delta: float) -> void:
	if not ocean.visible:
		return
	_elapsed += delta
	var opening_pan_x := -_elapsed * OPENING_PAN_SPEED
	ocean.position.x = lerpf(opening_pan_x, PAN_END_X, _reveal_progress)
	birds.queue_redraw()
	var swell := sin(_elapsed * 1.7) * 9.0
	drifter.position = Vector2(lerpf(_drift_start_x, 1255.0, _reveal_progress), 480.0 + swell)
	drifter.rotation = sin(_elapsed * 1.7 + 0.7) * 0.039
	wake.position = Vector2(drifter.position.x, WATERLINE_Y + swell * 0.35)
	wake.queue_redraw()


func _draw_wake() -> void:
	var light := Color(0.86, 0.89, 0.77, 0.43 + 0.16 * sin(_elapsed * 1.7))
	wake.draw_polyline(PackedVector2Array([Vector2(-213, 1), Vector2(-191, -2), Vector2(-167, 0), Vector2(-144, 4)]), light, 3.0)
	wake.draw_polyline(PackedVector2Array([Vector2(-101, 8), Vector2(-81, 10), Vector2(-54, 7)]), light, 3.0)
	wake.draw_polyline(PackedVector2Array([Vector2(147, 1), Vector2(165, -3), Vector2(189, -1), Vector2(209, 2)]), light, 3.0)


func _draw_birds() -> void:
	var silhouette := Color(0.23, 0.20, 0.26, 0.81)
	for index in range(BIRD_STARTS.size()):
		var speed := 17.0 + float(index) * 4.0
		var flight := Vector2(-_elapsed * speed, sin(_elapsed * 1.35 + index) * 8.0)
		var origin: Vector2 = (BIRD_STARTS[index] + flight).round()
		var frame: Array = BIRD_FRAMES[int(_elapsed * 4.8 + index) % BIRD_FRAMES.size()]
		var pixel_size := 3.0 if index == 1 else 4.0
		for row in range(frame.size()):
			for column in range(frame[row].length()):
				if frame[row][column] == "#":
					var pixel := origin + Vector2(column, row) * pixel_size
					birds.draw_rect(Rect2(pixel, Vector2.ONE * pixel_size), silhouette)


func _show_shore() -> void:
	_on_shore = true
	gulls.stop()
	ocean.hide()
	studio.hide()
	presents.hide()
	title.hide()
	action.hide()
	shore.show()
	chapter.show()
	create_tween().tween_property(surf, "volume_db", -4.0, 1.2)


func _start_dialogue() -> void:
	dialogue.show_line("Saka", SHORE_LINES[0])


func _advance_dialogue() -> void:
	_line += 1
	if _line < SHORE_LINES.size():
		resting.hide()
		resting_shadow.hide()
		standing.show()
		standing_shadow.show()
		dialogue.show_line("Saka", SHORE_LINES[_line])
		return
	dialogue.hide()
	_complete = true
	action.text = "Kembali ke menu"
	action.show()
	action.grab_focus()


func _handle_action() -> void:
	if _complete:
		surf.stop()
		get_tree().change_scene_to_file(MAIN_MENU)
	elif not _on_shore:
		_timeline.kill()
		_show_shore()
		veil.color = DAWN_LIGHT
		var reveal := create_tween()
		reveal.tween_property(veil, "color:a", 0.0, 0.55)
		reveal.tween_callback(_start_dialogue)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_ESCAPE:
		if not _on_shore or _complete:
			get_viewport().set_input_as_handled()
			_handle_action()
