extends Node2D
## Companion for the flat bridge route; input belongs to Saka.

const FRAMES: SpriteFrames = preload("res://assets/sprites/characters/tara/tara_user_frames_v01.tres")
const WALK_ANCHORS := [160.0, 159.0, 172.0, 156.0, 160.0, 159.0, 172.0, 156.0]
const IDLE_ANCHORS := [139.0, 146.0, 152.0, 146.0]
const WALK_SOURCE_HEIGHT := 566.0
const IDLE_SOURCE_HEIGHT := 565.0
const STOP_DISTANCE := 1.0

@export var display_height := 337.0
@export var follow_distance := 220.0
@export var max_speed := 240.0
@export var follow_response := 5.0
@export var left_limit := 120.0
@export var right_limit := 8180.0

@onready var sprite: AnimatedSprite2D = $Sprite
var previous_leader_x := 0.0
var travel_direction := 1.0


func _ready() -> void:
	sprite.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	var source_material := ShaderMaterial.new()
	source_material.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	sprite.material = source_material
	sprite.sprite_frames = FRAMES
	sprite.frame_changed.connect(_align_frame)
	sprite.animation_changed.connect(_align_frame)
	sprite.play(&"idle")
	_align_frame()


func reset_follow(leader_position: Vector2, leader_facing_left := false) -> void:
	travel_direction = -1.0 if leader_facing_left else 1.0
	previous_leader_x = leader_position.x
	position = Vector2(clampf(leader_position.x - travel_direction * follow_distance, left_limit, right_limit), leader_position.y)
	sprite.flip_h = leader_facing_left
	stop_follow()
	reset_physics_interpolation()


func follow(leader_position: Vector2, delta: float) -> void:
	var leader_movement := leader_position.x - previous_leader_x
	if absf(leader_movement) > 0.01:
		travel_direction = signf(leader_movement)
	previous_leader_x = leader_position.x
	var target_x := clampf(leader_position.x - travel_direction * follow_distance, left_limit, right_limit)
	var distance := absf(target_x - position.x)
	var old_x := position.x
	if distance > STOP_DISTANCE:
		var step := minf(max_speed * delta, distance * (1.0 - exp(-follow_response * delta)))
		position.x = move_toward(position.x, target_x, step)
	position.y = leader_position.y
	var movement := position.x - old_x
	if absf(movement) > 0.01:
		sprite.flip_h = movement < 0.0
		sprite.play(&"walk")
	else:
		sprite.play(&"idle")
	_align_frame()


func stop_follow() -> void:
	sprite.play(&"idle")
	_align_frame()


func _align_frame() -> void:
	var texture := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var size := texture.get_size()
	var walking := sprite.animation == &"walk"
	var factor := display_height / (WALK_SOURCE_HEIGHT if walking else IDLE_SOURCE_HEIGHT)
	var anchor_x: float = WALK_ANCHORS[sprite.frame] if walking else IDLE_ANCHORS[sprite.frame]
	var facing := -1.0 if sprite.flip_h else 1.0
	sprite.scale = Vector2.ONE * factor
	sprite.offset = Vector2(0, -size.y * 0.5)
	sprite.position = Vector2((size.x * 0.5 - anchor_x) * factor * facing, 0)
