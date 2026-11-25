extends Node
## Run after actor movement so Tara shares the camera's physics snapshots.

@onready var scene: Node2D = get_parent()

func _ready() -> void:
	process_physics_priority = 100

func _physics_process(delta: float) -> void:
	scene.update_maestro_hover(delta)
