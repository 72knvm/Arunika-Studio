shader_type canvas_item;

// The extracted PNG has opaque cyan panes. Give only the glass runtime alpha.
uniform float glass_opacity : hint_range(0.0, 1.0) = 0.42;
uniform vec2 glass_y = vec2(0.1167, 0.3917);

void fragment() {
	if (COLOR.a < 0.5) {
		discard;
	}
	bool glass = UV.y > glass_y.x && UV.y < glass_y.y
		&& COLOR.g > 0.55 && COLOR.b > 0.65 && COLOR.r < 0.65;
	COLOR.a = glass ? glass_opacity : 1.0;
}
