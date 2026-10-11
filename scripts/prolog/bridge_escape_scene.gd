extends "res://scripts/prolog/waterfront_walk_scene.gd"
## First playable escape phase. Ruins and action poses are temporary placeholders.

signal disaster_started
signal escape_completed
signal respawned

const ACTOR_DRIVER = preload("res://scripts/prolog/escape_actor.gd")
const SAFE_SECONDS := 1.5
const ESCAPE_START_X := 4200.0
const BILLBOARD := Rect2(2980, 540, 310, 175)
const GAP := Vector2(1900, 2180)
const FINISH_X := 1150.0

var damaged := false
var flashing := false
var completed := false
var elapsed_safe := 0.0
var jump_requested := false
var checkpoint_x := 3600.0
var retry_count := 0
var saka_body: CharacterBody2D
var tara_body: CharacterBody2D
var intact_ground: StaticBody2D
var ruined_ground: Node2D
var ruin_art: Node2D
var _tara_last_safe := Vector2.ZERO
@onready var white_flash: ColorRect = $DisasterFlash/White


func _ready() -> void:
	spawn_x = ESCAPE_START_X
	route_length = 4800.0
	camera_lead_ratio = -0.13
	super._ready()
	saka.facing_left = true
	set_player_spawn(spawn_x)
	intact_ground = _platform(Rect2(0, FOOT_Y, route_length, 100))
	saka_body = ACTOR_DRIVER.new()
	add_child(saka_body)
	saka_body.setup(saka)
	tara_body = ACTOR_DRIVER.new()
	add_child(tara_body)
	tara_body.setup(tara)
	_tara_last_safe = tara.position
	_build_ruins()
	ruined_ground.hide()
	ruined_ground.process_mode = Node.PROCESS_MODE_DISABLED
	for body: StaticBody2D in ruined_ground.get_children():
		body.get_child(0).disabled = true
	ruin_art.hide()
	$Overlay/Panel/Margin/Rows/Help.text = "TES KABUR  |  A/D: gerak  |  Shift: sprint  |  Space: lompat  |  Ctrl: slide"


func _platform(rect: Rect2, parent_node: Node = self) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = rect.get_center()
	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = rect.size
	body.add_child(collision)
	parent_node.add_child(body)
	return body


func _polygon(parent_node: Node, points: PackedVector2Array, color: Color) -> void:
	var art := Polygon2D.new()
	art.polygon = points
	art.color = color
	parent_node.add_child(art)


func _build_ruins() -> void:
	ruined_ground = Node2D.new()
	ruined_ground.name = "RuinedCollision"
	add_child(ruined_ground)
	_platform(Rect2(0, FOOT_Y, GAP.x, 160), ruined_ground)
	_platform(Rect2(GAP.y, FOOT_Y, route_length - GAP.y, 160), ruined_ground)
	_platform(BILLBOARD, ruined_ground)
	ruin_art = Node2D.new()
	ruin_art.name = "RuinArt"
	add_child(ruin_art)
	# Cover the intact deck in the gap, while keeping airborne actors in front.
	move_child(ruin_art, tara.get_index())
	_polygon(ruin_art, PackedVector2Array([Vector2(GAP.x, 630), Vector2(GAP.y, 630), Vector2(GAP.y, 1100), Vector2(GAP.x, 1100)]), Color("101229"))
	for edge in [GAP.x, GAP.y]:
		var side := 1.0 if edge == GAP.x else -1.0
		_polygon(ruin_art, PackedVector2Array([Vector2(edge, 825), Vector2(edge + side * 28, 839), Vector2(edge, 857), Vector2(edge + side * 18, 886), Vector2(edge, 942), Vector2(edge - side * 18, 942), Vector2(edge - side * 18, 825)]), Color("4b425e"))
	_polygon(ruin_art, PackedVector2Array([BILLBOARD.position, Vector2(BILLBOARD.end.x, BILLBOARD.position.y + 25), BILLBOARD.end, Vector2(BILLBOARD.position.x, BILLBOARD.end.y - 25)]), Color("171629"))
	_polygon(ruin_art, PackedVector2Array([BILLBOARD.position + Vector2(16, 30), Vector2(BILLBOARD.end.x - 15, BILLBOARD.position.y + 55), BILLBOARD.end - Vector2(16, 30), Vector2(BILLBOARD.position.x + 16, BILLBOARD.end.y - 55)]), Color("633776"))
	for x in [3030.0, 3130.0, 3230.0]:
		_polygon(ruin_art, PackedVector2Array([Vector2(x, 600), Vector2(x + 22, 602), Vector2(x + 12, 640), Vector2(x - 10, 638)]), Color("ae7db6"))


