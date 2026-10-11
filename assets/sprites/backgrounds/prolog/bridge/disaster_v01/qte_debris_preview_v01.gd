extends Node2D

func _ready() -> void:
	if "--capture-qte-debris" in OS.get_cmdline_user_args():
		call_deferred("_capture")

func _capture() -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var error := get_viewport().get_texture().get_image().save_png("res://outputs/qte_debris_simple_v01.png")
	if error != OK:
		push_error("QTE debris preview failed: %s" % error)
		get_tree().quit(1)
		return
	print("QTE_DEBRIS_PREVIEW_OK")
	get_tree().quit()
