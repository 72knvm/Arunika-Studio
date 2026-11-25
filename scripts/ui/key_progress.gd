extends Range
## The supplied keycap carries its own progress border and physical key feedback.

const KEYCAP: Texture2D = preload("res://assets/ui/keycap.tres")
const PROGRESS_SHADER: Shader = preload("res://assets/shaders/key_progress.gdshader")
const CAP_POSITION := Vector2(56, 20)
const CAP_SIZE := Vector2(112, 112)
const LABEL_POSITION := Vector2(0, 4)

var keycap: TextureRect
var key_label: Label
var hint: Label
var key_body: Control
var _material: ShaderMaterial
var _pressed := false
var _press := 0.0


func _ready() -> void:
	name = "MashKey"
	size = Vector2(224, 174)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	min_value = 0.0
	max_value = 100.0
	step = 0.0
	key_body = Control.new()
	key_body.position = CAP_POSITION
	key_body.size = CAP_SIZE
	key_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(key_body)
	keycap = TextureRect.new()
	keycap.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	keycap.texture = KEYCAP
	keycap.size = CAP_SIZE
	keycap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_material = ShaderMaterial.new()
	_material.shader = PROGRESS_SHADER
	var atlas := KEYCAP as AtlasTexture
	var origin := atlas.region.position / atlas.atlas.get_size()
	var region := atlas.region.size / atlas.atlas.get_size()
	_material.set_shader_parameter("atlas_rect", Vector4(origin.x, origin.y, region.x, region.y))
	keycap.material = _material
	key_body.add_child(keycap)
	key_label = Label.new()
	key_label.add_theme_font_size_override("font_size", 62)
	key_label.add_theme_color_override("font_color", Color("29211f"))
	key_label.text = "E"
	key_label.clip_text = true
	key_label.position = LABEL_POSITION
	key_label.size = Vector2(112, 90)
	key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	key_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	key_body.add_child(key_label)
	hint = Label.new()
	hint.add_theme_font_size_override("font_size", 24)
	hint.text = "Tekan berulang"
	hint.clip_text = true
	hint.position = Vector2(0, 142)
	hint.size = Vector2(224, 32)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color("fff7df"))
	hint.add_theme_color_override("font_shadow_color", Color("0b151c"))
	hint.add_theme_constant_override("shadow_offset_y", 2)
	hint.add_theme_constant_override("outline_size", 3)
	hint.add_theme_color_override("font_outline_color", Color("0b151c"))
	hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hint)
	value_changed.connect(_update_progress)
	_update_progress(value)


func _update_progress(_value: float) -> void:
	_material.set_shader_parameter("progress_ratio", get_as_ratio())


func set_pressed(pressed: bool) -> void:
	_pressed = pressed


func _process(delta: float) -> void:
	var target := 1.0 if _pressed else 0.0
	var speed := 28.0 if _pressed else 16.0
	_press = move_toward(_press, target, delta * speed)
	# Move the entire key face, including its shader border and centered glyph.
	key_body.position = CAP_POSITION + Vector2(0, roundf(_press * 7.0))
	key_body.scale.y = 1.0 - _press * .06

