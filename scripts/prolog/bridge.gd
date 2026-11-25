extends "res://scripts/prolog/waterfront.gd"
## Walking dialogue ends before the separate kedai location begins.

signal destination_reached

const KEDAI_APPROACH_GAP := 220.0
const SKY_SUN_X := 1136.0
const CAR_TEXTURES: Array[Texture2D] = [
	preload("res://assets/world/bridge/car-coupe.svg"),
	preload("res://assets/world/bridge/car-hatchback.svg"),
	preload("res://assets/world/bridge/car-pickup.svg"),
]
const CAR_PASS := preload("res://assets/audio/prolog/car_pass.ogg")
const CAR_PASS_REVERSED := preload("res://assets/audio/prolog/car_pass_reverse.ogg")
const CAR_CENTER_Y := 827.5
const CAR_PASS_SECONDS := 1.55
const FIRST_TRAFFIC_DELAY := Vector2(2.5, 7.5)
const TRAFFIC_DELAY := Vector2(7.0, 15.0)

@onready var walk_dialogue: Node = $WalkDialogue
@onready var kedai: Node2D = $Kedai
@onready var morning_rays: ColorRect = $MorningRays
@onready var sunlight: ShaderMaterial = morning_rays.material
@onready var foreground_car: Sprite2D = $Foreground/Car
@onready var traffic_timer: Timer = $TrafficTimer
@onready var car_sound: AudioStreamPlayer = $CarSound
var departure_x := 0.0
var _departure_sent := false


func _ready() -> void:
	walk_dialogue.configure_timeline(saka.move_speed)
	departure_x = ceilf(spawn_x + saka.move_speed * walk_dialogue.walk_duration)
	# Scenery continues beyond the exit, while the walkable route stops before the booth.
	route_length = departure_x + VIEW_SIZE.x * 0.63
	super._ready()
	saka.right_limit = departure_x
	tara.right_limit = departure_x
	kedai.position.x = departure_x + KEDAI_APPROACH_GAP
	morning_rays.position = -VIEW_SIZE
	morning_rays.size = Vector2(route_length, VIEW_SIZE.y) + VIEW_SIZE * 2.0
	var first_lamp: Sprite2D = lamps.get_child(0)
	sunlight.set_shader_parameter("lamp_origin", first_lamp.position)
	sunlight.set_shader_parameter("lamp_scale", first_lamp.scale.x)
	sunlight.set_shader_parameter("lamp_spacing", LAMP_SPACING)
	update_camera()
	reset_physics_interpolation()
	traffic_timer.timeout.connect(_pass_foreground_car)
	traffic_timer.start(randf_range(FIRST_TRAFFIC_DELAY.x, FIRST_TRAFFIC_DELAY.y))


func advance(direction: float, delta: float) -> void:
	super.advance(direction, delta)
	if direction > 0.0 and saka.position.x >= departure_x and walk_dialogue.is_complete() and not _departure_sent:
		_departure_sent = true
		destination_reached.emit()


func update_camera() -> void:
	super.update_camera()
	sunlight.set_shader_parameter("sun_x", sky.position.x + SKY_SUN_X * sky.scale.x)


func _pass_foreground_car() -> void:
	if dialogue_camera_active:
		_schedule_next_car()
		return
	var from_right := randf() < 0.5
	foreground_car.texture = CAR_TEXTURES.pick_random()
	foreground_car.flip_h = from_right
	var half_width := foreground_car.texture.get_width() * foreground_car.scale.x * 0.5
	var left_edge := -half_width
	var right_edge := VIEW_SIZE.x + half_width
	foreground_car.position = Vector2(right_edge if from_right else left_edge, CAR_CENTER_Y)
	foreground_car.show()
	car_sound.stream = CAR_PASS_REVERSED if from_right else CAR_PASS
	car_sound.play()
	var crossing := create_tween()
	crossing.tween_property(foreground_car, "position:x", left_edge if from_right else right_edge, CAR_PASS_SECONDS)
	crossing.tween_callback(foreground_car.hide)
	crossing.tween_callback(_schedule_next_car)


func _schedule_next_car() -> void:
	traffic_timer.start(randf_range(TRAFFIC_DELAY.x, TRAFFIC_DELAY.y))


func set_player_spawn(x: float) -> void:
	super.set_player_spawn(x)
	walk_dialogue.reset(x)
	_departure_sent = false
