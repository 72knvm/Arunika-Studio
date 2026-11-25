extends CanvasLayer
## In-world desktop and guided archive recovery with shared pixel-art UI assets.

signal closed
signal recovery_completed(safe_code: String)

const RECOVERY = preload("res://scripts/ui/archive_session.gd")
const PALETTE = preload("res://scripts/ui/computer_palette.gd")
const MONITOR_TEXTURE: Texture2D = preload("res://assets/ui/computer/monitor.tres")
const DESKTOP_ICON = preload("res://scripts/ui/desktop_icon.gd")
const SCREEN_RECT := Rect2(178, 178, 1316, 682)
const APPS := [
	{"id": "computer", "name": "Komputer Saya", "status": "Perangkat lokal"},
	{"id": "messages", "name": "Pesan", "status": "Kotak masuk"},
	{"id": "network", "name": "Jaringan", "status": "Layanan kota"},
	{"id": "archive", "name": "Arsip Kakek", "status": "Berkas pribadi"}
]
const DATA_PATH := "res://data/puzzles/archive.json"
const DIALOGUE_PATH := "res://data/dialogue/computer.json"
const RECOVERY_SELECT: AudioStream = preload("res://assets/audio/prolog/archive_select.ogg")
const RECOVERY_ERROR: AudioStream = preload("res://assets/audio/prolog/archive_error.ogg")
const RECOVERY_SUCCESS: AudioStream = preload("res://assets/audio/prolog/archive_success.ogg")
const INK := PALETTE.INK
const MUTED := PALETTE.MUTED
const EDGE := PALETTE.EDGE
const SURFACE := PALETTE.PANEL
const RECESS := PALETTE.NIGHT
const ACCENT := PALETTE.WARM
const WARNING := PALETTE.WARM
const TIMER_WARNING_THRESHOLD := 15.0

@onready var _recovery_sound: AudioStreamPlayer = $RecoverySound
@onready var _timer_warning: AudioStreamPlayer = $TimerWarning

var _time_warning_played := false
var recovery = RECOVERY.new()
var grid_state = recovery.grid
var definition: Dictionary = {}
var recovered := false
var safe_opened := false
var screen := "desktop"
var cell_buttons: Array[Button] = []
var folder_button: Button
var repair_button: Button
var start_button: Button
var retry_button: Button
var hint_button: Button
var round_heading: Label
var time_bar: ProgressBar
var _time_fill: StyleBoxFlat
var _recovery_guide: PanelContainer
var feedback: Label
var _root: Control
var _body: VBoxContainer
var _heading: Label
var _footer: Label
var _target_labels: Array[Label] = []
var _input_labels: Array[Label] = []
var _hint_index := -1
var _preview_index := -1
var _pointer_mode := false
var _matrix_overlay: Control
var _preview_band: ColorRect
var _cell_cursor: Panel
var _cursor_inset: Panel
var _data_valid := false
var _save_warning := ""
var app_buttons: Dictionary = {}
var notice_text: Label
var monitor_panel: PanelContainer
var _app_icons: Dictionary = {}
var _failed_apps: Dictionary = {}
var _notice: PanelContainer
var _notice_layer: Control
var _notice_timer: Timer
var _notice_app := ""
var notice_close_button: Button
var _monitor_art: TextureRect
var _back_button: Button
var _nav_buttons: Dictionary = {}
var _active_tab := "files"
var _dialogue: Dictionary = {}
var _document_layer: Control
var document_window: PanelContainer
var document_close_button: Button
var _document_content: VBoxContainer
var commentary_text: Label
var _commentary_timer: Timer
var _reading_timer: Timer
var _commentary_queue: Array[String] = []
var _commentary_seen: Dictionary = {}


func _ready() -> void:
	var dialogue_data: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIALOGUE_PATH))
	if dialogue_data is Dictionary:
		_dialogue = dialogue_data
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if parsed is Dictionary:
		definition = parsed
		var code_pattern := RegEx.new()
		code_pattern.compile("^[0-9]{4}$")
		_data_valid = recovery.configure(definition) and code_pattern.search(str(definition.get("safe_code", ""))) != null
	_build_window()
	hide()


func _process(delta: float) -> void:
	if not _available() or screen != "puzzle" or recovery.state != "active":
		return
	if recovery.advance_time(delta):
		_show_timeout()
	else:
		_update_clock()


