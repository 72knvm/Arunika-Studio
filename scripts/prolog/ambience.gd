extends Node

var _fade: Tween


func set_mix(levels: Dictionary, duration: float = 0.65) -> void:
	if _fade != null:
		_fade.kill()
	_fade = create_tween().set_parallel()
	for player: AudioStreamPlayer in get_children():
		var active := levels.has(player.name)
		if active and not player.playing:
			player.volume_linear = 0.0
			player.play()
		if player.playing:
			var gain := db_to_linear(float(levels[player.name])) if active else 0.0
			_fade.tween_property(player, "volume_linear", gain, duration)
	_fade.chain().tween_callback(_stop_unused.bind(levels))


func _stop_unused(levels: Dictionary) -> void:
	for player: AudioStreamPlayer in get_children():
		if not levels.has(player.name):
			player.stop()
