extends "res://scripts/ui/menu_modal.gd"
## A restrained translucent story overlay. The owning interface handles input.

const HOLO_INK := Color("d6edf0")
const HOLO_EDGE := Color("75bbc8")
var _fitted := false


func _init(title_text: String = "", panel_size := Vector2(900, 660)) -> void:
	super._init(title_text, panel_size)
	process_mode = Node.PROCESS_MODE_INHERIT
	var veil := get_child(0) as ColorRect
	veil.color = Color(0.02, 0.055, 0.075, .08)
	panel.position = Vector2(100, (941.0 - panel_size.y) * .5)
	var surface := StyleBoxFlat.new()
	surface.bg_color = Color(0.025, 0.095, 0.13, .74)
	surface.border_color = Color(0.36, 0.64, 0.7, .8)
	surface.set_border_width_all(1)
	surface.content_margin_left = 28
	surface.content_margin_right = 28
	surface.content_margin_top = 24
	surface.content_margin_bottom = 24
	panel.add_theme_stylebox_override("panel", surface)
	content.add_theme_constant_override("separation", 14)
	heading.add_theme_font_size_override("font_size", 34)
	heading.add_theme_color_override("font_color", HOLO_INK)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _ready() -> void:
	panel.item_rect_changed.connect(queue_redraw)
	panel.custom_minimum_size.x = panel.size.x
	panel.modulate.a = 0.0
	await get_tree().process_frame
	panel.reset_size()
	panel.position.y = (941.0 - panel.size.y) * .5
	_fitted = true
	queue_redraw()
	var reveal := create_tween()
	reveal.tween_property(panel, "modulate:a", 1.0, .16)


func _draw() -> void:
	if not _fitted or not is_instance_valid(panel):
		return
	var frame := panel.get_rect().grow(6)
	for corner in [frame.position, Vector2(frame.end.x, frame.position.y), frame.end, Vector2(frame.position.x, frame.end.y)]:
		var direction := Vector2(1 if corner.x == frame.position.x else -1, 1 if corner.y == frame.position.y else -1)
		draw_line(corner, corner + Vector2(direction.x * 24, 0), HOLO_EDGE, 2)
		draw_line(corner, corner + Vector2(0, direction.y * 24), HOLO_EDGE, 2)


func _input(_event: InputEvent) -> void:
	# Safe owns Escape and protects its opening/equipment transitions.
	pass

