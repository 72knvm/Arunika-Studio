extends Node2D
## A subdivided snapshot lets the portal pull the leading edge before the tail.

const SHADER: Shader = preload("res://assets/shaders/pull.gdshader")
const COLUMNS := 24
const ROWS := 48

var progress := 0.0:
	set(value):
		progress = clampf(value, 0.0, 1.0)
		if is_instance_valid(pull_material):
			pull_material.set_shader_parameter("progress", progress)

var pull_material: ShaderMaterial
var surface: MeshInstance2D
var source_sprite: AnimatedSprite2D


func begin(sprite: AnimatedSprite2D, destination: Vector2) -> void:
	source_sprite = sprite
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var texture := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var size := texture.get_size()
	var rect := Rect2(sprite.offset - (size * 0.5 if sprite.centered else Vector2.ZERO), size)
	var frame_transform := global_transform.affine_inverse() * sprite.global_transform
	var vertices := PackedVector3Array()
	var uv := PackedVector2Array()
	var indices := PackedInt32Array()
	var bounds := Rect2(frame_transform * rect.position, Vector2.ZERO)
	for row in range(ROWS + 1):
		for column in range(COLUMNS + 1):
			var unit := Vector2(float(column) / COLUMNS, float(row) / ROWS)
			var point := frame_transform * (rect.position + rect.size * unit)
			bounds = bounds.expand(point)
			vertices.append(Vector3(point.x, point.y, 0.0))
			uv.append(Vector2(1.0 - unit.x if sprite.flip_h else unit.x, 1.0 - unit.y if sprite.flip_v else unit.y))
	for row in range(ROWS):
		for column in range(COLUMNS):
			var first := row * (COLUMNS + 1) + column
			indices.append_array(PackedInt32Array([first, first + 1, first + COLUMNS + 1,
				first + 1, first + COLUMNS + 2, first + COLUMNS + 1]))
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uv
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var target := to_local(destination)
	var origin := bounds.get_center()
	var axis := origin.direction_to(target)
	if axis.is_zero_approx():
		axis = Vector2.LEFT
	var half_span := maxf(1.0, absf(axis.x) * bounds.size.x * 0.5 + absf(axis.y) * bounds.size.y * 0.5)
	pull_material = ShaderMaterial.new()
	pull_material.shader = SHADER
	pull_material.set_shader_parameter("origin", origin)
	pull_material.set_shader_parameter("target", target)
	pull_material.set_shader_parameter("direction", axis)
	pull_material.set_shader_parameter("half_span", half_span)
	pull_material.set_shader_parameter("progress", progress)
	surface = MeshInstance2D.new()
	surface.mesh = mesh
	# AtlasTexture UVs belong to the original sheet; read just this frame once.
	surface.texture = ImageTexture.create_from_image(texture.get_image())
	surface.material = pull_material
	add_child(surface)
	sprite.hide()


func finish() -> void:
	hide()
	if is_instance_valid(source_sprite):
		source_sprite.show()
