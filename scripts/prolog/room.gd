extends Node2D
## Shared morning exterior and registered layers for the post-doomsday return.

const SKY_ORIGIN := Vector2(-195.0, -254.0)
const CITY_ORIGIN := Vector2(-239.0, -254.0)
const MAX_SHIFT := 40.0
const DOOMSDAY_SHELL := "res://assets/world/room/aftermath.png"
const DOOMSDAY_SKY := "res://assets/world/ruins/sky.png"
const DOOMSDAY_CITY := "res://assets/world/ruins/city.tres"
const SAFE_OPEN := "res://assets/world/room/safe.png"
const STARTLED: Texture2D = preload("res://assets/characters/saka/startled.png")
const WAKE_SHAKE_SECONDS := 0.45
const WAKE_SHAKE_PIXELS := Vector2(5.0, 3.0)

@export var after_doomsday := false

@onready var sky: Sprite2D = $WindowClip/Sky
@onready var city: Sprite2D = $WindowClip/City
@onready var shell: Sprite2D = $RoomShell
@onready var furniture: Sprite2D = $Furniture
@onready var slider: HSlider = $Overlay/Panel/Margin/Controls/Slider
@onready var panel: PanelContainer = $Overlay/Panel
@onready var sleeping_sprite: Sprite2D = $SleepingSaka/Sprite
@onready var sleep_texture: Texture2D = $SleepingSaka/Sprite.texture

var background_shift := 0.0
var _awake_physics_enabled := false
var safe_overlay: Sprite2D
var startled_texture: AtlasTexture


func set_safe_opened(opened: bool) -> void:
	if not after_doomsday:
		return
	if not is_instance_valid(safe_overlay):
		safe_overlay = Sprite2D.new()
		safe_overlay.name = "OpenSafe"
		safe_overlay.texture = load(SAFE_OPEN)
		safe_overlay.centered = false
		add_child(safe_overlay)
		move_child(safe_overlay, $SakaPreview.get_index())
	safe_overlay.visible = opened


func set_saka_sleeping(sleeping: bool) -> void:
	set_saka_startled(false)
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


func set_saka_startled(startled: bool) -> void:
	if startled and startled_texture == null:
		# Duplicate the registered atlas so the original sleeping resource stays intact.
		startled_texture = sleep_texture.duplicate() as AtlasTexture
		startled_texture.atlas = STARTLED
	sleeping_sprite.texture = startled_texture if startled else sleep_texture


func startle_saka() -> void:
	if not $SleepingSaka.visible:
		return
	set_saka_startled(true)
	var resting_position := position
	var shake := create_tween()
	shake.tween_method(func(progress: float):
		var displacement := Vector2(sin(progress * TAU * 6.0), sin(progress * TAU * 8.0)) * WAKE_SHAKE_PIXELS
		position = resting_position + displacement * (1.0 - progress)
	, 0.0, 1.0, WAKE_SHAKE_SECONDS)
	await shake.finished
	position = resting_position
	reset_physics_interpolation()
	await get_tree().create_timer(0.35, false).timeout


func _ready() -> void:
	# Both room variants include furniture and share registered exterior crops.
	$WindowClip.show()
	furniture.hide()
	if after_doomsday:
		shell.texture = load(DOOMSDAY_SHELL)
		sky.texture = load(DOOMSDAY_SKY)
		city.texture = load(DOOMSDAY_CITY)
	else:
		$Overlay/Panel/Margin/Controls/Help.text = "SAKA WALK | A/D atau ←/→: jalan | R: reset | 3: kamar | 5: Saka | F1: panel"
		$Overlay/Panel/Margin/Controls/Slider.hide()
	slider.value_changed.connect(_set_background_shift)
	var arguments := OS.get_cmdline_user_args()
	if "--verify-room" in arguments:
		_verify_room()
	if "--capture-room" in arguments or "--capture-saka" in arguments or "--capture-walk" in arguments:
		_capture_room()


func _process(delta: float) -> void:
	if not after_doomsday:
		return
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
			if after_doomsday:
				sky.visible = not sky.visible
		KEY_2:
			if after_doomsday:
				city.visible = not city.visible
		KEY_3:
			shell.visible = not shell.visible
		KEY_4:
			if after_doomsday:
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
	for layer: Sprite2D in [sky, city, shell]:
		var source: Texture2D = layer.texture
		if source is AtlasTexture:
			source = source.atlas
		if source == null or source.get_size() != Vector2(1672, 941):
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
	DirAccess.make_dir_recursive_absolute("user://previews/characters")
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
	var capture_path := "user://previews/room_saka_preview.png" if "--capture-saka" in OS.get_cmdline_user_args() else "user://previews/room_layer_test.png"
	if walking:
		capture_path = "user://previews/characters/saka_walk_in_room.png"
	var result := image.save_png(capture_path)
	print("ROOM_CAPTURE_RESULT: ", result)
	get_tree().quit(0 if result == OK else 1)
