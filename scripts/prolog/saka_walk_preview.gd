extends Node2D
## Preview jalan di lantai datar; collision dan interaksi Prolog belum dipasang.

const FRAMES: SpriteFrames = preload("res://assets/sprites/characters/saka/saka_user_walk_frames_v04.tres")
const START_POSITION := Vector2(565, 760)
const WALK_ANCHORS := [191.5, 164.5, 162.5, 174.0, 205.5, 183.5, 135.0, 178.5]
const WALK_LEFT_ANCHORS := [186.5, 122.5, 101.5, 145.0, 185.5, 129.5, 103.0, 156.5]
const IDLE_ANCHORS := [84.5, 85.0, 85.0, 84.5]
const IDLE_LEFT_ANCHORS := [111.5, 111.5, 111.5, 111.5]
const IDLE_SOURCE_HEIGHT := 543.0
const IDLE_LEFT_SOURCE_HEIGHT := 691.0
const WALK_SOURCE_HEIGHT := 634.0

@export var move_speed := 180.0
@export var display_height := 380.0
@export var left_limit := 120.0
@export var right_limit := 1490.0

@onready var sprite: AnimatedSprite2D = $Sprite
var sprite_material := ShaderMaterial.new()
var facing_left := false


func _ready() -> void:
	# Change sprite poses immediately; only the parent's walking position interpolates.
	sprite.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	sprite_material.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	sprite.material = sprite_material
	sprite.sprite_frames = FRAMES
	sprite.frame_changed.connect(_align_frame)
	sprite.animation_changed.connect(_align_frame)
	sprite.play(&"idle")
	_align_frame()


func _physics_process(delta: float) -> void:
	var right := Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
	var left := Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
	advance(float(right) - float(left), delta)


func advance(direction: float, delta: float) -> void:
	var old_x := position.x
	position.x = clampf(position.x + direction * move_speed * delta, left_limit, right_limit)
	if not is_zero_approx(direction):
		facing_left = direction < 0.0
	var moving := not is_equal_approx(old_x, position.x)
	var next_animation: StringName = (&"walk_left" if facing_left else &"walk") if moving else (&"idle_left" if facing_left else &"idle")
	var was_walking := sprite.animation == &"walk" or sprite.animation == &"walk_left"
	if moving and was_walking and sprite.animation != next_animation:
		var previous_frame := sprite.frame
		var previous_progress := sprite.frame_progress
		sprite.play(next_animation)
		sprite.set_frame_and_progress(previous_frame, previous_progress)
	else:
		sprite.play(next_animation)
	_align_frame()


func reset_preview() -> void:
	position = START_POSITION
	reset_physics_interpolation()
	facing_left = false
	sprite.play(&"idle")
	_align_frame()


func _align_frame() -> void:
	var texture := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var size := texture.get_size()
	# Every direction uses its own supplied sheet and preserves source colors.
	sprite.flip_h = false
	var source_height := WALK_SOURCE_HEIGHT
	var anchors := WALK_ANCHORS
	match sprite.animation:
		&"walk_left":
			anchors = WALK_LEFT_ANCHORS
		&"idle":
			anchors = IDLE_ANCHORS
			source_height = IDLE_SOURCE_HEIGHT
		&"idle_left":
			anchors = IDLE_LEFT_ANCHORS
			source_height = IDLE_LEFT_SOURCE_HEIGHT
	var factor := display_height / source_height
	var anchor_x: float = anchors[sprite.frame]
	sprite.scale = Vector2.ONE * factor
	sprite.offset = Vector2(0, -size.y * 0.5)
	sprite.position = Vector2((size.x * 0.5 - anchor_x) * factor, 0)
