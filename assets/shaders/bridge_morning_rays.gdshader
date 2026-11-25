shader_type canvas_item;
render_mode unshaded;

uniform float sun_x = 1179.0;
uniform vec2 lamp_origin;
uniform float lamp_scale = 0.47;
uniform float lamp_spacing = 1100.0;

varying vec2 world_position;
const float RAY_SLOPE = 0.66;
const vec2 VIEW_SIZE = vec2(1672.0, 941.0);

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float band(float offset, float width, float edge) {
	return 1.0 - smoothstep(width - edge, width, abs(offset));
}

float lamp_shadow(float ray_x, float sample_y, vec2 top_left, vec2 bottom_right) {
	// Intersect the sunward ray with an opaque part of the lamp.
	float near_y = max(top_left.y, (ray_x - bottom_right.x) / RAY_SLOPE);
	float far_y = min(min(sample_y, bottom_right.y), (ray_x - top_left.x) / RAY_SLOPE);
	return smoothstep(-7.0, 2.0, far_y - near_y);
}

void fragment() {
	vec2 screen_pos = floor(SCREEN_UV * VIEW_SIZE / 4.0) * 4.0;
	vec2 from_sun = screen_pos - vec2(sun_x, 72.0);
	float distance_down = max(from_sun.y, 0.0);
	float axis = from_sun.x + distance_down * RAY_SLOPE;
	float halo = 0.075 * (1.0 - smoothstep(24.0, 190.0, length(from_sun)));
	float ray_width = 42.0 + distance_down * 0.26;
	float scatter = 0.085 * band(axis, ray_width, ray_width * 0.82);
	scatter *= smoothstep(24.0, 105.0, distance_down) * (1.0 - smoothstep(210.0, 570.0, distance_down));
	float surface_light = 0.13 * band(axis, 380.0, 290.0);
	surface_light *= smoothstep(430.0, 830.0, world_position.y);

	vec2 lamp_pos = (floor(world_position / 4.0) * 4.0 - lamp_origin) / lamp_scale;
	float spacing = lamp_spacing / lamp_scale;
	float ray_x = mod(lamp_pos.x + lamp_pos.y * RAY_SLOPE, spacing);
	// Bounds are measured in pixels of the existing lamp atlas crop.
	float shadow = lamp_shadow(ray_x, lamp_pos.y, vec2(308.0, 0.0), vec2(663.0, 135.0));
	shadow = max(shadow, lamp_shadow(ray_x, lamp_pos.y, vec2(162.0, 63.0), vec2(308.0, 164.0)));
	shadow = max(shadow, lamp_shadow(ray_x, lamp_pos.y, vec2(68.0, 124.0), vec2(165.0, 1110.0)));
	shadow = max(shadow, lamp_shadow(ray_x, lamp_pos.y, vec2(0.0, 1101.0), vec2(230.0, 1294.0)));
	// The pavement recedes into the scene, foreshortening the cast shadow.
	float floor_depth = lamp_pos.y - 1294.0;
	float floor_x = mod(lamp_pos.x + max(floor_depth, 0.0) * 2.4, spacing);
	float floor_shadow = 0.18 * band(floor_x - 114.0, 94.0, 42.0);
	floor_shadow *= smoothstep(1.0, 12.0, floor_depth) * (1.0 - smoothstep(100.0, 175.0, floor_depth));
	float illumination = halo + (scatter + surface_light) * (1.0 - shadow);
	float opacity = illumination + floor_shadow * (1.0 - illumination);
	vec3 tint = mix(vec3(1.0, 0.88, 0.64), vec3(0.09, 0.14, 0.22), floor_shadow * (1.0 - illumination) / max(opacity, 0.001));
	COLOR = vec4(tint, opacity);
}