func _style(fill: Color, border := EDGE, width := 1, margin := 8.0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.content_margin_left = margin
	style.content_margin_right = margin
	style.content_margin_top = margin
	style.content_margin_bottom = margin
	return style


func _label(parent: Node, text: String, font_size := 28, color := INK) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _button(parent: Node, text: String, action: Callable, minimum_width := 0.0) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(minimum_width, 38)
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_color_override("font_color", INK)
	button.add_theme_color_override("font_hover_color", INK)
	button.add_theme_color_override("font_pressed_color", INK)
	button.add_theme_color_override("font_focus_color", INK)
	button.add_theme_color_override("font_disabled_color", MUTED)
	button.add_theme_stylebox_override("normal", _style(SURFACE))
	button.add_theme_stylebox_override("hover", _style(SURFACE, PALETTE.CYAN))
	button.add_theme_stylebox_override("pressed", _style(RECESS, ACCENT))
	button.add_theme_stylebox_override("disabled", _style(RECESS, EDGE))
	button.add_theme_stylebox_override("focus", _style(Color(0, 0, 0, 0), PALETTE.CYAN, 2, 0))
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.pressed.connect(action)
	parent.add_child(button)
	return button


func _vbox(parent: Node, separation := 10) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", separation)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(box)
	return box


func _row(parent: Node, separation := 12) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", separation)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(row)
	return row


func _build_window() -> void:
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var terminal_theme := Theme.new()
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Consolas", "Liberation Mono", "DejaVu Sans Mono"])
	terminal_theme.default_font = font
	terminal_theme.default_font_size = 22
	_root.theme = terminal_theme
	_root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_root)
	var veil := ColorRect.new()
	veil.color = PALETTE.SHADOW
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.add_child(veil)
	_monitor_art = TextureRect.new()
	_monitor_art.name = "RoomMonitorCloseup"
	_monitor_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_monitor_art.texture = MONITOR_TEXTURE
	_monitor_art.size = Vector2(1672, 941)
	_monitor_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_monitor_art)
	monitor_panel = PanelContainer.new()
	monitor_panel.name = "Screen"
	monitor_panel.position = SCREEN_RECT.position
	monitor_panel.size = SCREEN_RECT.size
	monitor_panel.clip_contents = true
	monitor_panel.add_theme_stylebox_override("panel", _style(RECESS, EDGE, 2, 8))
	_root.add_child(monitor_panel)
	var stack := _vbox(monitor_panel, 8)
	var tabs := _row(stack, 8)
	_back_button = _button(tabs, "<<", _navigate_back, 48)
	_back_button.custom_minimum_size.y = 56
	_build_tab(tabs, "files", "BERKAS", "archive", _show_desktop)
	_build_tab(tabs, "messages", "PESAN", "messages", _open_app_tab.bind("messages"))
	_build_tab(tabs, "network", "JARINGAN", "network", _open_app_tab.bind("network"))
	var tab_space := Control.new()
	tab_space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.add_child(tab_space)
	_button(tabs, "KELUAR [ESC]", close_computer, 190)
	var titlebar := PanelContainer.new()
	titlebar.add_theme_stylebox_override("panel", _style(SURFACE, EDGE, 1, 7))
	stack.add_child(titlebar)
	_heading = _label(titlebar, "", 22, INK)
	_set_active_tab("files")
	_body = _vbox(stack, 8)
	_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_footer = _label(stack, "", 18, MUTED)
	_footer.hide()
	_notice_timer = Timer.new()
	_notice_timer.one_shot = true
	_notice_timer.wait_time = 3.8
	_notice_timer.timeout.connect(_dismiss_notice)
	add_child(_notice_timer)
	_document_layer = Control.new()
	_document_layer.name = "ArchiveWindowLayer"
	_document_layer.position = SCREEN_RECT.position
	_document_layer.size = SCREEN_RECT.size
	_document_layer.clip_contents = true
	_root.add_child(_document_layer)
	_document_layer.hide()
	_build_app_notice()
	_build_commentary()


func _build_commentary() -> void:
	commentary_text = _label(_root, "", 30)
	commentary_text.theme = preload("res://assets/themes/pixelify.tres")
	commentary_text.name = "SakaCommentary"
	commentary_text.position = Vector2(96, 860)
	commentary_text.size = Vector2(1480, 81)
	commentary_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	commentary_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	commentary_text.add_theme_color_override("font_shadow_color", PALETTE.SHADOW)
	commentary_text.add_theme_constant_override("shadow_offset_x", 2)
	commentary_text.add_theme_constant_override("shadow_offset_y", 2)
	commentary_text.hide()
	_commentary_timer = Timer.new()
	_commentary_timer.one_shot = true
	_commentary_timer.timeout.connect(_next_commentary)
	add_child(_commentary_timer)
	_reading_timer = Timer.new()
	_reading_timer.one_shot = true
	_reading_timer.wait_time = 8.0
	_reading_timer.timeout.connect(_comment_on_note)
	add_child(_reading_timer)


