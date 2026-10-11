extends Control

signal advance_requested
signal line_revealed

const CHARACTERS_PER_SECOND := 42.0
@onready var speaker: Label = $Speaker
@onready var body: RichTextLabel = $Body
@onready var hint: Label = $Hint
var locked := false
var _elapsed := 0.0
var _line_revealed := false


func show_line(name_text: String, dialogue_text: String) -> void:
	speaker.text = name_text
	body.text = dialogue_text
	body.visible_characters = 0
	_elapsed = 0.0
	_line_revealed = false
	show()
	_update_hint()


func _process(delta: float) -> void:
	if not visible or locked or body.visible_characters == -1:
		return
	_elapsed += delta
	body.visible_characters = mini(int(_elapsed * CHARACTERS_PER_SECOND), body.get_total_character_count())
	_update_hint()


func reveal_all() -> void:
	body.visible_characters = -1
	_update_hint()


func _update_hint() -> void:
	var complete := body.visible_characters == -1 or body.visible_characters >= body.get_total_character_count()
	hint.text = "E / Space / Enter: Lanjut ▸" if complete else "E / Space / Enter: Tampilkan teks"
	if complete and not _line_revealed:
		_line_revealed = true
		line_revealed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not visible or locked:
		return
	var accepted := false
	if event is InputEventKey:
		accepted = event.pressed and not event.echo and event.physical_keycode in [KEY_E, KEY_SPACE, KEY_ENTER]
	elif event is InputEventMouseButton:
		accepted = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	if not accepted:
		return
	get_viewport().set_input_as_handled()
	if body.visible_characters != -1 and body.visible_characters < body.get_total_character_count():
		reveal_all()
	else:
		advance_requested.emit()
