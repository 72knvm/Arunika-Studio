extends AudioStreamPlayer
## Keep confirmation clicks audible through pause and menu scene changes.

const CONFIRM: AudioStream = preload("res://assets/audio/prolog/archive_select.ogg")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = CONFIRM
	volume_db = -5.0
	pitch_scale = 1.16
