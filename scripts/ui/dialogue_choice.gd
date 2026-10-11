extends Control
## Explicit selection; reuses the same textbox skin as manual dialogue.

signal option_selected(id: String)

@onready var box: Control = $Box
@onready var buttons: Array[Button] = [$First, $Second]
var options: Array = []


func _ready() -> void:
	box.locked = true
	box.body.position.y = 680.0
	box.body.size.y = 55.0
	box.body.add_theme_font_size_override("normal_font_size", 34)
	for index in buttons.size():
		buttons[index].pressed.connect(_select.bind(index))


func show_choices(question: String, choices: Array) -> void:
	options = choices
	box.show_line("Saka", question)
	box.reveal_all()
	box.hint.text = "1 / 2: Pilih  ·  ←/→ + Enter atau klik"
	for index in buttons.size():
		buttons[index].text = "%d. %s" % [index + 1, options[index].label]
	show()
	buttons[0].grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.physical_keycode in [KEY_1, KEY_2, KEY_KP_1, KEY_KP_2]:
		get_viewport().set_input_as_handled()
		_select(0 if event.physical_keycode in [KEY_1, KEY_KP_1] else 1)


func _select(index: int) -> void:
	if not visible:
		return
	var id: String = options[index].id
	for button in buttons:
		button.release_focus()
	hide()
	# Defer opening the answer so this selection event cannot also advance it.
	option_selected.emit.call_deferred(id)