func _clear_commentary() -> void:
	_commentary_queue.clear()
	_commentary_timer.stop()
	_reading_timer.stop()
	commentary_text.hide()
	commentary_text.text = ""


func _say_once(id: String, interrupt := false) -> void:
	if _commentary_seen.has(id) or not _dialogue.has(id):
		return
	_commentary_seen[id] = true
	if interrupt:
		_commentary_queue.clear()
		_commentary_timer.stop()
	_commentary_queue.append(str(_dialogue[id]))
	if _commentary_timer.is_stopped():
		_next_commentary()


func _next_commentary() -> void:
	if not visible or _commentary_queue.is_empty():
		commentary_text.hide()
		return
	var line: String = _commentary_queue.pop_front()
	commentary_text.text = "Saka: " + line
	commentary_text.show()
	var hold := maxf(3.0, line.split(" ", false).size() / 3.0 + 1.2)
	_commentary_timer.start(hold)


func _comment_on_note() -> void:
	if _available() and screen == "archive" and not safe_opened:
		_say_once("connector")


func _close_document() -> void:
	_document_layer.hide()
	if is_instance_valid(document_window):
		_document_layer.remove_child(document_window)
		document_window.queue_free()
	document_window = null
	document_close_button = null
	_document_content = null


func _open_document(title: String, height: float) -> VBoxContainer:
	_close_document()
	document_window = PanelContainer.new()
	document_window.name = "ArchiveWindow"
	document_window.size = Vector2(900, height)
	document_window.position = Vector2(SCREEN_RECT.size.x - document_window.size.x - 28, minf(190, SCREEN_RECT.size.y - height - 28))
	document_window.add_theme_stylebox_override("panel", _style(RECESS, PALETTE.CYAN, 2, 2))
	_document_layer.add_child(document_window)
	var stack := _vbox(document_window, 0)
	var titlebar := PanelContainer.new()
	titlebar.add_theme_stylebox_override("panel", _style(SURFACE, EDGE, 0, 8))
	stack.add_child(titlebar)
	var bar := _row(titlebar, 12)
	var caption := _label(bar, title, 23)
	caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	document_close_button = _button(bar, "X", _show_desktop, 44)
	document_close_button.tooltip_text = "Tutup jendela"
	var margin := MarginContainer.new()
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 18)
	stack.add_child(margin)
	_document_content = _vbox(margin, 12)
	_document_layer.show()
	return _document_content


func _build_tab(parent: Node, id: String, caption: String, icon_kind: String, action: Callable) -> void:
	var button := _button(parent, caption, action, 220)
	button.custom_minimum_size.y = 56
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_font_size_override("font_size", 24)
	for style_name in ["normal", "hover", "pressed", "disabled"]:
		var style := button.get_theme_stylebox(style_name) as StyleBoxFlat
		style.content_margin_left = 58
		style.content_margin_right = 14
		style.content_margin_top = 12
		style.content_margin_bottom = 12
	var icon := DESKTOP_ICON.new()
	icon.kind = icon_kind
	icon.show_frame = false
	icon.position = Vector2(12, 13)
	icon.scale = Vector2.ONE * .32
	button.add_child(icon)
	_nav_buttons[id] = button


func _set_active_tab(id: String) -> void:
	_active_tab = id
	for key: String in _nav_buttons:
		var button: Button = _nav_buttons[key]
		var active := key == id
		var style := _style(SURFACE if active else RECESS, PALETTE.CYAN if active else EDGE, 1, 12)
		style.content_margin_left = 58
		style.content_margin_right = 14
		style.border_width_bottom = 3 if active else 1
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_color_override("font_color", INK if active else MUTED)


func _build_app_notice() -> void:
	_notice_layer = Control.new()
	_notice_layer.name = "ApplicationErrorLayer"
	_notice_layer.position = SCREEN_RECT.position
	_notice_layer.size = SCREEN_RECT.size
	_root.add_child(_notice_layer)
	var shade := ColorRect.new()
	shade.color = Color(PALETTE.SHADOW, .2)
	shade.size = SCREEN_RECT.size
	_notice_layer.add_child(shade)
	_notice = PanelContainer.new()
	_notice.name = "ApplicationError"
	_notice.size = Vector2(460, 300)
	_notice.position = (SCREEN_RECT.size - _notice.size) * .5
	_notice.add_theme_stylebox_override("panel", _style(SURFACE, WARNING, 2, 18))
	_notice_layer.add_child(_notice)
	var content := _vbox(_notice, 8)
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	var cross := _label(content, "X", 112, WARNING)
	cross.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice_text = _label(content, "", 25, INK)
	notice_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var actions := _row(content)
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	notice_close_button = _button(actions, "OK", _dismiss_notice, 130)
	_notice.hide()
	_notice_layer.hide()


