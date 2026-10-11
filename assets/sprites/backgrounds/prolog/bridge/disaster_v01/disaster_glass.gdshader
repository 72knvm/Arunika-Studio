shader_type canvas_item;

uniform float glass_opacity : hint_range(0.0, 1.0) = 0.48;

void fragment() {
	if (COLOR.a < 0.5) {
		discard;
	}
	bool glass = COLOR.g > 0.55 && COLOR.b > 0.65 && COLOR.r < 0.65;
	COLOR.a = glass ? glass_opacity : 1.0;
}
