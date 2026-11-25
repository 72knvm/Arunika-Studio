extends CanvasLayer
## Test-build touch controls. Story and desktop keyboard input stay in the flow.

const KEYCAP: Texture2D = preload("res://assets/ui/keycap.tres")
const FONT: Font = preload("res://assets/themes/pixelify.tres").default_font
const CAP_SIZE := Vector2(144, 144)
var enabled := false
var surface: Control
var regions: Dictionary = {}
var fingers: Dictionary = {}
var guards: Dictionary = {}
var flow: Node
var _mashing := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 120
	enabled = OS.has_feature("android") or "--touch-preview" in OS.get_cmdline_user_args()
	if not enabled:
		set_process(false)
		set_process_input(false)
		return
	get_tree().set_auto_accept_quit(false)
	surface = Control.new()
	surface.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	surface.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	surface.draw.connect(_draw_controls)
	add_child(surface)
	for code in [KEY_LEFT, KEY_RIGHT, KEY_E, KEY_ESCAPE]:
		var guard := Control.new()
		guard.mouse_filter = Control.MOUSE_FILTER_STOP
		surface.add_child(guard)
		guards[code] = guard


func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	flow = scene if is_instance_valid(scene) and scene.has_method("cancel_active_interface") else null
	var next_regions: Dictionary = {}
	_mashing = false
	if is_instance_valid(flow):
		var view := get_viewport().get_visible_rect().size
		if not flow.is_transitioning and not get_tree().paused:
			next_regions[KEY_ESCAPE] = Rect2(view.x - 154, 24, 112, 112)
			if not flow.dialogue_active and not flow._computer_open() and not flow._safe_open() and not flow.choice.visible:
				var ending_active: bool = is_instance_valid(flow.ending) and flow.ending.is_running()
				if ending_active:
					if flow.ending.phase in [flow.ending.Phase.READY, flow.ending.Phase.COMPLETE]:
						next_regions[KEY_E] = Rect2(Vector2(view.x - 206, view.y - 194), CAP_SIZE)
				elif flow.current_location == flow.Location.MEGABUILDING and flow.active_scene.phase == flow.active_scene.Phase.MASHING:
					_mashing = true
					next_regions[KEY_E] = Rect2(view.x * .5 - 112, 20, 224, 174)
					flow.active_scene.pov.progress.hint.text = "Ketuk cepat!"
				else:
					next_regions[KEY_LEFT] = Rect2(Vector2(48, view.y - 194), CAP_SIZE)
					next_regions[KEY_RIGHT] = Rect2(Vector2(216, view.y - 194), CAP_SIZE)
					if flow.interaction_prompt.visible:
						next_regions[KEY_E] = Rect2(Vector2(view.x - 206, view.y - 194), CAP_SIZE)
		# World keyboard hints do not describe the phone controls.
		flow.prompt.visible = false
		if flow._computer_open() or flow._safe_open():
			next_regions.clear()
	for finger in fingers.keys():
		if not next_regions.has(fingers[finger]):
			_release_finger(finger)
	regions = next_regions
	for code in guards:
		var guard: Control = guards[code]
		guard.visible = regions.has(code)
		if guard.visible:
			guard.position = regions[code].position
			guard.size = regions[code].size
	surface.queue_redraw()


func _draw_controls() -> void:
	for code in regions:
		if _mashing and code == KEY_E:
			continue # The existing pressure key is also the touch target.
		var rect: Rect2 = regions[code]
		var down: bool = code in fingers.values()
		if down:
			rect.position.y += 7
			rect.size.y -= 7
		surface.draw_texture_rect(KEYCAP, rect, false, Color(1, 1, 1, .9))
		var center := rect.get_center() + Vector2(0, -6)
		var ink := Color("29211f")
		if code in [KEY_LEFT, KEY_RIGHT]:
			var direction := -1.0 if code == KEY_LEFT else 1.0
			surface.draw_colored_polygon(PackedVector2Array([
				center + Vector2(direction * 23, 0), center + Vector2(-direction * 16, -23), center + Vector2(-direction * 16, 23)
			]), ink)
		elif code == KEY_ESCAPE:
			for x in [-15, 6]:
				surface.draw_rect(Rect2(center + Vector2(x, -19), Vector2(9, 38)), ink)
		else:
			var width := FONT.get_string_size("E", HORIZONTAL_ALIGNMENT_LEFT, -1, 64).x
			surface.draw_string(FONT, center + Vector2(-width * .5, 22), "E", HORIZONTAL_ALIGNMENT_LEFT, -1, 64, ink)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			if fingers.has(event.index):
				_release_finger(event.index)
				get_viewport().set_input_as_handled()
			return
		for code in regions:
			if regions[code].has_point(event.position):
				get_viewport().set_input_as_handled()
				fingers[event.index] = code
				if fingers.values().count(code) == 1:
					_send_key(code, true)
				return
	elif event is InputEventScreenDrag and fingers.has(event.index):
		get_viewport().set_input_as_handled()
		var code: int = fingers[event.index]
		if not regions.has(code) or not regions[code].grow(24).has_point(event.position):
			_release_finger(event.index)


func _send_key(code: int, down: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = down
	Input.parse_input_event(event)


func _release_finger(index: int) -> void:
	var code: int = fingers[index]
	fingers.erase(index)
	if code not in fingers.values():
		_send_key(code, false)


func release_all() -> void:
	for index in fingers.keys():
		_release_finger(index)


func _notification(what: int) -> void:
	if not enabled:
		return
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED]:
		release_all()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		release_all()
		var scene := get_tree().current_scene
		if is_instance_valid(scene) and scene.has_method("_confirm_exit") and not is_instance_valid(scene.modal):
			scene._confirm_exit()
		else:
			_send_key(KEY_ESCAPE, true)
			_send_key(KEY_ESCAPE, false)
