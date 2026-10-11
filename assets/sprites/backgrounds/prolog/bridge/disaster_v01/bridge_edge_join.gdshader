shader_type canvas_item;

// Align the paving/curb/fascia bands of the generated cap with the floor tile.
uniform sampler2D floor_texture : filter_nearest, repeat_disable;
uniform vec2 source_origin;
uniform vec2 source_size;
uniform vec2 display_size;
uniform float source_curb_y = 123.0;
uniform float source_join_bottom_y;
uniform bool join_on_right = false;
uniform float floor_phase_at_join = 0.0;
uniform float join_width = 64.0;
varying vec4 vertex_tint;

void vertex() {
	vertex_tint = COLOR;
}

void fragment() {
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));
	vec2 relative_uv = (UV * texture_size - source_origin) / source_size;
	vec2 local = relative_uv * display_size;
	// Floor source y884 is its dark curb seam, mapped from y818 over 109px.
	float curb_y = 66.0 * 109.0 / 123.0;
	float source_y;
	if (local.y <= curb_y) {
		source_y = local.y * source_curb_y / curb_y;
	} else {
		source_y = source_curb_y + (local.y - curb_y)
			* (source_join_bottom_y - source_curb_y) / (109.0 - curb_y);
	}
	if (source_y < 0.0 || source_y >= source_size.y) {
		discard;
	}
	vec4 cap = texture(TEXTURE, vec2(UV.x, (source_origin.y + source_y) / texture_size.y));
	if (cap.a < 0.5) {
		discard;
	}
	float join_x = join_on_right ? display_size.x : 0.0;
	float distance_from_join = abs(local.x - join_x);
	if (distance_from_join < join_width && local.y >= 0.0 && local.y < 109.0) {
		// Match the same 384px floor tile and alternating mirror at the join.
		float floor_x = floor_phase_at_join + local.x - join_x;
		float tile_index = floor(floor_x / 384.0);
		float tile_x = floor_x - tile_index * 384.0;
		if (mod(tile_index, 2.0) >= 1.0) {
			tile_x = 384.0 - tile_x;
		}
		vec2 floor_size = vec2(textureSize(floor_texture, 0));
		vec2 floor_uv = vec2(clamp(tile_x, 0.5, 383.5), 818.0 + local.y * 123.0 / 109.0) / floor_size;
		vec3 floor_color = texture(floor_texture, floor_uv).rgb;
		// Broad 4px steps keep the transition within the pixel-art grid.
		float blend = clamp(floor(distance_from_join / 4.0) * 4.0 / join_width, 0.0, 1.0);
		cap.rgb = mix(floor_color, cap.rgb, blend);
	}
	COLOR = vec4(cap.rgb, 1.0) * vertex_tint;
}