func advance(direction: float, delta: float) -> void:
	if flashing or completed:
		return
	if not damaged:
		super.advance(direction, delta)
		saka_body.teleport(saka.position)
		tara_body.teleport(tara.position)
		elapsed_safe += delta
		if elapsed_safe >= SAFE_SECONDS:
			_begin_disaster()
		return
	var sprinting := Input.is_physical_key_pressed(KEY_SHIFT)
	var sliding := Input.is_physical_key_pressed(KEY_CTRL) or Input.is_physical_key_pressed(KEY_C)
	step_escape(direction, sprinting, jump_requested, sliding, delta)
	jump_requested = false


func step_escape(direction: float, sprinting: bool, jump_pressed: bool, slide_held: bool, delta: float) -> void:
	if not damaged or flashing or completed or dialogue_camera_active:
		return
	saka_body.tick(direction, sprinting, jump_pressed, slide_held, delta)
	_advance_tara(delta)
	if saka.position.y > VIEW_SIZE.y + 380:
		_respawn()
	if saka_body.is_on_floor() and saka.position.x < BILLBOARD.position.x - 100 and saka.position.x > GAP.y + 200:
		checkpoint_x = minf(checkpoint_x, 2750.0)
	if saka_body.is_on_floor() and saka.position.x < GAP.x - 150:
		checkpoint_x = minf(checkpoint_x, 1700.0)
	update_camera()
	if saka.position.x <= FINISH_X and saka_body.is_on_floor() and not completed:
		completed = true
		stop_characters()
		escape_completed.emit()


func _advance_tara(delta: float) -> void:
	var target: float = saka.position.x + tara.follow_distance
	if target > GAP.x and target < GAP.y:
		target = GAP.x - 55.0 if saka.position.x < GAP.y else GAP.y + 55.0
	var direction := signf(target - tara_body.position.x) if absf(target - tara_body.position.x) > 8.0 else 0.0
	var x := tara_body.position.x
	var approaching_gap := (direction < 0 and x >= GAP.y and x < GAP.y + 90.0) or (direction > 0 and x <= GAP.x and x > GAP.x - 90.0)
	var jump := damaged and tara_body.is_on_floor() and approaching_gap
	var under_billboard := tara_body.position.x > BILLBOARD.position.x - 65 and tara_body.position.x < BILLBOARD.end.x + 65
	tara_body.tick(direction, true, jump, under_billboard, delta)
	if tara_body.is_on_floor():
		_tara_last_safe = tara_body.position
	if tara_body.position.y > VIEW_SIZE.y + 380:
		# Companion failure never forces the player's retry.
		tara_body.teleport(_tara_last_safe)


func _begin_disaster() -> void:
	flashing = true
	stop_characters()
	var flash := create_tween()
	flash.tween_property(white_flash, "color:a", 1.0, 0.08)
	flash.tween_callback(_apply_damage)
	flash.tween_interval(0.10)
	flash.tween_property(white_flash, "color:a", 0.0, 0.35)
	await flash.finished
	flashing = false
	disaster_started.emit()


func _apply_damage() -> void:
	damaged = true
	intact_ground.get_child(0).set_deferred("disabled", true)
	ruined_ground.process_mode = Node.PROCESS_MODE_INHERIT
	for body: StaticBody2D in ruined_ground.get_children():
		body.get_child(0).set_deferred("disabled", false)
	ruin_art.show()
	var dark_sky := ShaderMaterial.new()
	dark_sky.shader = preload("res://assets/shaders/bridge_disaster_sky.gdshader")
	sky.material = dark_sky
	sea.modulate = Color(0.48, 0.32, 0.65)
	bridge.modulate = Color(0.60, 0.48, 0.70)
	lamps.modulate = Color(0.68, 0.45, 0.77)
	var shattered := ShaderMaterial.new()
	shattered.shader = preload("res://assets/shaders/bridge_disaster_city.gdshader")
	city.material = shattered
	checkpoint_x = minf(3600.0, saka.position.x)
	saka_body.teleport(saka.position)
	tara_body.teleport(tara.position)


func _respawn() -> void:
	retry_count += 1
	saka_body.teleport(Vector2(checkpoint_x, FOOT_Y - 1))
	tara_body.teleport(Vector2(checkpoint_x + tara.follow_distance, FOOT_Y - 1))
	_tara_last_safe = tara_body.position
	saka.facing_left = true
	saka.advance(0.0, 0.0)
	tara.sprite.flip_h = true
	tara.stop_follow()
	jump_requested = false
	update_camera()
	reset_physics_interpolation()
	camera.force_update_scroll()
	respawned.emit()


func reset_preview() -> void:
	if damaged:
		_respawn()
	else:
		set_player_spawn(spawn_x)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE and damaged and not flashing:
		jump_requested = true
		get_viewport().set_input_as_handled()
	else:
		super._unhandled_key_input(event)
