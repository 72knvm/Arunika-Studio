extends Node2D
## Foreground set only: the bridge owns the sky, city, sea, floor, and walking actors.

const KIOSK_TEXTURE: Texture2D = preload("res://assets/sprites/backgrounds/prolog/kedai/kedai_kiosks_v01.png")
const FURNITURE_TEXTURE: Texture2D = preload("res://assets/sprites/backgrounds/prolog/kedai/kedai_furniture_v01.png")
const MEAL_TEXTURE: Texture2D = preload("res://assets/sprites/backgrounds/prolog/kedai/kedai_meal_v01.png")
const MAIN_KIOSK_REGION := Rect2(47, 47, 940, 699)
const NEIGHBOR_REGION := Rect2(987, 47, 968, 699)
const EMPTY_TABLE_REGION := Rect2(1077, 280, 844, 353)
const MEAL_REGION := Rect2(488, 146, 1076, 509)
const KIOSK_SCALE := 0.80
const FURNITURE_SCALE := Vector2(0.552, 0.598)
const TABLE_GAP := 48.0
const NEIGHBOR_GAP := 320.0
const MEAL_SCALE := 0.184
const KIOSK_BASE_Y := 850.0
const FURNITURE_BASE_Y := 875.0
# Coordinates in the unscaled furniture crop, measured from its bottom edge.
const CHAIR_LEFT_X := 67.0 / 0.48
const CHAIR_RIGHT_X := 352.0 / 0.48
const SEAT_HEIGHT := 82.0 / 0.52
const TABLETOP_HEIGHT := 141.0 / 0.52
const MEAL_BASE_Y := FURNITURE_BASE_Y - TABLETOP_HEIGHT * FURNITURE_SCALE.y
const ROW_WIDTH := (940.0 + 968.0) * KIOSK_SCALE + NEIGHBOR_GAP
const RIGHT_MARGIN := 24.0

@onready var kiosks: Sprite2D = $Kiosks
@onready var neighbors: Sprite2D = $NeighborRow
@onready var first_table: Sprite2D = $FirstTable
@onready var second_table: Sprite2D = $SecondTable
@onready var seats: Node2D = $Seats
@onready var meal: Sprite2D = $Meal
var served_seat := -1


func _ready() -> void:
	_setup_cutout(kiosks, KIOSK_TEXTURE, MAIN_KIOSK_REGION, Vector2.ONE * KIOSK_SCALE, Vector2(0, KIOSK_BASE_Y))
	_setup_cutout(neighbors, KIOSK_TEXTURE, NEIGHBOR_REGION, Vector2.ONE * KIOSK_SCALE, Vector2(MAIN_KIOSK_REGION.size.x * KIOSK_SCALE + NEIGHBOR_GAP, KIOSK_BASE_Y))
	# Reuse the existing empty set: both tables start without bowls or drinks.
	_setup_cutout(first_table, FURNITURE_TEXTURE, EMPTY_TABLE_REGION, FURNITURE_SCALE, Vector2(8, FURNITURE_BASE_Y))
	var second_x := 8.0 + EMPTY_TABLE_REGION.size.x * FURNITURE_SCALE.x + TABLE_GAP
	_setup_cutout(second_table, FURNITURE_TEXTURE, EMPTY_TABLE_REGION, FURNITURE_SCALE, Vector2(second_x, FURNITURE_BASE_Y))
	_setup_cutout(meal, MEAL_TEXTURE, MEAL_REGION, Vector2.ONE * MEAL_SCALE, Vector2(0, MEAL_BASE_Y))
	clear_meal()
	# Seat pivots for later E interaction; no seated actors are baked into this set.
	var seat_y := FURNITURE_BASE_Y - SEAT_HEIGHT * FURNITURE_SCALE.y
	$Seats/Chair1.position = Vector2(first_table.position.x + CHAIR_LEFT_X * FURNITURE_SCALE.x, seat_y)
	$Seats/Chair2.position = Vector2(first_table.position.x + CHAIR_RIGHT_X * FURNITURE_SCALE.x, seat_y)
	$Seats/Chair3.position = Vector2(second_table.position.x + CHAIR_LEFT_X * FURNITURE_SCALE.x, seat_y)
	$Seats/Chair4.position = Vector2(second_table.position.x + CHAIR_RIGHT_X * FURNITURE_SCALE.x, seat_y)


func serve_at_seat(seat_index: int) -> bool:
	# Call only after the seating interaction confirms a seat. Each pair shares a table.
	if seat_index < 0 or seat_index >= seats.get_child_count():
		return false
	var table: Sprite2D = first_table if seat_index < 2 else second_table
	meal.position.x = roundf(table.position.x + EMPTY_TABLE_REGION.size.x * FURNITURE_SCALE.x * 0.5 - MEAL_REGION.size.x * MEAL_SCALE * 0.5)
	served_seat = seat_index
	meal.show()
	return true


func clear_meal() -> void:
	served_seat = -1
	meal.hide()


func _setup_cutout(sprite: Sprite2D, source: Texture2D, region: Rect2, factor: Vector2, baseline: Vector2) -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = region
	atlas.filter_clip = true
	sprite.texture = atlas
	sprite.centered = false
	sprite.scale = factor
	sprite.position = baseline - Vector2(0, region.size.y * factor.y)
	var cutout := ShaderMaterial.new()
	cutout.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	cutout.set_shader_parameter("alpha_threshold", 0.5)
	sprite.material = cutout
