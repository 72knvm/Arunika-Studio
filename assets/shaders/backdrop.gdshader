shader_type canvas_item;

// Review-only material. The PNG already contains the intended finite palette.
uniform float source_offset_x = 0.0;

void fragment() {
	vec2 source_uv = vec2(clamp(UV.x + source_offset_x, 0.0, 1.0), UV.y);
	vec4 pixel = texture(TEXTURE, source_uv);
	if (pixel.a < 0.5) {
		discard;
	}
	COLOR = vec4(pixel.rgb, 1.0);
}
