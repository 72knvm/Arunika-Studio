extends Node
## Window shortcuts apply to the prolog and standalone scene previews.

var _previous_mode: Window.Mode = Window.MODE_WINDOWED
var _windowed_size := Vector2i(1152, 648)
var _windowed_position := Vector2i.ZERO
var _embedded_hint_shown := false


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	var is_shortcut: bool = event.keycode == KEY_F11 or (event.alt_pressed and event.keycode == KEY_ENTER)
	if not is_shortcut:
		return
	# Consume Alt+Enter before the dialogue sees Enter as an advance command.
	get_viewport().set_input_as_handled()
	toggle_fullscreen()


func toggle_fullscreen() -> void:
	if Engine.is_embedded_in_editor():
		if not _embedded_hint_shown:
			print("Fullscreen: hentikan game, pilih jendela tanpa toolbar di tab Game Godot, lalu F5 dan F11.")
			_embedded_hint_shown = true
		return
	var window := get_window()
	if window.mode in [Window.MODE_FULLSCREEN, Window.MODE_EXCLUSIVE_FULLSCREEN]:
		window.mode = _previous_mode
		if _previous_mode == Window.MODE_WINDOWED:
			window.size = _windowed_size
			window.position = _windowed_position
	else:
		_previous_mode = window.mode
		_windowed_size = window.size
		_windowed_position = window.position
		window.mode = Window.MODE_FULLSCREEN