func _dismiss_notice(restore_focus := true) -> void:
	_notice.hide()
	_notice_layer.hide()
	_notice_timer.stop()
	if screen == "desktop":
		_set_active_tab("files")
	if restore_focus and screen == "desktop" and app_buttons.has(_notice_app):
		_focus_later(app_buttons[_notice_app])


func _navigate_back() -> void:
	if _available() and screen != "desktop":
		_show_desktop()


func _open_app_tab(id: String) -> void:
	if not _available():
		return
	if screen != "desktop":
		_show_desktop()
	_set_active_tab(id)
	_show_app_error(id)


func open_computer(already_recovered := false, opened_safe := false) -> void:
	recovery.reset()
	_hint_index = -1
	recovered = already_recovered
	safe_opened = opened_safe
	_save_warning = ""
	_failed_apps.clear()
	_commentary_seen.clear()
	_clear_commentary()
	show()
	_show_desktop()


func close_computer() -> void:
	if not visible:
		return
	_recovery_sound.stop()
	_timer_warning.stop()
	hide()
	if recovery.state != "complete":
		recovery.reset()
	_close_document()
	_clear_commentary()
	_dismiss_notice(false)
	var focus := get_viewport().gui_get_focus_owner()
	if is_instance_valid(focus) and _root.is_ancestor_of(focus):
		focus.release_focus()
	closed.emit()


func cancel() -> void:
	if _notice.visible:
		_dismiss_notice()
		return
	if screen == "desktop":
		close_computer()
	else:
		_show_desktop()


