shader_type canvas_item;

// Shared palette removes brightness drift between generated animation frames.
const vec3 PALETTE[14] = vec3[14](
	vec3(15.0, 16.0, 22.0) / 255.0,
	vec3(31.0, 31.0, 39.0) / 255.0,
	vec3(43.0, 43.0, 51.0) / 255.0,
	vec3(64.0, 64.0, 74.0) / 255.0,
	vec3(84.0, 84.0, 94.0) / 255.0,
	vec3(151.0, 149.0, 159.0) / 255.0,
	vec3(204.0, 201.0, 206.0) / 255.0,
	vec3(244.0, 242.0, 243.0) / 255.0,
	vec3(255.0, 206.0, 160.0) / 255.0,
	vec3(252.0, 179.0, 130.0) / 255.0,
	vec3(222.0, 144.0, 99.0) / 255.0,
	vec3(10.0, 177.0, 220.0) / 255.0,
	vec3(93.0, 220.0, 239.0) / 255.0,
	vec3(17.0, 73.0, 100.0) / 255.0
);

uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	if (COLOR.a < alpha_threshold) {
		discard;
	}
	vec3 nearest = PALETTE[0];
	float best_distance = 10.0;
	for (int i = 0; i < 14; i++) {
		vec3 difference = COLOR.rgb - PALETTE[i];
		float distance_squared = dot(difference, difference);
		if (distance_squared < best_distance) {
			best_distance = distance_squared;
			nearest = PALETTE[i];
		}
	}
	COLOR = vec4(nearest, 1.0);
}
