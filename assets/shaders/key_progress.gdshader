shader_type canvas_item;

// Trace inside the supplied keycap silhouette instead of drawing a separate frame.
uniform vec4 atlas_rect = vec4(0.0, 0.0, 1.0, 1.0);
uniform float progress_ratio : hint_range(0.0, 1.0) = 0.0;
uniform float border_width : hint_range(0.01, 0.1) = 0.045;
uniform vec4 progress_color : source_color = vec4(0.8941, 0.7412, 0.4588, 1.0);

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	if (source.a < 0.5) {
		discard;
	}
	vec2 local_uv = (UV - atlas_rect.xy) / atlas_rect.zw;
	vec2 offset = atlas_rect.zw * border_width;
	float interior_alpha = 1.0;
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			interior_alpha = min(interior_alpha,
				texture(TEXTURE, UV + vec2(float(x), float(y)) * offset).a);
		}
	}
	float border = 1.0 - step(0.5, interior_alpha);
	vec2 centered = local_uv - vec2(0.5);
	float clockwise = fract(atan(centered.x, -centered.y) / TAU + 1.0);
	float filled = step(clockwise, progress_ratio) * step(0.00001, progress_ratio);
	COLOR.rgb = mix(COLOR.rgb, progress_color.rgb, border * filled);
}

