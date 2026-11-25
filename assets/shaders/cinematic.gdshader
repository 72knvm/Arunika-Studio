shader_type canvas_item;
render_mode unshaded;

// Crops stay in normalized source coordinates so a higher resolution master
// with the same framing can replace the PNG without changing the shots.
uniform vec4 source_rect = vec4(0.0, 0.0, 1.0, 1.0);
varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	vec2 source_uv = source_rect.xy + UV * source_rect.zw;
	vec4 sampled = texture(TEXTURE, source_uv);
	// Fragment COLOR already contains the uncropped texture sample in Godot.
	// Use the vertex tint so the old full image is not multiplied over the crop.
	COLOR = sampled * vertex_color;
}
