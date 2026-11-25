extends Node2D
## Reusable pixel portal. The caller positions it and sequences its open/close tweens.

const SHADER: Shader = preload("res://assets/shaders/portal.gdshader")
const OPEN_SOUND: AudioStream = preload("res://assets/audio/prolog/portal_open.ogg")
const PULL_SOUND: AudioStream = preload("res://assets/audio/prolog/portal_pull.ogg")
const BED_SOUND: AudioStreamOggVorbis = preload("res://assets/audio/prolog/portal_bed.ogg")
const EFFECT_MARGIN := 1.5

@export var radius := Vector2(128, 170)
@export var pixel_size := 3.0
@export var sound_enabled := false
var openness := 0.0
var intake := 0.0
var shockwave := 0.0
var elapsed := 0.0
var surface: ColorRect
var portal_material: ShaderMaterial
var _sound: AudioStreamPlayer
var _bed: AudioStreamPlayer


func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portal_material = ShaderMaterial.new()
	portal_material.shader = SHADER
	surface = ColorRect.new()
	surface.name = "PortalSurface"
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	surface.material = portal_material
	add_child(surface)
	set_radius(radius)
	_sync_material()
	if sound_enabled:
		_sound = AudioStreamPlayer.new()
		_sound.name = "PortalSound"
		add_child(_sound)
		_bed = AudioStreamPlayer.new()
		_bed.name = "PortalResonance"
		_bed.stream = BED_SOUND
		(_bed.stream as AudioStreamOggVorbis).loop = true
		add_child(_bed)


func set_radius(value: Vector2) -> void:
	radius = Vector2(maxf(4.0, value.x), maxf(4.0, value.y))
	if is_instance_valid(surface):
		surface.position = -radius * EFFECT_MARGIN
		surface.size = radius * EFFECT_MARGIN * 2.0
		_sync_material()


func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	elapsed += delta * (0.65 + intake * 1.3)
	if _bed != null and _bed.playing:
		var gain := db_to_linear(lerpf(-8.0, -1.0, intake)) * openness
		_bed.volume_linear = minf(_bed.volume_linear + delta * 2.8, gain)
	_sync_material()
	queue_redraw()


func _draw() -> void:
	if shockwave <= 0.0 or shockwave >= 1.0:
		return
	var expansion := lerpf(0.75, 4.8, 1.0 - pow(1.0 - shockwave, 2.0))
	var points := PackedVector2Array()
	for i in range(65):
		var angle := TAU * i / 64.0
		var point := Vector2(cos(angle), sin(angle)) * radius * expansion
		points.append((point / pixel_size).round() * pixel_size)
	draw_polyline(points, Color(0.72, 0.57, 0.84, pow(1.0 - shockwave, 1.5)), pixel_size * 2.0, false)


func _sync_material() -> void:
	if not is_instance_valid(portal_material):
		return
	portal_material.set_shader_parameter("portal_radius", radius)
	portal_material.set_shader_parameter("surface_size", radius * EFFECT_MARGIN * 2.0)
	portal_material.set_shader_parameter("pixel_size", maxf(1.0, pixel_size))
	portal_material.set_shader_parameter("elapsed", elapsed)
	portal_material.set_shader_parameter("openness", openness)
	portal_material.set_shader_parameter("intake", intake)


func open_portal(seconds := 0.8) -> Tween:
	show()
	surface.show()
	shockwave = 0.0
	intake = 0.0
	_sync_material()
	play_open_sound(seconds)
	var opening := create_tween()
	opening.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	opening.tween_property(self, "openness", 1.0, seconds)
	return opening


func play_open_sound(seconds: float) -> void:
	_play_sound(OPEN_SOUND, seconds, 2.0)
	if _bed != null and not _bed.playing:
		_bed.volume_linear = 0.0
		_bed.play()


func play_pull_sound(seconds: float) -> void:
	_play_sound(PULL_SOUND, seconds, 0.0)


func _play_sound(stream: AudioStream, seconds: float, gain_db: float) -> void:
	if _sound == null or seconds <= 0.0:
		return
	_sound.stream = stream
	_sound.pitch_scale = stream.get_length() / seconds
	_sound.volume_db = gain_db
	_sound.play()


func close_portal(seconds := 0.65) -> Tween:
	var closing := create_tween()
	closing.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	closing.tween_property(self, "openness", 0.0, seconds)
	if _bed != null:
		closing.tween_callback(_bed.stop)
	closing.tween_callback(hide)
	return closing


func release_wave(seconds := 0.6) -> Tween:
	# The surface has closed; only the expanding pixel contour remains visible.
	surface.hide()
	shockwave = 0.01
	show()
	var wave := create_tween()
	wave.tween_property(self, "shockwave", 1.0, seconds)
	wave.tween_callback(hide)
	return wave
