extends CanvasLayer
const MODAL = preload("res://scripts/ui/menu_modal.gd")
const SETTINGS = preload("res://scripts/ui/settings_panel.gd")
var panel: Control
var settings: Control
var status: Label
var resume_button: Button
var flow: Node

func _ready() -> void:
	layer = 110
	process_mode = Node.PROCESS_MODE_ALWAYS
	flow = get_parent()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo or event.physical_keycode != KEY_ESCAPE:
		return
	if is_instance_valid(settings):
		return
	get_viewport().set_input_as_handled()
	if not is_instance_valid(panel) and flow.has_method("cancel_active_interface") and flow.cancel_active_interface():
		return
	if is_instance_valid(panel):
		panel.close()
	else:
		_open()

func _open() -> void:
	get_tree().paused = true
	panel = MODAL.new("Pause", Vector2(820, 720))
	status = panel.add_label("Autosave saat masuk scene baru.\nMelanjutkan permainan mengulang dari awal scene tersebut." if SaveManager.has_save() else "Belum ada checkpoint tersimpan.\nAutosave pertama saat masuk jembatan.", 27)
	resume_button = panel.add_button("Lanjutkan", panel.close)
	panel.add_button("Settings", _settings)
	panel.add_button("Main Menu", _main_menu)
	panel.add_button("Exit", _exit)
	panel.closed.connect(_resume)
	add_child(panel)
	resume_button.grab_focus()

func _resume() -> void:
	panel = null
	get_tree().paused = false

func _settings() -> void:
	panel.hide()
	panel.set_process_input(false)
	settings = SETTINGS.new()
	settings.closed.connect(func():
		settings = null
		panel.show()
		panel.set_process_input(true)
		resume_button.grab_focus())
	add_child(settings)

func _main_menu() -> void:
	get_tree().paused = false
	get_viewport().canvas_transform = Transform2D.IDENTITY
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _exit() -> void:
	get_tree().quit()
