extends Node2D
## Scene pemeriksaan visual dengan preview jalan Saka.

const SKY_ORIGIN := Vector2(-195.0, -254.0)
const CITY_ORIGIN := Vector2(-239.0, -254.0)
const MAX_SHIFT := 40.0

@onready var sky: Sprite2D = $WindowClip/Sky
@onready var city: Sprite2D = $WindowClip/City
@onready var shell: Sprite2D = $RoomShell
@onready var furniture: Sprite2D = $Furniture
@onready var slider: HSlider = $Overlay/Panel/Margin/Controls/Slider
@onready var panel: PanelContainer = $Overlay/Panel

var background_shift := 0.0
var _awake_physics_enabled := false


func set_saka_sleeping(sleeping: bool) -> void:
	if $SleepingSaka.visible == sleeping:
		return
	if sleeping:
		_awake_physics_enabled = $SakaPreview.is_physics_processing()
		$SakaPreview.set_physics_process(false)
		$SakaPreview.advance(0.0, 0.0)
	else:
		$SakaPreview.set_physics_process(_awake_physics_enabled)
	$SleepingSaka.visible = sleeping
	$SakaPreview.visible = not sleeping


func _ready() -> void:
	slider.value_changed.connect(_set_background_shift)
	var arguments := OS.get_cmdline_user_args()
	if "--verify-room" in arguments:
		_verify_room()
	if "--capture-room" in arguments or "--capture-saka" in arguments or "--capture-walk" in arguments:
		_capture_room()


func _process(delta: float) -> void:
	var direction := float(Input.is_physical_key_pressed(KEY_E))
	direction -= float(Input.is_physical_key_pressed(KEY_Q))
	if not is_zero_approx(direction):
		_set_background_shift(background_shift + direction * 35.0 * delta)


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_R:
			_set_background_shift(0.0)
			$SakaPreview.reset_preview()
		KEY_1:
			sky.visible = not sky.visible
		KEY_2:
			city.visible = not city.visible
		KEY_3:
			shell.visible = not shell.visible
		KEY_4:
			furniture.visible = not furniture.visible
		KEY_5:
			$SakaPreview.visible = not $SakaPreview.visible
		KEY_F1:
			panel.visible = not panel.visible


func _set_background_shift(value: float) -> void:
	background_shift = clampf(value, -MAX_SHIFT, MAX_SHIFT)
	sky.position = SKY_ORIGIN + Vector2(roundf(background_shift * 0.1), 0.0)
	city.position = CITY_ORIGIN + Vector2(roundf(background_shift * 0.25), 0.0)
	slider.set_value_no_signal(background_shift)


func _verify_room() -> void:
	var errors: Array[String] = []
	for layer: Sprite2D in [sky, city, shell, furniture]:
		if layer.texture == null or layer.texture.get_size() != Vector2(1672, 941):
			errors.append("Texture missing or dimensions differ: " + layer.name)
	if not $WindowClip.clip_contents:
		errors.append("Window clipping disabled")
	var shell_origin := shell.position
	var furniture_origin := furniture.position
	_set_background_shift(1000.0)
	if background_shift != MAX_SHIFT or city.position != CITY_ORIGIN + Vector2(10, 0):
		errors.append("Positive shift clamp or city transform failed")
	_set_background_shift(-1000.0)
	if background_shift != -MAX_SHIFT or sky.position != SKY_ORIGIN - Vector2(4, 0):
		errors.append("Negative shift clamp or sky transform failed")
	if shell.position != shell_origin or furniture.position != furniture_origin:
		errors.append("World geometry moved with exterior")
	_set_background_shift(0.0)
	if sky.position != SKY_ORIGIN or city.position != CITY_ORIGIN:
		errors.append("Reset failed")
	if errors.is_empty():
		print("ROOM_VERIFY_PASS: textures, clipping, bounded movement, fixed room and reset")
		get_tree().quit(0)
	else:
		for error in errors:
			push_error(error)
		get_tree().quit(1)


func _capture_room() -> void:
	panel.hide()
	var walking := "--capture-walk" in OS.get_cmdline_user_args()
	if walking:
		$SakaPreview.set_physics_process(false)
		$SakaPreview/Sprite.play(&"walk")
		$SakaPreview/Sprite.pause()
		$SakaPreview/Sprite.frame = 0
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var capture_path := "res://outputs/room_saka_preview.png" if "--capture-saka" in OS.get_cmdline_user_args() else "res://outputs/room_layer_test.png"
	if walking:
		capture_path = "res://outputs/characters/saka_walk_in_room.png"
	var result := image.save_png(capture_path)
	print("ROOM_CAPTURE_RESULT: ", result)
	get_tree().quit(0 if result == OK else 1)
