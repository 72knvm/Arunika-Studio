extends CanvasLayer
## Runtime shots from replaceable pixel masters; no gameplay or input ownership.

signal shot_changed(shot: String)

const REACH_PATH := "res://assets/cutscenes/reach.png"
const CRY_PATH := "res://assets/cutscenes/grief.png"
const HEADACHE_PATH := "res://assets/cutscenes/tara_closeup.png"
const SHADER: Shader = preload("res://assets/shaders/cinematic.gdshader")
const NATIVE_SIZE := Vector2(320, 180)
const BACKDROP := Color("483d57")
const SHOTS := {
	"wide": Rect2(0, 0, 320, 180),
	"cry": Rect2(0, 0, 320, 180),
	"headache": Rect2(0, 0, 320, 180),
}

var canvas: Control
var background: ColorRect
var picture: TextureRect
var caption: Label
var flash: ColorRect
var material := ShaderMaterial.new()
var shot := ""
var textures: Dictionary = {}


func _ready() -> void:
	layer = 10 # Dialogue stays above the picture on the flow's interface layer 20.
	canvas = Control.new()
	canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(canvas)
	background = ColorRect.new()
	background.color = BACKDROP
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(background)
	picture = TextureRect.new()
	picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	material.shader = SHADER
	picture.material = material
	canvas.add_child(picture)
	flash = ColorRect.new()
	flash.color = Color(0.96, 0.93, 1.0, 0)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(flash)
	caption = Label.new()
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.add_theme_font_size_override("font_size", 34)
	caption.add_theme_color_override("font_color", Color("fff1dc"))
	caption.add_theme_color_override("font_shadow_color", Color.BLACK)
	caption.add_theme_constant_override("shadow_offset_x", 3)
	caption.add_theme_constant_override("shadow_offset_y", 3)
	canvas.add_child(caption)
	get_viewport().size_changed.connect(_layout)
	_layout()
	hide()


func _layout() -> void:
	if not is_instance_valid(picture):
		return
	var view := get_viewport().get_visible_rect().size
	background.size = view
	flash.size = view
	caption.position = Vector2(80, view.y - 135)
	caption.size = Vector2(view.x - 160, 100)
	# Every image fills the viewport; the normal textbox overlays the close-up.
	picture.position = Vector2.ZERO
	picture.size = view


func show_shot(name_text: String, text := "") -> void:
	assert(SHOTS.has(name_text), "Unknown doomsday shot")
	shot = name_text
	var path := REACH_PATH
	match shot:
		"cry": path = CRY_PATH
		"headache": path = HEADACHE_PATH
	if not textures.has(path):
		textures[path] = load(path)
	picture.texture = textures[path]
	# Match the master at its empty corner so revisions keep a seamless matte.
	background.color = picture.texture.get_image().get_pixel(0, 0)
	var crop: Rect2 = SHOTS[shot]
	material.set_shader_parameter("source_rect", Vector4(crop.position.x / NATIVE_SIZE.x, crop.position.y / NATIVE_SIZE.y, crop.size.x / NATIVE_SIZE.x, crop.size.y / NATIVE_SIZE.y))
	background.show()
	picture.show()
	caption.text = text
	flash.color.a = 0.0
	show()
	_layout()
	shot_changed.emit(shot)


func close() -> void:
	caption.text = ""
	flash.color.a = 0.0
	hide()
