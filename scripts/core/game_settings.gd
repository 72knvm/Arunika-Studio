extends Node
## Persistent user preferences, independent of story progress.

signal changed
var config_path := "user://settings.cfg"
var master_volume := 1.0
var fullscreen := false
var text_speed := 42.0

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_window().title="KALA - Singkap Garis Waktu"
	load_preferences()
	call_deferred("apply_preferences")

func load_preferences() -> void:
	var config:=ConfigFile.new()
	if config.load(config_path)!=OK:
		return
	master_volume=_number(config.get_value("audio","master_volume",1.0),1.0,0.0,1.0)
	text_speed=_number(config.get_value("dialogue","text_speed",42.0),42.0,20.0,80.0)
	var saved_fullscreen: Variant=config.get_value("display","fullscreen",false)
	fullscreen=saved_fullscreen if saved_fullscreen is bool else false

func _number(value: Variant,fallback: float,low: float,high: float) -> float:
	if not (value is int or value is float) or not is_finite(float(value)):
		return fallback
	return clampf(float(value),low,high)

func apply_preferences() -> void:
	AudioServer.set_bus_mute(0,is_zero_approx(master_volume))
	AudioServer.set_bus_volume_db(0,linear_to_db(maxf(master_volume,0.001)))
	if not OS.has_feature("android") and DisplayServer.get_name()!="headless" and not Engine.is_embedded_in_editor():
		get_window().mode=Window.MODE_FULLSCREEN if fullscreen else Window.MODE_WINDOWED
	changed.emit()

func save_preferences() -> Error:
	var config:=ConfigFile.new()
	config.set_value("audio","master_volume",master_volume)
	config.set_value("display","fullscreen",fullscreen)
	config.set_value("dialogue","text_speed",text_speed)
	return config.save(config_path)

func set_volume(value: float) -> void:
	master_volume=clampf(value,0.0,1.0)
	AudioServer.set_bus_mute(0,is_zero_approx(master_volume))
	AudioServer.set_bus_volume_db(0,linear_to_db(maxf(master_volume,0.001)))
	changed.emit()

func set_text_speed(value: float) -> void:
	text_speed=clampf(value,20.0,80.0)
	changed.emit()

func set_fullscreen(value: bool) -> void:
	fullscreen=value
	if not OS.has_feature("android") and DisplayServer.get_name()!="headless" and not Engine.is_embedded_in_editor():
		get_window().mode=Window.MODE_FULLSCREEN if value else Window.MODE_WINDOWED
	changed.emit()
