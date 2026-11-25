extends Node2D

@export_range(1.0,30.0,0.1) var loop_seconds:=8.0
@export_range(0.0,16.0,0.1) var saka_amplitude:=5.5813953488
@export_range(0.0,40.0,0.1) var tara_amplitude:=18.1395348837
var elapsed:=0.0
var background_material: ShaderMaterial
var hair_material: ShaderMaterial

func _ready() -> void:
	background_material=$Background.material.duplicate() as ShaderMaterial
	$Background.material=background_material
	hair_material=$Hair.material.duplicate() as ShaderMaterial
	$Hair.material=hair_material
	hair_material.set_shader_parameter("saka_amplitude",saka_amplitude)
	hair_material.set_shader_parameter("tara_amplitude",tara_amplitude)
	apply_phase(0.0)

func apply_phase(phase: float) -> void:
	background_material.set_shader_parameter("ambience_phase",phase)
	hair_material.set_shader_parameter("wind_phase",phase)

func _process(delta: float) -> void:
	elapsed=fmod(elapsed+delta,loop_seconds)
	apply_phase(TAU*elapsed/loop_seconds)
