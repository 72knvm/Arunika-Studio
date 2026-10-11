extends Node2D

const FRAMES: SpriteFrames = preload("res://assets/sprites/characters/saka/actions_v01/saka_sprint_frames_v04.tres")
var sprites: Array[AnimatedSprite2D] = []
var playing := false

func _ready() -> void:
	add_label("SAKA SPRINT v04  /  SAMBUNGAN PINGGANG",Vector2(55,38),26)
	add_label("Kaki dekat kamera: abu-abu · kaki jauh: hitam   |   SPACE: playback",Vector2(55,83),20)
	for i in range(8):
		var foot := Vector2(285+(i%4)*370,480+(i/4)*400)
		var text := "%d" % (i+1)
		if i == 2 or i == 3:
			text += " · REVISI"
		add_label(text,Vector2(foot.x-80,145 if i < 4 else 548),20)
		var sprite := AnimatedSprite2D.new()
		sprite.sprite_frames = FRAMES
		sprite.centered = false
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var material := ShaderMaterial.new()
		material.shader = preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
		sprite.material = material
		sprite.scale = Vector2.ONE*0.81
		sprite.position = foot-Vector2(550,500)*0.81
		sprite.animation = &"sprint"
		sprite.frame = i
		add_child(sprite)
		sprites.append(sprite)
		assert(FRAMES.get_frame_texture(&"sprint",i).get_size() == Vector2(1100,520))
	if "--capture-saka-sprint-v04" in OS.get_cmdline_user_args():
		call_deferred("capture")

func add_label(value: String, at: Vector2, font_size: int) -> void:
	var label := Label.new()
	label.text = value
	label.position = at
	label.add_theme_font_size_override("font_size",font_size)
	add_child(label)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
		playing = not playing
		for i in range(8):
			if playing:
				sprites[i].play()
			else:
				sprites[i].pause()
				sprites[i].frame = i

func capture() -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var error := get_viewport().get_texture().get_image().save_png("res://outputs/characters/saka_sprint_review_v04.png")
	if error != OK:
		push_error("Sprint capture failed: %s" % error)
		get_tree().quit(1)
		return
	print("SAKA_SPRINT_V04_RENDER_OK: all eight frame atlases checked.")
	get_tree().quit()
