extends Control

signal advance_requested
signal line_revealed

const TYPING_SOUND = preload("res://scripts/ui/dialogue_tick.gd")

@export var playback_controls := false

@onready var speaker: Label = $Speaker
@onready var body: RichTextLabel = $Body
@onready var hint: Label = $Hint
@onready var auto_button: Button = $Playback/Auto
@onready var typing: TYPING_SOUND = $Typing
var locked := false
var _elapsed := 0.0
var _line_revealed := false
var _auto_elapsed := 0.0


func _ready() -> void:
	$Playback.visible = playback_controls
	if playback_controls and MobileInput.enabled:
		$Playback.position.x -= 124.0


func show_line(name_text: String, dialogue_text: String) -> void:
	speaker.text = name_text
	speaker.add_theme_font_size_override("font_size", 32 if name_text.length() > 10 else 42)
	body.text = dialogue_text
	body.visible_characters = 0
	_elapsed = 0.0
	_auto_elapsed = 0.0
	typing.reset()
	_line_revealed = false
	show()
	_update_hint()


func _process(delta: float) -> void:
	if not is_visible_in_tree() or locked:
		return
	if _line_revealed:
		if playback_controls and auto_button.button_pressed:
			_auto_elapsed += delta
			var read_time := clampf(body.get_total_character_count() / 32.0, 1.15, 3.6)
			if _auto_elapsed >= read_time:
				_auto_elapsed = 0.0
				advance_requested.emit()
		return
	var previous_count := body.visible_characters
	_elapsed += delta * GameSettings.text_speed
	body.visible_characters = mini(int(_elapsed), body.get_total_character_count())
	typing.update_reveal(delta, body.text, previous_count, body.visible_characters)
	_update_hint()


func reveal_all() -> void:
	typing.reset()
	body.visible_characters = -1
	_update_hint()


func _on_auto_toggled(enabled: bool) -> void:
	auto_button.text = "Auto ON" if enabled else "Auto"
	_auto_elapsed = 0.0


func _on_skip_pressed() -> void:
	if locked or not is_visible_in_tree():
		return
	reveal_all()
	# A revealed line can start a timed story event before the next page is available.
	if not locked and is_visible_in_tree():
		advance_requested.emit()


func _update_hint() -> void:
	var complete := body.visible_characters == -1 or body.visible_characters >= body.get_total_character_count()
	if MobileInput.enabled:
		hint.text = "Ketuk: Lanjut ▸" if complete else "Ketuk: Tampilkan teks"
	else:
		hint.text = "E / Space / Enter: Lanjut ▸" if complete else "E / Space / Enter: Tampilkan teks"
	if complete and not _line_revealed:
		_line_revealed = true
		line_revealed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree() or locked:
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
