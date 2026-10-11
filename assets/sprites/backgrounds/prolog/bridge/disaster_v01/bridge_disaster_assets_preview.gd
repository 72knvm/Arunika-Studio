extends Node2D
## Independent art review: no actors, gameplay collision, or story transitions.

@onready var camera: Camera2D = $Camera2D
var pan := 0.0


func _ready() -> void:
	if "--capture-disaster-assets" in OS.get_cmdline_user_args():
		set_process(false)
		call_deferred("_capture")


func _process(delta: float) -> void:
	var direction := float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))
	direction -= float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT))
	pan = clampf(pan + direction * 160.0 * delta, -110.0, 110.0)
	camera.position.x = 836.0 + pan
	if Input.is_physical_key_pressed(KEY_R):
		pan = 0.0
		camera.position.x = 836.0


func _capture() -> void:
	await _save_view("res://outputs/bridge_disaster_assets_v01.png")
	var anchors := _screen_anchors()
	camera.position.x = 946.0
	camera.force_update_scroll()
	await _save_view("res://outputs/bridge_disaster_assets_pan_right_v01.png")
	var shifted := _screen_anchors()
	for name in anchors:
		var actual: float = shifted[name] - anchors[name]
		var expected := -110.0
		if name == "Sky":
			expected *= 0.01
		elif name in ["Sea", "City"]:
			expected *= 0.025
		if absf(actual - expected) > 0.2:
			push_error("Parallax mismatch for %s: %s, expected %s" % [name, actual, expected])
			get_tree().quit(1)
			return
		print("PARALLAX_OK ", name, ": ", actual)
	camera.position.x = 726.0
	camera.force_update_scroll()
	await _save_view("res://outputs/bridge_disaster_assets_pan_left_v01.png")
	print("DISASTER_ASSET_PREVIEW_CAPTURE_OK")
	get_tree().quit()


func _screen_anchors() -> Dictionary:
	return {
		"Sky": $Sky/Art.get_global_transform_with_canvas().origin.x,
		"Sea": $Sea/Art.get_global_transform_with_canvas().origin.x,
		"City": $City/Art.get_global_transform_with_canvas().origin.x,
		"Foreground": $Foreground/LeftBank.get_global_transform_with_canvas().origin.x,
	}


func _save_view(output: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var error := get_viewport().get_texture().get_image().save_png(output)
	if error != OK:
		push_error("Disaster asset preview capture failed: %s" % error)
		get_tree().quit(1)
		return
	print("CAPTURE_OK: ", output)
