extends Node2D
## Isolated pose review before wiring the opening dialogue.

@onready var room: Node2D = $Room
@onready var tara: Node2D = $Tara
var sleeping := true


func _ready() -> void:
	room.set_process(false)
	room.set_process_unhandled_key_input(false)
	room.get_node("Overlay/Panel").hide()
	room.get_node("SakaPreview").set_physics_process(false)
	room.set_saka_sleeping(true)
	tara.display_height = 380.0 * 163.0 / 184.0
	tara.get_node("Sprite").flip_h = true
	tara.stop_follow()
	if "--capture-sleep" in OS.get_cmdline_user_args():
		call_deferred("_capture")


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
		sleeping = not sleeping
		room.set_saka_sleeping(sleeping)
		get_viewport().set_input_as_handled()


func _capture() -> void:
	$Overlay.hide()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var result := get_viewport().get_texture().get_image().save_png("res://outputs/characters/saka_sleep_room_preview.png")
	print("SAKA_SLEEP_CAPTURE: ", result)
	get_tree().quit(0 if result == OK else 1)
