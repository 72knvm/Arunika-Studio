shader_type canvas_item;

// Temporary ruined skyline: collapsed columns and cold lighting.
void fragment() {
	float column = floor(UV.x * 32.0);
	float collapse = 0.64 + 0.27 * abs(sin(column * 7.1));
	vec2 broken_uv = vec2(UV.x, (UV.y - 0.64) / collapse + 0.64);
	vec4 source = texture(TEXTURE, broken_uv);
	if (source.a < 0.5 || broken_uv.y < 0.0 || broken_uv.y > 1.0) {
		discard;
	}
	float light = dot(source.rgb, vec3(0.25, 0.5, 0.25));
	COLOR = vec4(mix(vec3(0.08, 0.055, 0.17), vec3(0.37, 0.19, 0.48), light), 1.0);
}
