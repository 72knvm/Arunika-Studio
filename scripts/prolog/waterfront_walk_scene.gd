extends Node2D
## Shared waterfront scenery, actor movement and camera for bridge and kedai.

const VIEW_SIZE := Vector2(1672, 941)
const START_X := 565.0
const FOOT_Y := 870.0
const END_MARGIN := 180.0
const BRIDGE_REGION := Rect2(358, 701, 384, 240)
const RAIL_REGION := Rect2(358, 701, 384, 131)
const FLOOR_REGION := Rect2(358, 832, 384, 109)
const RAIL_TOP_Y := 630.0
const RAIL_BASE_Y := 832.0
const LAMP_REGION := Rect2(251, 115, 663, 1294)
const SEA_HORIZON := 578
# Overlap the extracted shoreline instead of exposing sky beneath the city.
const SEA_SURFACE_Y := 554.0
const BACKDROP_SPEED := 0.025
const BACKDROP_SCROLL_LIMIT := 120.0
const LAMP_HEIGHT := 610.0
const LAMP_BASE_Y := 828.0
const DIALOGUE_ZOOM := 1.25
const DIALOGUE_FEET_SCREEN_Y := 600.0
const DIALOGUE_CAMERA_SECONDS := 0.45

@export var spawn_x := START_X
@export var world_origin_x := 0.0
@export var backdrop_scroll_offset := 0.0
@export var camera_lead_ratio := 0.13

@onready var saka: Node2D = $SakaPreview
@onready var tara: Node2D = $Tara
@onready var camera: Camera2D = $Camera2D
@onready var sky: Sprite2D = $Backdrop/Sky
@onready var sea: Sprite2D = $Backdrop/Sea
@onready var city: Sprite2D = $Backdrop/City
@onready var bridge: Node2D = $Bridge
@onready var lamps: Node2D = $Lamps
@onready var panel: PanelContainer = $Overlay/Panel
@onready var status: Label = $Overlay/Panel/Margin/Rows/Status
var tile_width := 0.0
var route_length := 3200.0
var layers: Array[CanvasItem] = []
var dialogue_camera_active := false
var _walk_camera_position := Vector2.ZERO


func _ready() -> void:
	saka.set_physics_process(false)
	saka.left_limit = 120.0
	saka.right_limit = route_length - END_MARGIN
	tara.left_limit = saka.left_limit
	tara.right_limit = saka.right_limit
	tara.display_height = saka.display_height * 163.0 / 184.0
	set_player_spawn(spawn_x)
	_fit_backdrop(sky, BACKDROP_SCROLL_LIMIT)
	_fit_backdrop(sea, BACKDROP_SCROLL_LIMIT)
	_clip_sea()
	_fit_backdrop(city, BACKDROP_SCROLL_LIMIT)
	var cutout := ShaderMaterial.new()
	cutout.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	city.material = cutout
	sea.material = cutout
	_build_bridge()
	_build_lamps()
	layers = [sky, sea, city, bridge, lamps]
	update_camera()
	reset_physics_interpolation()
	camera.force_update_scroll()
	if "--capture-bridge" in OS.get_cmdline_user_args():
		set_physics_process(false)
		call_deferred("_capture")


func _fit_backdrop(sprite: Sprite2D, padding: float) -> void:
	var size := sprite.texture.get_size()
	sprite.scale = Vector2((VIEW_SIZE.x + padding * 2.0) / size.x, VIEW_SIZE.y / size.y)
	sprite.position = Vector2(-padding, 0)


func _clip_sea() -> void:
	var source: Texture2D = sea.texture
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = Rect2(0, SEA_HORIZON, source.get_width(), source.get_height() - SEA_HORIZON)
	atlas.filter_clip = true
	sea.texture = atlas
	sea.position.y = SEA_SURFACE_Y
	sea.scale.y = (VIEW_SIZE.y - SEA_SURFACE_Y) / atlas.region.size.y


func _build_bridge() -> void:
	var source: Texture2D = preload("res://assets/sprites/backgrounds/prolog/bridge/cyberpunk_v01/bg_pro_02_bridge_t3.png")
	var glass := ShaderMaterial.new()
	glass.shader = preload("res://assets/shaders/bridge_glass.gdshader")
	glass.set_shader_parameter("glass_opacity", 0.42)
	# Shader UVs use the source atlas, rather than the cropped tile coordinates.
	glass.set_shader_parameter("glass_y", Vector2(729.0, 795.0) / source.get_height())
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = FLOOR_REGION
	atlas.filter_clip = true
	var rail_atlas := AtlasTexture.new()
	rail_atlas.atlas = source
	rail_atlas.region = RAIL_REGION
	rail_atlas.filter_clip = true
	var opaque := ShaderMaterial.new()
	opaque.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	var factor := VIEW_SIZE.y / source.get_height()
	tile_width = roundf(BRIDGE_REGION.size.x * factor)
	var first_index := int(floor(world_origin_x / tile_width))
	var last_index := int(ceil((world_origin_x + route_length) / tile_width))
	for index in range(first_index, last_index):
		var tile := Sprite2D.new()
		tile.name = "Segment%02d" % index
		tile.texture = atlas
		tile.material = opaque
		tile.centered = false
		# Mirror alternating segments: both adjoining edges sample the same source edge.
		var mirrored := index % 2 == 1
		tile.scale = Vector2(-tile_width / BRIDGE_REGION.size.x if mirrored else tile_width / BRIDGE_REGION.size.x, factor)
		tile.position = Vector2((index + 1 if mirrored else index) * tile_width - world_origin_x, FLOOR_REGION.position.y * factor)
		var rail := Sprite2D.new()
		rail.name = "Rail"
		rail.texture = rail_atlas
		rail.material = glass
		rail.centered = false
		rail.position.y = RAIL_TOP_Y - RAIL_BASE_Y
		rail.scale.y = (RAIL_BASE_Y - RAIL_TOP_Y) / RAIL_REGION.size.y
		tile.add_child(rail)
		bridge.add_child(tile)


