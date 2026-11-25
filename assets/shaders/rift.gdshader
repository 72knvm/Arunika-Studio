shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float elapsed = 0.0;

vec2 panel_grid(float stage) {
	if (stage < 0.5) { return vec2(1.0, 1.0); }
	if (stage < 1.5) { return vec2(1.0, 2.0); }
	if (stage < 2.5) { return vec2(2.0, 2.0); }
	if (stage < 3.5) { return vec2(2.0, 4.0); }
	return vec2(4.0, 4.0);
}

vec3 read_panel(vec2 uv, vec2 grid, vec2 screen_pixel) {
	vec2 cell = floor(uv * grid);
	vec2 local_uv = fract(uv * grid);
	vec2 source_uv = local_uv;
	// Wide intermediate panels crop vertically instead of squashing the sprite.
	float vertical_crop = min(1.0, grid.x / grid.y);
	source_uv.y = (source_uv.y - 0.5) * vertical_crop + 0.5 + 0.08 * (1.0 - vertical_crop);
	float copies = step(1.5, grid.x * grid.y);
	float seed = dot(cell, vec2(3.17, 5.83));
	vec2 drift = vec2(sin(floor(elapsed * 7.0) + seed), cos(floor(elapsed * 5.0) + seed));
	source_uv += drift * vec2(0.005, 0.003) * copies;
	vec3 picture = texture(screen_texture, clamp(source_uv, vec2(0.002), vec2(0.998))).rgb;
	vec2 edge = min(local_uv, vec2(1.0) - local_uv);
	float seam = max(1.0 - step(screen_pixel.x * grid.x * 1.5, edge.x),
		1.0 - step(screen_pixel.y * grid.y * 1.5, edge.y));
	return mix(picture, vec3(0.40, 0.29, 0.51), seam * copies * 0.8);
}

void fragment() {
	float growth = min(strength * 4.0, 3.9999);
	float stage = floor(growth);
	float transition = smoothstep(0.12, 0.88, fract(growth));
	vec3 before = read_panel(SCREEN_UV, panel_grid(stage), SCREEN_PIXEL_SIZE);
	vec3 after = read_panel(SCREEN_UV, panel_grid(stage + 1.0), SCREEN_PIXEL_SIZE);
	COLOR = vec4(mix(before, after, transition), 1.0);
}
