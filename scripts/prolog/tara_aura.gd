extends Node2D
## Procedural aura only; no generated glow is needed in the character texture.

var strength := 0.0
var elapsed := 0.0
var radius := Vector2(105, 180)


func animate(delta: float) -> void:
	elapsed += delta
	queue_redraw()


func _draw() -> void:
	if strength <= 0.001:
		return
	var pulse := 0.75 + 0.25 * sin(elapsed * 3.2)
	for ring in range(3):
		var points := PackedVector2Array()
		var factor := 0.82 + ring * 0.13 + pulse * 0.04
		for index in range(33):
			var angle := TAU * index / 32.0
			points.append(Vector2(cos(angle), sin(angle)) * radius * factor)
		draw_polyline(points, Color(0.53, 0.22, 0.88, strength * (0.15 - ring * 0.035)), 3.0, false)
	for index in range(20):
		var angle := index * 2.39996 + elapsed * (0.13 if index % 2 == 0 else -0.11)
		var distance := 0.8 + float(index % 5) * 0.09
		var point := Vector2(cos(angle), sin(angle)) * radius * distance
		point.y -= fmod(elapsed * 18.0 + index * 23.0, 55.0)
		var size := 3.0 + index % 3
		draw_rect(Rect2(point.round(), Vector2.ONE * size), Color(0.72, 0.35, 1.0, strength * pulse * 0.65))
