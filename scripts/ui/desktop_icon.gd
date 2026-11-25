extends Control
## Pixel-grid application artwork, sharing the terminal's eight-color palette.

const PALETTE = preload("res://scripts/ui/computer_palette.gd")
const FOLDER: Texture2D = preload("res://assets/ui/computer/folder.png")
var kind := "computer"
var show_frame := true
var failed := false:
	set(value):
		failed = value
		queue_redraw()
var _hovered := false
var _focused := false


func _ready() -> void:
	custom_minimum_size = Vector2(112, 90)
	size = Vector2(112, 90)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func set_hovered(value: bool) -> void:
	_hovered = value
	queue_redraw()


func set_focused(value: bool) -> void:
	_focused = value
	queue_redraw()


func _draw() -> void:
	if show_frame:
		var edge := PALETTE.CYAN if _hovered or _focused else PALETTE.EDGE
		draw_rect(Rect2(8, 0, 96, 82), edge)
		draw_rect(Rect2(10, 2, 92, 78), PALETTE.PANEL)
	draw_set_transform(Vector2(12, 2))
	_draw_symbol()
	draw_set_transform(Vector2.ZERO)
	if failed:
		draw_rect(Rect2(10, 2, 92, 78), Color(PALETTE.SHADOW, .4))
		draw_rect(Rect2(84, 0, 20, 20), PALETTE.WARM)
		draw_rect(Rect2(92, 4, 4, 8), PALETTE.NIGHT)
		draw_rect(Rect2(92, 15, 4, 3), PALETTE.NIGHT)


func _draw_symbol() -> void:
	match kind:
		"computer":
			draw_rect(Rect2(8, 5, 72, 48), PALETTE.INK)
			draw_rect(Rect2(12, 9, 64, 36), PALETTE.NIGHT)
			draw_rect(Rect2(18, 15, 42, 4), PALETTE.CYAN)
			draw_rect(Rect2(18, 25, 24, 4), PALETTE.EDGE)
			draw_rect(Rect2(60, 46, 8, 4), PALETTE.CYAN)
			draw_rect(Rect2(40, 53, 8, 10), PALETTE.INK)
			draw_rect(Rect2(26, 63, 36, 5), PALETTE.INK)
		"messages":
			draw_rect(Rect2(6, 12, 76, 50), PALETTE.INK)
			draw_rect(Rect2(10, 16, 68, 42), PALETTE.CYAN)
			draw_line(Vector2(8, 14), Vector2(44, 38), PALETTE.PANEL, 4)
			draw_line(Vector2(44, 38), Vector2(80, 14), PALETTE.PANEL, 4)
			draw_line(Vector2(8, 60), Vector2(30, 38), PALETTE.EDGE, 3)
			draw_line(Vector2(80, 60), Vector2(58, 38), PALETTE.EDGE, 3)
		"network":
			var globe := PackedVector2Array([Vector2(28, 6), Vector2(60, 6), Vector2(72, 18), Vector2(78, 30), Vector2(78, 46), Vector2(66, 62), Vector2(54, 70), Vector2(32, 70), Vector2(18, 62), Vector2(8, 48), Vector2(8, 28), Vector2(16, 14)])
			draw_colored_polygon(globe, PALETTE.NIGHT)
			var outline := globe.duplicate()
			outline.append(globe[0])
			draw_polyline(outline, PALETTE.INK, 3)
			draw_polyline(PackedVector2Array([Vector2(44, 6), Vector2(32, 20), Vector2(28, 38), Vector2(32, 56), Vector2(44, 70)]), PALETTE.CYAN, 3)
			draw_polyline(PackedVector2Array([Vector2(44, 6), Vector2(56, 20), Vector2(60, 38), Vector2(56, 56), Vector2(44, 70)]), PALETTE.CYAN, 3)
			draw_line(Vector2(12, 26), Vector2(74, 26), PALETTE.CYAN, 3)
			draw_line(Vector2(8, 46), Vector2(78, 46), PALETTE.CYAN, 3)
		"archive":
			draw_texture_rect(FOLDER, Rect2(8, 0, 72, 72), false)

