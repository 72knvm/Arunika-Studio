extends Node2D
## Progress reflects ResourceLoader; no artificial percentage or long delay.
const PROLOG := "res://scenes/prolog/prolog.tscn"
const MODAL = preload("res://scripts/ui/menu_modal.gd")
# Android 4.7.x can leave threaded PackedScene requests in progress indefinitely.
# Load small, ordered dependencies on the main thread, yielding between stages.
const ANDROID_STAGES := ["res://scenes/prolog/room.tscn", "res://scenes/prolog/tara.tscn", PROLOG]
@export var use_ordered_loading := false
@export var prolog_path := PROLOG
var elapsed := 0.0
var requested := false
var completed := false
var _staged_resources: Array[Resource] = []
@onready var label: Label = $Interface/Loading

func _ready() -> void:
	if OS.has_feature("android") or use_ordered_loading:
		_load_in_order.call_deferred()
		return
	var error := ResourceLoader.load_threaded_request(prolog_path)
	requested = error == OK
	if not requested:
		_failed("Prolog tidak bisa disiapkan.")

func _process(delta: float) -> void:
	if completed or not requested:
		return
	elapsed += delta
	label.text = "Loading" + ".".repeat(1 + int(elapsed * 2.0) % 3)
	var status := ResourceLoader.load_threaded_get_status(prolog_path)
	if status == ResourceLoader.THREAD_LOAD_LOADED and elapsed >= 0.35:
		completed = true
		var scene := ResourceLoader.load_threaded_get(prolog_path) as PackedScene
		if scene == null or get_tree().change_scene_to_packed(scene) != OK:
			_failed("Prolog gagal dibuka.")
	elif status in [ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE]:
		_failed("Resource prolog gagal dimuat.")
	elif elapsed >= 30.0:
		_failed("Pemuatan belum selesai. Kembali ke menu dan coba lagi.")


func _load_in_order() -> void:
	for index in ANDROID_STAGES.size():
		if not is_inside_tree():
			return
		label.text = "Menyiapkan kamar..." if index < 2 else "Memulai prolog..."
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var path: String = prolog_path if index == 2 else ANDROID_STAGES[index]
		var resource := ResourceLoader.load(path)
		if resource == null:
			_failed("Resource prolog gagal dimuat.")
			return
		_staged_resources.append(resource)
	completed = true
	var scene := _staged_resources.back() as PackedScene
	if scene == null or get_tree().change_scene_to_packed(scene) != OK:
		_failed("Prolog gagal dibuka.")

func _failed(message: String) -> void:
	completed = true
	label.hide()
	var panel := MODAL.new("Loading gagal", Vector2(780, 380))
	panel.add_label(message)
	var back := panel.add_button("Kembali ke menu", _back)
	panel.closed.connect(_back)
	$Interface.add_child(panel)
	back.grab_focus()

func _back() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
