shader_type canvas_item;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float light = dot(source.rgb, vec3(0.25, 0.5, 0.25));
	COLOR = vec4(mix(vec3(0.075, 0.04, 0.16), vec3(0.36, 0.20, 0.44), light), source.a);
}
