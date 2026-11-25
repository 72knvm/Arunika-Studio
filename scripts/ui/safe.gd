extends CanvasLayer
## Safe keypad, discovered item, and equipment confirmation.

signal closed
signal unlocked
signal equip_requested

const HOLO = preload("res://scripts/ui/holo_panel.gd")
const BELT: Texture2D = preload("res://assets/items/belt.png")
const BELT_REGION := Rect2(17, 35, 222, 59)
const INK := Color("d6edf0")
const MUTED := Color("9fc0c5")
const SURFACE := Color(0.08, 0.24, 0.3, .88)
const EDGE := Color("6095a0")
const KEYPAD_CLICK: AudioStream = preload("res://assets/audio/prolog/archive_select.ogg")
const KEYPAD_REJECT: AudioStream = preload("res://assets/audio/prolog/archive_error.ogg")

@onready var keypad_sound: AudioStreamPlayer = $KeypadSound

var state := "keypad"
var digits := ""
var modal: Control
var code_display: Label
var feedback: Label
var submit_button: Button
var equip_button: Button
var digit_buttons: Array[Button] = []
var _expected_code := ""
var _save_warning := ""
var _discovery_callback := ""


func _ready() -> void:
	var ending_dialogue: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogue/ending.json"))
	_discovery_callback = ending_dialogue.safe_callback.text
	var definition: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/puzzles/archive.json"))
	if definition is Dictionary:
		var code := str(definition.get("safe_code", ""))
		var pattern := RegEx.new()
		pattern.compile("^[0-9]{4}$")
		if pattern.search(code) != null:
			_expected_code = code
	hide()


func _style(color: Color, border := EDGE) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(1)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _button(parent: Node, text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 54)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 26)
	button.add_theme_color_override("font_color", INK)
	button.add_theme_color_override("font_hover_color", INK)
	button.add_theme_color_override("font_pressed_color", INK)
	button.add_theme_stylebox_override("normal", _style(SURFACE))
	button.add_theme_stylebox_override("hover", _style(Color("24505c"), Color("a7dde5")))
	button.add_theme_stylebox_override("pressed", _style(Color("102b34"), Color("d3ebef")))
	var focus := _style(Color.TRANSPARENT, INK)
	button.add_theme_stylebox_override("focus", focus)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.pressed.connect(action)
	parent.add_child(button)
	return button


func _clear_modal() -> void:
	if is_instance_valid(modal):
		remove_child(modal)
		modal.queue_free()
	modal = null
	digit_buttons.clear()


func _build_modal(title: String, size := Vector2(720, 790)) -> void:
	_clear_modal()
	modal = HOLO.new(title, size)
	modal.name = "SafePanel"
	modal.closed.connect(_on_closed)
	add_child(modal)
	show()


func _item_image(parent: Node, minimum: Vector2) -> TextureRect:
	var image := TextureRect.new()
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	var cutout := AtlasTexture.new()
	cutout.atlas = BELT
	cutout.region = BELT_REGION
	cutout.filter_clip = true
	image.texture = cutout
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size = minimum
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(image)
	return image


func _compact_button(parent: Node, text: String, action: Callable, width: float) -> Button:
	var button := _button(parent, text, action)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.custom_minimum_size.x = width
	return button


func _save_feedback() -> void:
	feedback = modal.add_label(_save_warning, 22)
	feedback.visible = not _save_warning.is_empty()


func open_safe(obtained: bool, equipped: bool) -> void:
	_save_warning = ""
	if equipped:
		show_equipped()
	elif obtained:
		show_item(false)
	else:
		_show_keypad()


func _show_keypad() -> void:
	state = "keypad"
	digits = ""
	_build_modal("Brankas Kakek")
	modal.add_label("Masukkan empat angka dari arsip Kakek.", 26)
	var display := PanelContainer.new()
	display.custom_minimum_size.y = 84
	display.add_theme_stylebox_override("panel", _style(Color("0a2029"), Color("75bbc8")))
	modal.content.add_child(display)
	code_display = Label.new()
	code_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	code_display.add_theme_font_size_override("font_size", 50)
	code_display.add_theme_color_override("font_color", INK)
	display.add_child(code_display)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 10)
	modal.content.add_child(grid)
	for number in range(1, 10):
		digit_buttons.append(_button(grid, str(number), _append_digit.bind(str(number))))
	_button(grid, "Hapus", _backspace)
	digit_buttons.append(_button(grid, "0", _append_digit.bind("0")))
	_button(grid, "Kosongkan", _clear_digits)
	feedback = modal.add_label("Kode dapat dibaca kembali di komputer.", 24)
	feedback.custom_minimum_size.y = 54
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 14)
	modal.content.add_child(actions)
	submit_button = _compact_button(actions, "Buka brankas", _submit, 280)
	_compact_button(actions, "Batal", cancel, 150)
	_update_digits()
	submit_button.disabled = _expected_code.is_empty()
	if _expected_code.is_empty():
		feedback.text = "Data kode brankas tidak dapat dimuat. Tutup dan coba lagi."
	digit_buttons[0].call_deferred("grab_focus")


