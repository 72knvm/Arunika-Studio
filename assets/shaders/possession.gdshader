shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float pulse = 0.0;
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	if (source.a < alpha_threshold) {
		discard;
	}
	vec2 step_uv = TEXTURE_PIXEL_SIZE * 4.0;
	float border_alpha = min(min(texture(TEXTURE, UV + vec2(step_uv.x, 0.0)).a,
		texture(TEXTURE, UV - vec2(step_uv.x, 0.0)).a),
		min(texture(TEXTURE, UV + vec2(0.0, step_uv.y)).a,
		texture(TEXTURE, UV - vec2(0.0, step_uv.y)).a));
	float rim = 1.0 - step(alpha_threshold, border_alpha);
	vec3 tint = vec3(0.58, 0.19, 0.90);
	vec3 color = mix(source.rgb, tint, strength * (0.025 + rim * (0.22 + pulse * 0.12)));
	COLOR = vec4(color, 1.0);
}