func _input(event: InputEvent) -> void:
	if _available() and screen == "puzzle":
		if event is InputEventMouseMotion or event is InputEventMouseButton:
			_pointer_mode = true
			call_deferred("_preview_at_pointer")
		elif event is InputEventKey and event.pressed and event.physical_keycode in [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_TAB, KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
			_pointer_mode = false
			call_deferred("_preview_focused_cell")
	if visible and event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		cancel()


func _available() -> bool:
	return visible and not get_tree().paused


func _clear_body() -> void:
	_preview_index = -1
	_pointer_mode = false
	_matrix_overlay = null
	_preview_band = null
	_cell_cursor = null
	_cursor_inset = null
	_close_document()
	_clear_commentary()
	_back_button.disabled = false
	_set_active_tab("files")
	_dismiss_notice(false)
	_footer.hide()
	app_buttons.clear()
	_app_icons.clear()
	for child in _body.get_children():
		_body.remove_child(child)
		child.queue_free()
	cell_buttons.clear()
	_target_labels.clear()
	_input_labels.clear()


func _focus_later(control: Control) -> void:
	call_deferred("_focus_control", control)


func _focus_control(control: Control) -> void:
	if is_instance_valid(control) and visible and control.is_visible_in_tree() and not get_tree().paused:
		control.grab_focus()


func _show_desktop() -> void:
	if not _available():
		return
	if recovery.state in ["active", "failed"]:
		recovery.reset()
		_hint_index = -1
	_clear_body()
	screen = "desktop"
	_back_button.disabled = true
	_heading.text = "BERKAS LOKAL     //     SAKA"
	var browser := PanelContainer.new()
	browser.name = "LocalBrowser"
	browser.size_flags_vertical = Control.SIZE_EXPAND_FILL
	browser.add_theme_stylebox_override("panel", _style(RECESS, EDGE, 1, 22))
	_body.add_child(browser)
	var workspace := _vbox(browser, 20)
	var location := _label(workspace, "LOKAL / APLIKASI", 22, MUTED)
	location.custom_minimum_size.y = 30
	var apps := GridContainer.new()
	apps.columns = 4
	apps.add_theme_constant_override("h_separation", 28)
	apps.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	workspace.add_child(apps)
	for app: Dictionary in APPS:
		var id: String = app.id
		var failed: bool = _failed_apps.has(id)
		var action := _open_folder if id == "archive" else _show_app_error.bind(id)
		var title: String = app.name.to_upper()
		var button := _button(apps, title + ("\nRUSAK" if failed else ""), action, 224)
		button.name = id.capitalize() + "App"
		button.custom_minimum_size.y = 206
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.add_theme_font_size_override("font_size", 22)
		button.tooltip_text = app.status
		for style_name in ["normal", "hover", "pressed", "disabled"]:
			var style := _style(Color.TRANSPARENT, Color.TRANSPARENT, 0, 4)
			style.content_margin_top = 138
			style.content_margin_bottom = 8
			if style_name == "hover":
				style.bg_color = Color(PALETTE.CYAN, .04)
			if style_name == "pressed":
				style.bg_color = Color(PALETTE.CYAN, .09)
			button.add_theme_stylebox_override(style_name, style)
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		if failed:
			button.add_theme_color_override("font_color", WARNING)
		var icon := DESKTOP_ICON.new()
		icon.kind = id
		icon.failed = failed
		icon.position = Vector2(28, 10)
		icon.scale = Vector2.ONE * 1.5
		button.add_child(icon)
		button.mouse_entered.connect(icon.set_hovered.bind(true))
		button.mouse_exited.connect(icon.set_hovered.bind(false))
		button.focus_entered.connect(icon.set_focused.bind(true))
		button.focus_exited.connect(icon.set_focused.bind(false))
		app_buttons[id] = button
		_app_icons[id] = icon
		if id == "archive":
			folder_button = button
	var space := Control.new()
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	space.mouse_filter = Control.MOUSE_FILTER_IGNORE
	workspace.add_child(space)
	_focus_later(app_buttons["computer"])


func _show_app_error(id: String) -> void:
	if not _available() or screen != "desktop" or _notice.visible:
		return
	for app: Dictionary in APPS:
		if app.id != id:
			continue
		var first_failure := not _failed_apps.has(id)
		_failed_apps[id] = true
		if first_failure:
			_say_once("app_failure_%d" % _failed_apps.size(), true)
		var button: Button = app_buttons[id]
		button.text = app.name.to_upper() + "\nRUSAK"
		button.add_theme_color_override("font_color", WARNING)
		_app_icons[id].failed = true
		_notice_app = id
		notice_text.text = "Aplikasi korup"
		_notice_layer.show()
		_notice.show()
		_notice_timer.start()
		_focus_later(notice_close_button)
		return


func _open_folder() -> void:
	if not _available():
		return
	if recovered:
		_show_archive()
	else:
		_show_error()


func _show_error() -> void:
	if not _available():
		return
	_show_desktop()
	screen = "error"
	_back_button.disabled = false
	var content := _open_document("Arsip Kakek", 320)
	_label(content, "Arsip tidak dapat dibuka", 32)
	_label(content, "Indeks data rusak setelah gangguan daya.", 24, WARNING)
	_label(content, "Salinan cadangan masih tersedia. Pulihkan jalur pembacaan arsip melalui verifikasi blok data.", 24)
	var space := Control.new()
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(space)
	var actions := _row(content)
	repair_button = _button(actions, "Pulihkan arsip", _show_puzzle, 330)
	_button(actions, "Kembali ke berkas", _show_desktop, 310)
	_say_once("archive_damaged")
	_focus_later(repair_button)


func _token_strip(parent: Node, values: Array[String], framed := true) -> Array[Label]:
	var labels: Array[Label] = []
	var row := _row(parent, 10)
	for value in values:
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(80, 49)
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.add_theme_stylebox_override("panel", _style(RECESS if framed else Color.TRANSPARENT, EDGE if framed else Color.TRANSPARENT, 1 if framed else 0, 8))
		row.add_child(panel)
		var label := _label(panel, value, 28)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labels.append(label)
	return labels


func _code_heading(parent: Node, title: String) -> Label:
	var band := PanelContainer.new()
	band.add_theme_stylebox_override("panel", _style(PALETTE.CYAN, Color.TRANSPARENT, 0, 10))
	parent.add_child(band)
	return _label(band, title, 22, RECESS)


func _build_matrix_cursor(parent: Control) -> void:
	_matrix_overlay = Control.new()
	_matrix_overlay.name = "MatrixPreview"
	_matrix_overlay.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_matrix_overlay.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_matrix_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_matrix_overlay.clip_contents = true
	parent.add_child(_matrix_overlay)
	_matrix_overlay.resized.connect(_render_preview)
	_preview_band = ColorRect.new()
	_preview_band.color = Color(PALETTE.CYAN, .09)
	_preview_band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_matrix_overlay.add_child(_preview_band)
	_cell_cursor = Panel.new()
	_cell_cursor.name = "SelectionFrame"
	_cell_cursor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cell_cursor.add_theme_stylebox_override("panel", _style(Color.TRANSPARENT, PALETTE.CYAN, 2, 0))
	_matrix_overlay.add_child(_cell_cursor)
	_cursor_inset = Panel.new()
	_cursor_inset.position = Vector2(4, 4)
	_cursor_inset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cursor_inset.add_theme_stylebox_override("panel", _style(Color.TRANSPARENT, Color(PALETTE.CYAN, .45), 1, 0))
	_cell_cursor.add_child(_cursor_inset)
	_matrix_overlay.hide()


func _hover_cell(index: int) -> void:
	if not _available() or screen != "puzzle" or recovery.state != "active":
		return
	_pointer_mode = true
	_set_preview(index)


func _leave_cell(index: int) -> void:
	if _pointer_mode and _preview_index == index and _available():
		_set_preview(-1)


func _focus_cell(index: int) -> void:
	if not _pointer_mode:
		_set_preview(index)


func _unfocus_cell(index: int) -> void:
	if not _pointer_mode and _preview_index == index and _available():
		_set_preview(-1)


func _preview_at_pointer() -> void:
	if _pointer_mode and _available() and screen == "puzzle":
		var hovered := get_viewport().gui_get_hovered_control()
		_set_preview(cell_buttons.find(hovered) if hovered is Button else -1)


func _preview_focused_cell() -> void:
	if _pointer_mode or not _available() or screen != "puzzle":
		return
	var focused := get_viewport().gui_get_focus_owner()
	_set_preview(cell_buttons.find(focused) if focused is Button else -1)


func _set_preview(index: int, force := false) -> void:
	if not _available() or screen != "puzzle" or recovery.state != "active" or not grid_state.allowed_indices().has(index):
		index = -1
	if index == _preview_index and not force:
		return
	_preview_index = index
	_render_preview()


func _render_preview() -> void:
	var count: int = grid_state.path.size()
	var has_preview: bool = _available() and screen == "puzzle" and recovery.state == "active" and grid_state.allowed_indices().has(_preview_index)
	for index in range(_input_labels.size()):
		var label := _input_labels[index]
		var committed := index < count
		var ghost: bool = has_preview and index == count
		label.text = grid_state.cells[grid_state.path[index]] if committed else (grid_state.cells[_preview_index] if ghost else "")
		label.add_theme_color_override("font_color", INK if committed else Color(PALETTE.CYAN, .8))
		var panel := label.get_parent() as PanelContainer
		panel.add_theme_stylebox_override("panel", _style(SURFACE if committed else RECESS, PALETTE.CYAN if committed or ghost else EDGE, 2 if ghost else 1, 8))
	for index in range(_target_labels.size()):
		var label := _target_labels[index]
		label.text = grid_state.sequence[index]
		var matched := index < count
		var next_matches: bool = has_preview and index == count and grid_state.cells[_preview_index] == grid_state.next_token()
		label.add_theme_color_override("font_color", INK if matched else (WARNING if index == count else MUTED))
		var panel := label.get_parent() as PanelContainer
		panel.add_theme_stylebox_override("panel", _style(SURFACE if matched else Color.TRANSPARENT, PALETTE.CYAN if matched or next_matches else Color.TRANSPARENT, 1 if matched or next_matches else 0, 8))
	if not is_instance_valid(_matrix_overlay):
		return
	_matrix_overlay.visible = has_preview
	if not has_preview:
		return
	var button := cell_buttons[_preview_index]
	var cell := Rect2(button.global_position - _matrix_overlay.global_position, button.size)
	_cell_cursor.position = cell.position
	_cell_cursor.size = cell.size
	_cursor_inset.size = cell.size - Vector2(8, 8)
	var next_is_column := count % 2 == 0
	_preview_band.position = Vector2(cell.position.x, 0) if next_is_column else Vector2(0, cell.position.y)
	_preview_band.size = Vector2(cell.size.x, _matrix_overlay.size.y) if next_is_column else Vector2(_matrix_overlay.size.x, cell.size.y)


func _show_puzzle() -> void:
	if not _available():
		return
	if recovered:
		_show_archive()
		return
	if not _data_valid:
		_footer.text = "Data pemulihan tidak dapat dimuat. Kembali ke berkas untuk mencoba lagi."
		_footer.show()
		return
	_clear_body()
	screen = "puzzle"
	_heading.text = "ARSIP KAKEK / PULIHKAN INDEKS"
	var columns := _row(_body, 24)
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var left := _vbox(columns, 12)
	_label(left, "SISA WAKTU", 22, MUTED)
	var time_slot := MarginContainer.new()
	time_slot.custom_minimum_size.y = 49
	time_slot.add_theme_constant_override("margin_top", 18)
	time_slot.add_theme_constant_override("margin_bottom", 18)
	left.add_child(time_slot)
	time_bar = ProgressBar.new()
	time_bar.name = "RecoveryTime"
	time_bar.custom_minimum_size.y = 12
	time_bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	time_bar.max_value = RECOVERY.TIME_LIMIT
	time_bar.step = 0
	time_bar.show_percentage = false
	time_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_bar.add_theme_stylebox_override("background", _style(RECESS, EDGE, 1, 0))
	_time_fill = _style(PALETTE.CYAN, Color.TRANSPARENT, 0, 0)
	time_bar.add_theme_stylebox_override("fill", _time_fill)
	time_slot.add_child(time_bar)
	var matrix := PanelContainer.new()
	matrix.add_theme_stylebox_override("panel", _style(RECESS, EDGE, 1, 0))
	left.add_child(matrix)
	var matrix_stack := _vbox(matrix, 0)
	_code_heading(matrix_stack, "MATRIKS KODE")
	var matrix_margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		matrix_margin.add_theme_constant_override("margin_" + side, 12)
	matrix_stack.add_child(matrix_margin)
	var grid := GridContainer.new()
	grid.name = "CodeGrid"
	grid.columns = grid_state.columns
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)
	matrix_margin.add_child(grid)
	for index in range(grid_state.cells.size()):
		var button := _button(grid, grid_state.cells[index], _choose_cell.bind(index))
		button.name = "Cell%02d" % index
		button.custom_minimum_size = Vector2(116, 64)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 32)
		button.add_theme_stylebox_override("hover", _style(SURFACE, Color.TRANSPARENT, 0, 0))
		button.add_theme_stylebox_override("pressed", _style(SURFACE, Color.TRANSPARENT, 0, 0))
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		button.mouse_entered.connect(_hover_cell.bind(index))
		button.mouse_exited.connect(_leave_cell.bind(index))
		button.focus_entered.connect(_focus_cell.bind(index))
		button.focus_exited.connect(_unfocus_cell.bind(index))
		cell_buttons.append(button)
	_build_matrix_cursor(matrix_margin)
	var right := _vbox(columns, 12)
	right.custom_minimum_size.x = 490
	_label(right, "BUFFER", 22, MUTED)
	var blanks: Array[String] = []
	for _index in grid_state.sequence.size():
		blanks.append("")
	_input_labels = _token_strip(right, blanks)
	var required := PanelContainer.new()
	required.add_theme_stylebox_override("panel", _style(RECESS, EDGE, 1, 0))
	right.add_child(required)
	var required_stack := _vbox(required, 0)
	round_heading = _code_heading(required_stack, "")
	var required_margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		required_margin.add_theme_constant_override("margin_" + side, 16)
	required_stack.add_child(required_margin)
	var required_body := _vbox(required_margin, 0)
	_target_labels = _token_strip(required_body, grid_state.sequence, false)
	_recovery_guide = PanelContainer.new()
	_recovery_guide.add_theme_stylebox_override("panel", _style(RECESS, EDGE, 1, 12))
	right.add_child(_recovery_guide)
	var guide_box := _vbox(_recovery_guide, 8)
	_label(guide_box, "Sebelum mulai", 23, INK)
	_label(guide_box, "Mulai dari baris atas, lalu bergantian kolom dan baris. Sorot kode untuk pratinjau; klik untuk memilih. Salah kode mengulang ronde.", 22, MUTED)
	feedback = _label(_body, "", 21, MUTED)
	feedback.hide()
	var actions := _row(_body, 12)
	start_button = _button(actions, "Mulai pemulihan", _start_recovery, 300)
	hint_button = _button(actions, "Petunjuk", _hint, 220)
	_button(actions, "Kembali ke berkas", _show_desktop, 300)
	_refresh_grid()
	_say_once("restore")
	_focus_later(start_button)