func _build_lamps() -> void:
	var source: Texture2D = preload("res://assets/sprites/backgrounds/prolog/bridge/cyberpunk_v01/bg_pro_02_lamp_t4.png")
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = LAMP_REGION
	atlas.filter_clip = true
	var factor := LAMP_HEIGHT / LAMP_REGION.size.y
	var first_index := maxi(0, int(floor((world_origin_x - LAMP_REGION.size.x * factor) / 1100.0)))
	var last_index := int(ceil((world_origin_x + route_length) / 1100.0))
	for index in range(first_index, last_index):
		var lamp := Sprite2D.new()
		lamp.name = "Lamp%02d" % index
		lamp.texture = atlas
		lamp.centered = false
		var cutout := ShaderMaterial.new()
		cutout.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
		lamp.material = cutout
		lamp.scale = Vector2.ONE * factor
		lamp.position = Vector2(70 + index * 1100 - world_origin_x, LAMP_BASE_Y - LAMP_HEIGHT)
		lamps.add_child(lamp)


func _physics_process(delta: float) -> void:
	var right := Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
	var left := Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
	advance(float(right) - float(left), delta)


func advance(direction: float, delta: float) -> void:
	saka.advance(direction, delta)
	tara.follow(saka.position, delta)
	update_camera()


func set_player_spawn(x: float) -> void:
	saka.position = Vector2(x, FOOT_Y)
	tara.reset_follow(saka.position, saka.facing_left)
	saka.reset_physics_interpolation()
	if is_instance_valid(camera):
		update_camera()
		# Spawns are teleports, not movement across the length of the bridge.
		reset_physics_interpolation()
		camera.force_update_scroll()


func stop_characters() -> void:
	saka.advance(0.0, 0.0)
	tara.stop_follow()


func update_camera() -> void:
	if dialogue_camera_active:
		return
	camera.position = Vector2(clampf(saka.position.x + VIEW_SIZE.x * camera_lead_ratio, VIEW_SIZE.x * 0.5, route_length - VIEW_SIZE.x * 0.5), VIEW_SIZE.y * 0.5)
	camera.force_update_scroll()
	var traveled := camera.position.x - VIEW_SIZE.x * 0.5
	# Shared scale, offset and limit keep the shoreline and painted reflections attached.
	var backdrop_x := -BACKDROP_SCROLL_LIMIT - clampf(backdrop_scroll_offset + traveled * BACKDROP_SPEED, 0.0, BACKDROP_SCROLL_LIMIT)
	for layer: Sprite2D in [sky, sea, city]:
		layer.position.x = backdrop_x
	status.text = "Jalur uji: %d / %d px  |  Tara mengikuti Saka" % [int(saka.position.x - saka.left_limit), int(saka.right_limit - saka.left_limit)]


func focus_dialogue_camera() -> void:
	_walk_camera_position = camera.position
	dialogue_camera_active = true
	var midpoint := (saka.position + tara.position) * 0.5
	# Center both actors horizontally; keep their feet above the textbox body.
	# The nameplate sits further left, outside this centered pair.
	var target := Vector2(midpoint.x, midpoint.y - (DIALOGUE_FEET_SCREEN_Y - VIEW_SIZE.y * 0.5) / DIALOGUE_ZOOM)
	await _move_camera(target, Vector2.ONE * DIALOGUE_ZOOM)


func restore_walk_camera() -> void:
	await _move_camera(_walk_camera_position, Vector2.ONE)
	dialogue_camera_active = false
	update_camera()


func _move_camera(target: Vector2, target_zoom: Vector2) -> void:
	# Cinematic tweens run every rendered frame; walking uses physics interpolation.
	camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_IDLE
	var movement := create_tween().set_parallel(true)
	movement.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	movement.tween_property(camera, "position", target, DIALOGUE_CAMERA_SECONDS)
	movement.tween_property(camera, "zoom", target_zoom, DIALOGUE_CAMERA_SECONDS)
	await movement.finished
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	camera.reset_physics_interpolation()
	camera.force_update_scroll()


func reset_preview() -> void:
	saka.reset_preview()
	set_player_spawn(spawn_x)
	update_camera()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.keycode:
		KEY_R:
			reset_preview()
		KEY_F1:
			panel.visible = not panel.visible
		KEY_1, KEY_2, KEY_3, KEY_4, KEY_5:
			var index: int = event.keycode - KEY_1
			layers[index].visible = not layers[index].visible
		KEY_6:
			saka.visible = not saka.visible
		KEY_7:
			tara.visible = not tara.visible


func _capture() -> void:
	panel.hide()
	for target_x in [START_X, route_length * 0.5, saka.right_limit]:
		set_player_spawn(target_x)
		update_camera()
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var suffix := "start" if target_x == START_X else ("end" if target_x == saka.right_limit else "middle")
		var error := get_viewport().get_texture().get_image().save_png("res://outputs/bridge_%s_preview.png" % suffix)
		if error != OK:
			push_error("Bridge capture failed: %s" % error)
			get_tree().quit(1)
			return
	print("BRIDGE_CAPTURE_PASS")
	get_tree().quit()
