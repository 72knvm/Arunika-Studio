extends Node2D
## Shared waterfront scenery, actor movement and camera for bridge and kedai.

const VIEW_SIZE := Vector2(1672, 941)
const START_X := 565.0
const FOOT_Y := 870.0
const END_MARGIN := 180.0
const BRIDGE_REGION := Rect2(358, 701, 384, 240)
const RAIL_REGION := Rect2(358, 696, 384, 136)
const FLOOR_REGION := Rect2(358, 832, 384, 109)
const RAIL_TOP_Y := 630.0
const RAIL_BASE_Y := 832.0
const LAMP_REGION := Rect2(251, 115, 663, 1294)
const SEA_HORIZON := 578
# Overlap the extracted shoreline instead of exposing sky beneath the city.
const SEA_SURFACE_Y := 554.0
const CITY_HEIGHT := 612.0
const BACKDROP_SPEED := 0.025
const BACKDROP_SCROLL_LIMIT := 120.0
const LAMP_HEIGHT := 610.0
const LAMP_BASE_Y := 828.0
const LAMP_SPACING := 1100.0
const DIALOGUE_ZOOM := 1.25
const DIALOGUE_FEET_SCREEN_Y := 600.0
const DIALOGUE_CAMERA_SECONDS := 0.45
const SCENERY_PADDING := VIEW_SIZE.x
const FLOOR_EXTENSION_HEIGHT := 700.0

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
	city.scale.y = CITY_HEIGHT / city.texture.get_height()
	var cutout := ShaderMaterial.new()
	cutout.shader = preload("res://assets/shaders/cutout.gdshader")
	city.material = cutout
	sea.material = preload("res://assets/world/morning/sea_material.tres")
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
	var source: Texture2D = preload("res://assets/world/bridge/bridge.png")
	var glass := ShaderMaterial.new()
	glass.shader = preload("res://assets/shaders/bridge_glass.gdshader")
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = FLOOR_REGION
	atlas.filter_clip = true
	var rail_atlas := AtlasTexture.new()
	rail_atlas.atlas = source
	rail_atlas.region = RAIL_REGION
	rail_atlas.filter_clip = true
	var opaque := ShaderMaterial.new()
	opaque.shader = preload("res://assets/shaders/cutout.gdshader")
	var bottom_edge := AtlasTexture.new()
	bottom_edge.atlas = source
	bottom_edge.region = Rect2(FLOOR_REGION.position.x, source.get_height() - 1, FLOOR_REGION.size.x, 1)
	bottom_edge.filter_clip = true
	var factor := VIEW_SIZE.y / source.get_height()
	tile_width = roundf(BRIDGE_REGION.size.x * factor)
	# Dialogue framing can reveal scenery beyond the normal walking viewport.
	var first_index := int(floor((world_origin_x - SCENERY_PADDING) / tile_width))
	var last_index := int(ceil((world_origin_x + route_length + SCENERY_PADDING) / tile_width))
	for index in range(first_index, last_index):
		var tile := Sprite2D.new()
		tile.name = "Segment%02d" % index
		tile.texture = atlas
		tile.material = opaque
		tile.centered = false
		# Repeat post-center to post-center without reversing paving joints or glass reflections.
		tile.scale = Vector2(tile_width / BRIDGE_REGION.size.x, factor)
		tile.position = Vector2(index * tile_width - world_origin_x, FLOOR_REGION.position.y * factor)
		var rail := Sprite2D.new()
		rail.name = "Rail"
		rail.texture = rail_atlas
		rail.material = glass
		rail.centered = false
		rail.position.y = RAIL_TOP_Y - RAIL_BASE_Y
		rail.scale.y = (RAIL_BASE_Y - RAIL_TOP_Y) / RAIL_REGION.size.y
		tile.add_child(rail)
		# Extend only the existing fascia edge; keep the walkable paving unchanged.
		var foundation := Sprite2D.new()
		foundation.name = "Foundation"
		foundation.texture = bottom_edge
		foundation.centered = false
		foundation.position.y = FLOOR_REGION.size.y
		foundation.scale.y = FLOOR_EXTENSION_HEIGHT / factor
		tile.add_child(foundation)
		bridge.add_child(tile)


func _build_lamps() -> void:
	var source: Texture2D = preload("res://assets/world/bridge/lamp.png")
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = LAMP_REGION
	atlas.filter_clip = true
	var factor := LAMP_HEIGHT / LAMP_REGION.size.y
	var first_index := int(floor((world_origin_x - SCENERY_PADDING - LAMP_REGION.size.x * factor) / LAMP_SPACING))
	var last_index := int(ceil((world_origin_x + route_length + SCENERY_PADDING) / LAMP_SPACING))
	for index in range(first_index, last_index):
		var lamp := Sprite2D.new()
		lamp.name = "Lamp%02d" % index
		lamp.texture = atlas
		lamp.centered = false
		var cutout := ShaderMaterial.new()
		cutout.shader = preload("res://assets/shaders/cutout.gdshader")
		lamp.material = cutout
		lamp.scale = Vector2.ONE * factor
		lamp.position = Vector2(70 + index * LAMP_SPACING - world_origin_x, LAMP_BASE_Y - LAMP_HEIGHT)
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
	DirAccess.make_dir_recursive_absolute("user://previews")
	panel.hide()
	for target_x in [START_X, route_length * 0.5, saka.right_limit]:
		set_player_spawn(target_x)
		update_camera()
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var suffix := "start" if target_x == START_X else ("end" if target_x == saka.right_limit else "middle")
		var error := get_viewport().get_texture().get_image().save_png("user://previews/bridge_%s_preview.png" % suffix)
		if error != OK:
			push_error("Bridge capture failed: %s" % error)
			get_tree().quit(1)
			return
	print("BRIDGE_CAPTURE_PASS")
	get_tree().quit()