func _start_recovery() -> void:
	if not _available() or screen != "puzzle" or not recovery.start():
		return
	_time_warning_played = false
	feedback.text = ""
	_refresh_grid(true)
	_say_once("focus")


func _update_clock() -> void:
	time_bar.value = recovery.remaining
	var time_low: bool = recovery.remaining <= TIMER_WARNING_THRESHOLD
	_time_fill.bg_color = WARNING if time_low else PALETTE.CYAN
	if time_low and recovery.state == "active" and not _time_warning_played:
		_time_warning_played = true
		_timer_warning.play()


func _show_timeout() -> void:
	_clear_body()
	screen = "timeout"
	_heading.text = "ARSIP KAKEK / PEMULIHAN TERHENTI"
	_label(_body, "Waktu pemulihan habis", 36, WARNING)
	_label(_body, "Arsip belum berhasil dibuka. Ulangi tiga ronde untuk mencoba lagi.", 26)
	_label(_body, "Ronde selesai: %d / %d" % [recovery.round_index, RECOVERY.ROUND_COUNT], 24, MUTED)
	var actions := _row(_body)
	retry_button = _button(actions, "Ulangi pemulihan", _retry_recovery, 320)
	_button(actions, "Kembali ke berkas", _show_desktop, 300)
	_focus_later(retry_button)


