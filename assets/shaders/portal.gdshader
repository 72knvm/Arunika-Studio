shader_type canvas_item;
render_mode unshaded;

uniform vec2 portal_radius = vec2(128.0, 170.0);
uniform vec2 surface_size = vec2(384.0, 510.0);
uniform float elapsed = 0.0;
uniform float openness : hint_range(0.0, 1.0) = 0.0;
uniform float intake : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_size = 3.0;

void fragment() {
	vec2 pixel = floor((UV - vec2(0.5)) * surface_size / pixel_size) * pixel_size;
	vec2 point = pixel / max(portal_radius, vec2(1.0));
	float open_size = max(openness, 0.001);
	float radius = length(point) / open_size;
	float angle = atan(point.y, point.x);
	float clock = elapsed;
	float edge = radius + 0.024 * sin(angle * 9.0 + clock * 1.7)
		+ 0.012 * sin(angle * 15.0 - clock);
	vec4 color = vec4(0.0);
	if (openness > 0.005 && edge < 1.0) {
		color = vec4(0.055, 0.040, 0.085, 1.0);
		float spiral = fract(angle / 6.283185 * 3.0 + log(max(radius, 0.04)) * 0.7 + clock);
		if (radius > 0.12 && spiral < 0.20) {
			color.rgb = vec3(0.13, 0.08, 0.19);
		}
		if (edge > 0.83) {
			color.rgb = vec3(0.34, 0.20, 0.44);
		}
		if (edge > 0.94) {
			color.rgb = vec3(0.60, 0.39, 0.73);
			if (mod(floor(angle * 10.0 + clock * 3.0), 4.0) < 1.0) {
				color.rgb = vec3(0.78, 0.65, 0.87);
			}
		}
	}
	// Square motes spiral toward the opening rather than drifting away from it.
	for (int i = 0; i < 24; i++) {
		float index = float(i);
		float travel = fract(index * 0.173 + elapsed * (0.3 + intake * 0.45));
		float direction = index * 2.39996 + clock * 0.5 + travel * 0.7;
		float distance_to_core = mix(1.45, 0.15, travel) * open_size;
		vec2 mote = vec2(cos(direction), sin(direction)) * distance_to_core;
		vec2 half_size = vec2(pixel_size * (1.0 + mod(index, 2.0))) / portal_radius;
		if (openness > 0.1 && all(lessThan(abs(point - mote), half_size))) {
			color = vec4(0.60, 0.39, 0.73, openness * (1.0 - travel * 0.5));
		}
	}
	COLOR = color;
}
