extends Node2D

const LAYOUT = preload("res://scripts/ui/menu_layout.gd")
const MODAL = preload("res://scripts/ui/menu_modal.gd")
const SETTINGS = preload("res://scripts/ui/settings_panel.gd")
var menu_controls: Control
var menu_buttons: Array[Button] = []
var modal: Control
var starting := false
var last_focus: Button

func _ready() -> void:
	get_viewport().canvas_transform = Transform2D.IDENTITY
	create_tween().tween_property($MenuTheme, "volume_db", -12.0, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var layout: Dictionary = LAYOUT.build($Interface)
	menu_controls = layout.controls
	menu_buttons.assign(layout.buttons)
	for button in menu_buttons:
		button.pressed.connect(MenuAudio.play)
	menu_buttons[0].pressed.connect(_continue_game)
	menu_buttons[1].pressed.connect(_new_game)
	menu_buttons[2].pressed.connect(_show_load)
	menu_buttons[3].pressed.connect(func(): _open(SETTINGS.new(), menu_buttons[3]))
	menu_buttons[4].pressed.connect(_show_credits)
	menu_buttons[5].pressed.connect(_confirm_exit)
	_refresh()

func _refresh() -> void:
	var available := SaveManager.has_save()
	LAYOUT.set_save_available(menu_buttons, available)
	(menu_buttons[0] if available else menu_buttons[1]).grab_focus()

func _open(panel: Control, source: Button) -> void:
	if is_instance_valid(modal):
		panel.free()
		return
	last_focus = source
	modal = panel
	for button in menu_buttons:
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Interface.add_child(panel)
	panel.closed.connect(_close_modal)

func _close_modal() -> void:
	modal = null
	for button in menu_buttons:
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_filter = Control.MOUSE_FILTER_STOP
	if is_instance_valid(last_focus):
		last_focus.grab_focus()

func _new_game() -> void:
	if not SaveManager.has_save():
		_start_new()
		return
	var panel := MODAL.new("New Game", Vector2(780, 440))
	panel.add_label("Mulai prolog dari awal? Autosave sebelumnya akan diganti setelah mencapai checkpoint baru.")
	panel.add_button("Mulai dari awal", _start_new)
	var cancel := panel.add_button("Kembali", panel.close)
	_open(panel, menu_buttons[1])
	cancel.grab_focus()

func _start_new() -> void:
	SaveManager.prepare_new_game()
	_start_loading()

func _continue_game() -> void:
	if SaveManager.prepare_load():
		_start_loading()
	else:
		_refresh()
		var panel := MODAL.new("Save tidak tersedia", Vector2(780, 390))
		panel.add_label("Autosave tidak ditemukan atau datanya tidak valid.")
		var back := panel.add_button("Kembali", panel.close)
		_open(panel, menu_buttons[1])
		back.grab_focus()

func _start_loading() -> void:
	if starting:
		return
	starting = true
	var error := get_tree().change_scene_to_file("res://scenes/menu/loading_screen.tscn")
	if error != OK:
		starting = false
		push_error("Loading scene tidak bisa dibuka: %s" % error_string(error))

func _show_load() -> void:
	var data := SaveManager.read_checkpoint()
	if data.is_empty():
		_continue_game()
		return
	var panel := MODAL.new("Load Game", Vector2(780, 520))
	panel.add_label("Autosave — " + SaveManager.checkpoint_name(data), 36)
	panel.add_label("Disimpan: " + data.saved_at_label, 28)
	panel.add_label("Melanjutkan dari awal scene terakhir yang tersimpan." if data.get("scope", "") == "scene_entry" else "Memulihkan checkpoint cerita terakhir, termasuk pilihan dialog.", 28)
	if data.get("recovered_backup", false):
		panel.add_label("Save utama rusak. Backup terakhir tersedia.", 26)
	panel.add_button("Muat checkpoint", _continue_game)
	var back := panel.add_button("Kembali", panel.close)
	_open(panel, menu_buttons[2])
	back.grab_focus()

func _show_credits() -> void:
	var panel := MODAL.new("Credits", Vector2(820, 620))
	panel.add_label("KALA\nSingkap Garis Waktu", 40)
	panel.add_label("Game, cerita & desain\nArunika Studio", 30)
	panel.add_label("Engine\nGodot Engine", 30)
	panel.add_label("Font\nPixelify Sans — Stefie Justprince\nSIL Open Font License 1.1", 28)
	panel.add_label("Musik menu\nCursed Light — Cethiel (CC0)", 28)
	var back := panel.add_button("Kembali", panel.close)
	_open(panel, menu_buttons[4])
	back.grab_focus()

func _confirm_exit() -> void:
	var panel := MODAL.new("Keluar dari game?", Vector2(780, 360))
	panel.add_button("Keluar", func(): get_tree().quit())
	var cancel := panel.add_button("Kembali", panel.close)
	_open(panel, menu_buttons[5])
	cancel.grab_focus()