func _retry_recovery() -> void:
	if not _available() or screen != "timeout":
		return
	recovery.reset()
	_hint_index = -1
	_show_puzzle()


func _refresh_grid(focus_grid := false) -> void:
	var active: bool = recovery.state == "active"
	var allowed: Array[int] = grid_state.allowed_indices()
	for index in range(cell_buttons.size()):
		var button := cell_buttons[index]
		var used: bool = grid_state.path.has(index)
		button.disabled = not active or not allowed.has(index)
		button.text = "< >" if used else grid_state.cells[index]
		button.add_theme_stylebox_override("normal", _style(SURFACE if allowed.has(index) else Color.TRANSPARENT, Color.TRANSPARENT, 0, 0))
		if index == _hint_index:
			button.add_theme_stylebox_override("normal", _style(SURFACE, WARNING, 2, 0))
		if used:
			button.add_theme_color_override("font_disabled_color", INK)
			button.add_theme_stylebox_override("disabled", _style(SURFACE, ACCENT, 1, 0))
		else:
			button.add_theme_color_override("font_disabled_color", MUTED)
			button.add_theme_stylebox_override("disabled", _style(Color.TRANSPARENT, Color.TRANSPARENT, 0, 0))
	_set_preview(-1, true)
	start_button.visible = not active
	hint_button.visible = active
	round_heading.text = "URUTAN KODE  %d / %d" % [recovery.round_index + 1, RECOVERY.ROUND_COUNT]
	_recovery_guide.visible = not active
	feedback.visible = not feedback.text.is_empty()
	_update_clock()
	if focus_grid and active and not allowed.is_empty():
		_focus_later(cell_buttons[allowed[0]])


