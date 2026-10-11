extends CharacterBody2D
## Physics driver for the approved character art until action sprites are supplied.

const GRAVITY := 1700.0
const JUMP_SPEED := 840.0
const RUN_SPEED := 380.0
const SLIDE_HEIGHT := 132.0
const COYOTE_SECONDS := 0.10
const JUMP_BUFFER_SECONDS := 0.12

var visual: Node2D
var shape: CollisionShape2D
var standing_height := 380.0
var sliding := false
var _coyote := 0.0
var _jump_buffer := 0.0


func setup(character: Node2D) -> void:
	visual = character
	standing_height = visual.display_height
	position = visual.position
	collision_layer = 2
	collision_mask = 1
	shape = CollisionShape2D.new()
	shape.shape = CapsuleShape2D.new()
	shape.shape.radius = 24.0
	add_child(shape)
	_set_height(standing_height)


func _set_height(height: float) -> void:
	shape.shape.height = height
	shape.position.y = -height * 0.5


func _has_headroom() -> bool:
	var query := PhysicsShapeQueryParameters2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 24.0
	capsule.height = standing_height - 4.0
	query.shape = capsule
	query.transform = Transform2D(0.0, global_position - Vector2(0, standing_height * 0.5))
	query.collision_mask = 1
	query.exclude = [get_rid()]
	return get_world_2d().direct_space_state.intersect_shape(query, 1).is_empty()


func tick(direction: float, sprinting: bool, jump_pressed: bool, slide_held: bool, delta: float) -> void:
	_coyote = COYOTE_SECONDS if is_on_floor() else maxf(0.0, _coyote - delta)
	_jump_buffer = JUMP_BUFFER_SECONDS if jump_pressed else maxf(0.0, _jump_buffer - delta)
	var next_slide := slide_held and is_on_floor()
	if sliding and not next_slide and not _has_headroom():
		next_slide = true
	sliding = next_slide
	_set_height(SLIDE_HEIGHT if sliding else standing_height)
	if _jump_buffer > 0.0 and _coyote > 0.0 and not sliding:
		velocity.y = -JUMP_SPEED
		_jump_buffer = 0.0
		_coyote = 0.0
	velocity.y += GRAVITY * delta
	var speed: float = RUN_SPEED if sprinting else visual.move_speed if "move_speed" in visual else 180.0
	velocity.x = direction * speed
	move_and_slide()
	position.x = clampf(position.x, visual.left_limit, visual.right_limit)
	if visual.has_method("advance"):
		visual.advance(direction if absf(velocity.x) > 0.01 else 0.0, delta)
	else:
		visual.sprite.flip_h = direction < 0.0 if not is_zero_approx(direction) else visual.sprite.flip_h
		visual.sprite.play(&"walk" if absf(velocity.x) > 0.01 else &"idle")
		visual._align_frame()
	visual.position = position
	visual.sprite.speed_scale = 2.1 if sprinting else 1.0
	if not is_on_floor():
		visual.sprite.pause()
	if sliding:
		# Explicit prototype pose; collision changes independently of the art.
		visual.sprite.scale.y *= SLIDE_HEIGHT / standing_height
	visual.sprite.position.y = 0.0


func teleport(target: Vector2) -> void:
	position = target
	velocity = Vector2.ZERO
	_coyote = 0.0
	_jump_buffer = 0.0
	sliding = false
	_set_height(standing_height)
	visual.position = target
	reset_physics_interpolation()
	visual.reset_physics_interpolation()
