shader_type canvas_item;

// Candidate-only material. The exported PNG already contains the six morning colors.
// Preserve the active waterfront UV registration without its dusk/gold palette remap.
uniform float source_offset_x = 0.020334928;

void fragment() {
	vec2 sample_uv = vec2(clamp(UV.x + source_offset_x, 0.0, 1.0), UV.y);
	vec4 pixel = texture(TEXTURE, sample_uv);
	if (pixel.a < 0.5) {
		discard;
	}
	COLOR = vec4(pixel.rgb, 1.0);
}