func _available() -> bool:
	return visible and not get_tree().paused


func _append_digit(value: String) -> void:
	if not _available() or state != "keypad" or digits.length() >= 4:
		return
	digits += value
	keypad_sound.stream = KEYPAD_CLICK
	keypad_sound.play()
	feedback.text = "Tekan E, Enter, atau klik Buka brankas."
	_update_digits()


func _backspace() -> void:
	if not _available() or state != "keypad":
		return
	digits = digits.left(maxi(0, digits.length() - 1))
	_update_digits()


func _clear_digits() -> void:
	if not _available() or state != "keypad":
		return
	digits = ""
	_update_digits()


func _update_digits() -> void:
	var slots := PackedStringArray()
	for index in range(4):
		slots.append(digits[index] if index < digits.length() else "_")
	code_display.text = "  ".join(slots)


func _submit() -> void:
	if not _available() or state != "keypad" or _expected_code.is_empty():
		return
	if digits.length() != 4:
		feedback.text = "Isi keempat angka terlebih dahulu."
	elif digits != _expected_code:
		keypad_sound.stream = KEYPAD_REJECT
		keypad_sound.play()
		feedback.text = "Kode belum cocok. Periksa arsip Kakek dan coba lagi."
		digits = ""
		_update_digits()
	else:
		state = "unlocking"
		$UnlockSound.play()
		modal.hide()
		unlocked.emit()


func show_item(newly_obtained := true) -> void:
	state = "item"
	_build_modal("Diperoleh: Sabuk Kakek" if newly_obtained else "Sabuk Kakek", Vector2(900, 670))
	var stage := PanelContainer.new()
	stage.custom_minimum_size.y = 220
	var stage_style := _style(Color(0.34, 0.51, 0.56, .18), Color(0.45, 0.73, 0.79, .35))
	stage.add_theme_stylebox_override("panel", stage_style)
	modal.content.add_child(stage)
	_item_image(stage, Vector2(0, 196))
	modal.add_label("Saka: Ini dia... prototipe yang ada di catatan Kakek.", 28)
	if newly_obtained:
		modal.add_label("Saka: " + _discovery_callback, 26)
	var detail: Label = modal.add_label("Dudukan konektornya sesuai dengan modul yang Saka kerjakan semalam.", 25)
	detail.add_theme_color_override("font_color", MUTED)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 18)
	modal.content.add_child(actions)
	equip_button = _compact_button(actions, "Pakai sabuk", _request_equip, 240)
	_compact_button(actions, "Nanti", cancel, 150)
	_save_feedback()
	equip_button.call_deferred("grab_focus")


func _request_equip() -> void:
	if not _available() or state != "item":
		return
	state = "equipping"
	modal.hide()
	equip_requested.emit()


func show_equipped() -> void:
	state = "equipped"
	_build_modal("Sabuk terpasang", Vector2(860, 370))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 24)
	modal.content.add_child(row)
	_item_image(row, Vector2(220, 130))
	var line := Label.new()
	line.text = "Saka: Pas... sekarang tinggal menyambungkan modulnya ke lensa."
	line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	line.add_theme_font_size_override("font_size", 27)
	line.add_theme_color_override("font_color", INK)
	row.add_child(line)
	var actions := HBoxContainer.new()
	modal.content.add_child(actions)
	var done := _compact_button(actions, "Lanjutkan [E]", cancel, 250)
	_save_feedback()
	done.call_deferred("grab_focus")


func cancel() -> void:
	if not _available() or state in ["unlocking", "equipping"]:
		return
	if is_instance_valid(modal):
		modal.close()


func _on_closed() -> void:
	modal = null
	hide()
	closed.emit()


func dismiss() -> void:
	_clear_modal()
	hide()
	closed.emit()


func show_save_warning(message: String) -> void:
	_save_warning = message
	if is_instance_valid(feedback) and feedback.is_inside_tree():
		feedback.text = message
		feedback.visible = not message.is_empty()


func _input(event: InputEvent) -> void:
	if not _available() or not event is InputEventKey or not event.pressed or event.echo:
		return
	var code: int = event.physical_keycode
	if code == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		cancel()
	elif state == "equipped" and code == KEY_E:
		get_viewport().set_input_as_handled()
		cancel()
	elif state == "keypad":
		if code >= KEY_0 and code <= KEY_9:
			get_viewport().set_input_as_handled()
			_append_digit(str(code - KEY_0))
		elif code >= KEY_KP_0 and code <= KEY_KP_9:
			get_viewport().set_input_as_handled()
			_append_digit(str(code - KEY_KP_0))
		elif code == KEY_BACKSPACE:
			get_viewport().set_input_as_handled()
			_backspace()
		elif code in [KEY_E, KEY_ENTER, KEY_KP_ENTER]:
			get_viewport().set_input_as_handled()
			_submit()