func _choose_cell(index: int) -> void:
	if not _available() or screen != "puzzle":
		return
	var result: String = recovery.choose(index)
	_hint_index = -1
	match result:
		"wrong", "dead_end":
			_play_recovery_sound(RECOVERY_ERROR)
			_say_once("wrong", true)
			feedback.text = "Ronde diulang."
			feedback.add_theme_color_override("font_color", WARNING)
			_refresh_grid(true)
		"accepted", "round_completed":
			_play_recovery_sound(RECOVERY_SELECT)
			feedback.text = ""
			_refresh_grid(true)
		"solved":
			recovered = true
			_play_recovery_sound(RECOVERY_SUCCESS)
			recovery_completed.emit(str(definition.safe_code))
			await get_tree().create_timer(RECOVERY_SUCCESS.get_length(), false).timeout
			if _available() and screen == "puzzle" and recovery.state == "complete":
				_show_archive(true)


func _play_recovery_sound(stream: AudioStream) -> void:
	_recovery_sound.stream = stream
	_recovery_sound.play()


func _hint() -> void:
	if not _available() or screen != "puzzle" or recovery.state != "active":
		return
	_hint_index = grid_state.recommended_index()
	feedback.text = ""
	_refresh_grid()


func _show_archive(just_recovered := false) -> void:
	if not _available():
		return
	_show_desktop()
	screen = "archive"
	_back_button.disabled = false
	var content := _open_document("Arsip Kakek / Catatan darurat", 506)
	_label(content, str(definition.get("archive_title", "Catatan darurat")), 32)
	_label(content, "Indeks arsip berhasil dipulihkan.", 22, PALETTE.CYAN)
	for paragraph: String in definition.get("archive_lines", []):
		_label(content, paragraph, 24)
	_label(content, "Kode brankas", 22, MUTED)
	_label(content, str(definition.get("safe_code", "")), 52)
	if safe_opened:
		_label(content, "Brankas sudah dibuka. Catatan Kakek tetap tersimpan di arsip ini.", 22, MUTED)
	var space := Control.new()
	space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(space)
	var actions := _row(content)
	var back := _button(actions, "Kembali ke berkas", _show_desktop, 330)
	_button(actions, "Keluar komputer", close_computer, 290)
	if just_recovered:
		_say_once("recovered")
	if not safe_opened:
		_reading_timer.start()
	if not _save_warning.is_empty():
		_footer.text = _save_warning
		_footer.show()
	_focus_later(back)


func show_save_warning(message: String) -> void:
	_save_warning = message
	_footer.text = message
	_footer.visible = not message.is_empty()
