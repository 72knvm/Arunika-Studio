extends AudioStreamPlayer

const INTERVAL := 0.13

var _cooldown := 0.0


func reset() -> void:
	stop()
	_cooldown = 0.0


func update_reveal(delta: float, text: String, previous_count: int, visible_count: int) -> void:
	_cooldown -= delta
	if _cooldown > 0.0 or visible_count <= previous_count:
		return
	if text.substr(previous_count, visible_count - previous_count).strip_edges().is_empty():
		return
	play()
	_cooldown = INTERVAL
