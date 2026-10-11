extends Node2D
## Independent art preview; existing character controller and gameplay are untouched.

const APPROVED: SpriteFrames = preload("res://assets/sprites/characters/saka/saka_user_walk_frames_v04.tres")
const ACTIONS: SpriteFrames = preload("res://assets/sprites/characters/saka/actions_v01/saka_action_frames_v01.tres")
const ACTION_SCENE: PackedScene = preload("res://assets/sprites/characters/saka/actions_v01/saka_action_sprite_v01.tscn")
const WALK_ANCHORS := [191.5,164.5,162.5,174.0,205.5,183.5,135.0,178.5]

var originals: Array[AnimatedSprite2D] = []
var actors: Array[Node2D] = []
var paused := false
var elapsed := 0.0
var selected := 0
var status: Label

func _ready() -> void:
	label_at("SAKA  /  SPRINT · JUMP · SLIDE", Vector2(60,55), 30)
	label_at("Referensi asli di kiri · semua aksi baru menghadap kanan", Vector2(60,104), 21)
	label_at("1–3 pilih aksi  |  SPACE pause  |  ← / → cek frame  |  R ulang", Vector2(60,859), 20)
	status = label_at("", Vector2(60,898), 18)
	var names := ["IDLE ASLI","WALK ASLI","SPRINT · 8 FRAME","JUMP · 6 FRAME","SLIDE · 4 FRAME"]
	var columns := [170.0,420.0,710.0,1010.0,1340.0]
	for i in range(5):
		label_at(names[i], Vector2(columns[i]-100,196), 20)
	var shader := preload("res://assets/shaders/sprite_alpha_cutout.gdshader")
	for i in range(2):
		var original := AnimatedSprite2D.new()
		original.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		original.sprite_frames = APPROVED
		var mat := ShaderMaterial.new()
		mat.shader = shader
		original.material = mat
		add_child(original)
		original.play(&"idle" if i == 0 else &"walk")
		originals.append(original)
	for i in range(3):
		var actor := ACTION_SCENE.instantiate()
		actor.action = [&"sprint",&"jump",&"slide"][i]
		actor.position = Vector2(columns[i+2],710)
		add_child(actor)
		actors.append(actor)
	for name in ACTIONS.get_animation_names():
		for frame in range(ACTIONS.get_frame_count(name)):
			assert(ACTIONS.get_frame_texture(name,frame).get_size() == Vector2(1100,520))
	print("SAKA_ACTION_ATLASES_OK: all frames have the same padded canvas.")
	if "--capture-saka-actions" in OS.get_cmdline_user_args():
		call_deferred("capture")

func label_at(value: String, at: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("e9e7e4"))
	add_child(label)
	return label

func _process(delta: float) -> void:
	for i in range(2):
		var sprite := originals[i]
		var texture := APPROVED.get_frame_texture(sprite.animation,sprite.frame)
		var factor := 380.0/(543.0 if i == 0 else 634.0)
		var pivot: float = [84.5,85.0,85.0,84.5][sprite.frame] if i == 0 else WALK_ANCHORS[sprite.frame]
		sprite.scale = Vector2.ONE * factor
		sprite.offset = Vector2(0,-texture.get_height()*0.5)
		sprite.position = Vector2((170.0 if i == 0 else 420.0)+(texture.get_width()*0.5-pivot)*factor,710)
	if not paused:
		elapsed += delta
		if elapsed >= 1.1:
			elapsed = 0.0
			actors[1].show_action(&"jump")
			actors[2].show_action(&"slide")
	var focus: AnimatedSprite2D = actors[selected].sprite
	status.text = "Dipilih: %s  ·  frame %d / %d%s" % [focus.animation,focus.frame+1,ACTIONS.get_frame_count(focus.animation),"  ·  PAUSED" if paused else ""]

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_1, KEY_2, KEY_3:
			selected = event.physical_keycode-KEY_1
		KEY_SPACE:
			paused = not paused
			for actor in actors:
				if paused:
					actor.sprite.pause()
				else:
					actor.sprite.play()
			for sprite in originals:
				if paused:
					sprite.pause()
				else:
					sprite.play()
		KEY_LEFT, KEY_RIGHT:
			paused = true
			for actor in actors:
				actor.sprite.pause()
			for sprite in originals:
				sprite.pause()
			var sprite: AnimatedSprite2D = actors[selected].sprite
			var step := -1 if event.physical_keycode == KEY_LEFT else 1
			sprite.frame = posmod(sprite.frame+step,ACTIONS.get_frame_count(sprite.animation))
		KEY_R:
			elapsed = 0.0
			for actor in actors:
				actor.show_action(actor.action,not paused)

func capture() -> void:
	paused = true
	for sprite in originals:
		sprite.pause()
		sprite.frame = 0
	for i in range(3):
		actors[i].sprite.pause()
		actors[i].sprite.frame = [0,3,1][i]
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var error := get_viewport().get_texture().get_image().save_png("res://outputs/characters/saka_actions_preview_v01.png")
	if error != OK:
		push_error("Saka action capture failed: %s" % error)
		get_tree().quit(1)
		return
	# Render every action frame at least once to catch missing/invalid atlas resources.
	for actor in actors:
		for frame in range(ACTIONS.get_frame_count(actor.action)):
			actor.sprite.frame = frame
			await get_tree().process_frame
			await RenderingServer.frame_post_draw
	print("SAKA_ACTION_PREVIEW_OK: 8 sprint, 6 jump, 4 slide frames rendered.")
	get_tree().quit()
