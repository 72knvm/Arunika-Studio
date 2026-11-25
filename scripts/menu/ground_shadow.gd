extends Node2D

func _draw() -> void:
	# These simple contact ellipses are geometry, not extra image layers.
	var shadow:=Color(0.21,0.15,0.29,0.24)
	for item in [Vector4(1090,838,172,14),Vector4(1353,837,147,15),Vector4(954,849,39,6),Vector4(1225,854,75,7)]:
		var points:=PackedVector2Array()
		for i in range(64):
			var angle:=TAU*float(i)/64.0
			points.append(Vector2(item.x+cos(angle)*item.z,item.y+sin(angle)*item.w))
		draw_colored_polygon(points,shadow)
