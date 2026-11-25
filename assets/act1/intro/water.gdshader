shader_type canvas_item;

uniform bool shore_only = false;

void fragment() {
	float water = 1.0;
	if (shore_only) {
		float edge = 0.60 - 0.08 * UV.x;
		water = smoothstep(0.40, 0.46, UV.y) * (1.0 - smoothstep(edge - 0.04, edge, UV.y));
		water *= 1.0 - smoothstep(0.72, 0.86, UV.x);
	}
	vec2 motion = vec2(
		4.0 * sin(UV.y * 18.0 - TIME * 0.72) + 2.0 * sin(UV.x * 9.0 + TIME * 0.55),
		2.5 * sin(UV.x * 12.0 - TIME * 0.66)
	);
	vec2 sample_uv = clamp(UV + round(motion * water) * TEXTURE_PIXEL_SIZE, 0.0, 1.0);
	COLOR = texture(TEXTURE, sample_uv);
}
