shader_type canvas_item;

uniform float waterline_y;
uniform bool floating_actor = false;

varying vec2 world_position;
varying vec4 tint;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	tint = COLOR;
}

void fragment() {
	float swell = 3.6 * sin(world_position.x * 0.018 - TIME * 1.7)
		+ 1.8 * sin(world_position.x * 0.036 + TIME * 1.2);
	float depth = world_position.y - waterline_y;
	if (floating_actor) {
		vec4 actor = texture(TEXTURE, UV);
		float immersion = smoothstep(swell, swell + 19.0, depth);
		actor.rgb = mix(actor.rgb, vec3(0.11, 0.37, 0.40), immersion * 0.69);
		actor.a *= 1.0 - immersion * 0.91;
		COLOR = actor * tint;
	} else {
		float near_surface = 1.0 - smoothstep(7.0, 67.0, abs(depth));
		float underwater = smoothstep(-15.0, 70.0, depth);
		vec2 motion = vec2(underwater * 3.0 * sin(world_position.y * 0.027 + TIME * 0.7), near_surface * swell);
		vec2 sample_uv = clamp(UV - round(motion) * TEXTURE_PIXEL_SIZE, 0.0, 1.0);
		COLOR = texture(TEXTURE, sample_uv) * tint;
	}
}
