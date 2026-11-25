extends Control
## A reusable keyboard-accessible modal. Its owner restores focus on close.
signal closed
const UI_THEME = preload("res://assets/themes/pixelify.tres")
var content: VBoxContainer
var heading: Label
var panel: PanelContainer
var closing := false

func _init(title_text: String = "", panel_size := Vector2(780, 690)) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = UI_THEME
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var veil := ColorRect.new()
	veil.color = Color(0.015, 0.025, 0.06, 0.82)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(veil)
	panel = PanelContainer.new()
	panel.position = (Vector2(1672, 941) - panel_size) / 2
	panel.size = panel_size
	var style := StyleBoxFlat.new()
	style.bg_color = Color("17213b")
	style.border_color = Color("9b917d")
	style.set_border_width_all(2)
	style.content_margin_left = 38
	style.content_margin_right = 38
	style.content_margin_top = 28
	style.content_margin_bottom = 28
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 20)
	panel.add_child(content)
	heading = add_label(title_text, 52)

func add_label(text: String, font_size := 30) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	content.add_child(label)
	return label

func add_button(text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 55
	button.pressed.connect(MenuAudio.play)
	button.pressed.connect(action)
	content.add_child(button)
	return button

func close() -> void:
	if closing:
		return
	closing = true
	closed.emit()
	queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()
