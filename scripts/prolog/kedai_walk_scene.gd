extends "res://scripts/prolog/waterfront_walk_scene.gd"
## Dining location with selectable chair pairs and a seated conversation.

const ENTRY_X := VIEW_SIZE.x * 0.37
const KEDAI_APPROACH_GAP := 220.0
const RIGHT_WALK_MARGIN := 300.0
const SEAT_RADIUS := 72.0
const SAKA_HIP := Vector2(74, 515)
const TARA_HIP := Vector2(288, 440)
const TREMOR_SECONDS := 1.2
const TREMOR_PIXELS := 14.0

@onready var kedai: Node2D = $Kedai
@onready var seated_actors: Node2D = $SeatedActors
@onready var seated_saka: Sprite2D = $SeatedActors/Saka
@onready var seated_tara: Sprite2D = $SeatedActors/Tara

var selected_seat := -1
var _standing_saka := Vector2.ZERO


func _ready() -> void:
	spawn_x = ENTRY_X
	route_length = ENTRY_X + KEDAI_APPROACH_GAP + kedai.ROW_WIDTH + RIGHT_WALK_MARGIN
	super._ready()
	kedai.position.x = ENTRY_X + KEDAI_APPROACH_GAP
	$Overlay/Panel/Margin/Rows/Help.text = "KEDAI MAK INAH  |  A/D atau ←/→: jalan  |  R: reset  |  F1: panel"
	reset_physics_interpolation()


func get_nearby_seat() -> int:
	if selected_seat >= 0:
		return -1
	var nearest := -1
	var distance := SEAT_RADIUS
	for index in range(kedai.seats.get_child_count()):
		var seat: Marker2D = kedai.seats.get_child(index)
		var current_distance := absf(saka.global_position.x - seat.global_position.x)
		if current_distance <= distance:
			distance = current_distance
			nearest = index
	return nearest


func _build_bridge() -> void:
	super._build_bridge()
	# The seated camera exposes below the deck when the textbox disappears.
	# Extend its existing bottom edge, so the sea cannot show under the pavement.
	var edge := AtlasTexture.new()
	edge.atlas = preload("res://assets/sprites/backgrounds/prolog/bridge/cyberpunk_v01/bg_pro_02_bridge_t3.png")
	edge.region = Rect2(FLOOR_REGION.position.x, 940, FLOOR_REGION.size.x, 1)
	edge.filter_clip = true
	for tile: Sprite2D in bridge.get_children():
		var foundation := Sprite2D.new()
		foundation.name = "Foundation"
		foundation.texture = edge
		foundation.centered = false
		foundation.position.y = FLOOR_REGION.size.y
		foundation.scale.y = 400.0
		tile.add_child(foundation)


func seat_characters(seat_index: int) -> bool:
	if selected_seat >= 0 or seat_index < 0 or seat_index >= kedai.seats.get_child_count():
		return false
	stop_characters()
	_standing_saka = saka.position
	selected_seat = seat_index
	var partner := seat_index + 1 if seat_index % 2 == 0 else seat_index - 1
	_position_seated(seated_saka, seat_index, SAKA_HIP, saka.display_height * 0.56, true)
	_position_seated(seated_tara, partner, TARA_HIP, tara.display_height * 0.56, false)
	saka.hide()
	tara.hide()
	kedai.serve_at_seat(seat_index)
	seated_actors.show()
	seated_actors.reset_physics_interpolation()
	return true


func _position_seated(actor: Sprite2D, seat_index: int, hip: Vector2, torso_height: float, faces_right: bool) -> void:
	var seat: Marker2D = kedai.seats.get_child(seat_index)
	var factor := torso_height / hip.y
	var facing_right := seat_index % 2 == 0
	actor.scale = Vector2(factor if facing_right == faces_right else -factor, factor)
	actor.global_position = seat.global_position - hip * actor.scale
	if actor == seated_saka:
		actor.material.set_shader_parameter("normal_eye", not facing_right)


func focus_seated_camera() -> void:
	_walk_camera_position = camera.position
	dialogue_camera_active = true
	var table: Sprite2D = kedai.first_table if selected_seat < 2 else kedai.second_table
	var midpoint := table.global_position + Vector2(table.texture.get_width() * table.scale.x * 0.5, 0)
	# Frame both seated silhouettes above the textbox, with space for the nameplate.
	var zoom := 1.35
	var target := Vector2(midpoint.x, kedai.FURNITURE_BASE_Y - (600.0 - VIEW_SIZE.y * 0.5) / zoom)
	await _move_camera(target, Vector2.ONE * zoom)


func shake_screen() -> void:
	var backdrop: CanvasLayer = $Backdrop
	var camera_offset := camera.offset
	var backdrop_offset := backdrop.offset
	var interpolation := camera.physics_interpolation_mode
	var callback := camera.process_callback
	camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_IDLE
	var shake := create_tween()
	shake.tween_method(func(progress: float):
		var phase := progress * TREMOR_SECONDS
		var displacement := Vector2(sin(phase * 69.0), sin(phase * 91.0 + 0.8)) * TREMOR_PIXELS * pow(1.0 - progress, 1.5)
		# Match the fixed sky/sea/city to the camera's movement in screen pixels.
		camera.offset = camera_offset - displacement / camera.zoom
		backdrop.offset = backdrop_offset + displacement
		camera.force_update_scroll()
	, 0.0, 1.0, TREMOR_SECONDS)
	await shake.finished
	camera.offset = camera_offset
	backdrop.offset = backdrop_offset
	camera.process_callback = callback
	camera.physics_interpolation_mode = interpolation
	camera.reset_physics_interpolation()
	camera.force_update_scroll()


func stand_characters(face_exit := false) -> void:
	seated_actors.hide()
	selected_seat = -1
	saka.position = _standing_saka
	if face_exit:
		saka.facing_left = true
	saka.show()
	tara.show()
	saka.advance(0.0, 0.0)
	tara.reset_follow(saka.position, saka.facing_left)
	reset_physics_interpolation()
