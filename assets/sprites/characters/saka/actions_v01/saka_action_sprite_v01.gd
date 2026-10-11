extends Node2D
## Asset display only. Origin is the foot/pelvis anchor; no gameplay or collisions.

const FRAMES: SpriteFrames = preload("res://assets/sprites/characters/saka/actions_v01/saka_action_frames_v01.tres")
const ANCHOR := Vector2(550, 500)

@export var action: StringName = &"sprint"
@export var autoplay := true
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	sprite.sprite_frames = FRAMES
	show_action(action, autoplay)

func show_action(next_action: StringName, playing := true) -> void:
	assert(FRAMES.has_animation(next_action), "Unknown Saka action: %s" % next_action)
	action = next_action
	var factor := 0.81
	if String(action).begins_with("jump"):
		factor = 0.78
	elif String(action).begins_with("slide"):
		factor = 0.60
	sprite.scale = Vector2.ONE * factor
	sprite.position = -ANCHOR * factor
	sprite.animation = action
	sprite.frame = 0
	if playing:
		sprite.play()
	else:
		sprite.pause()
