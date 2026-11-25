shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float row = floor(UV.y * 344.0);
	float scanlines = 1.0 - step(1.0, mod(row, 8.0));
	float sweep = 1.0 - smoothstep(0.0, 0.032, abs(UV.y - fract(TIME * 0.22)));
	COLOR = vec4(0.48, 0.81, 0.85, scanlines * 0.075 + sweep * 0.08);
}
