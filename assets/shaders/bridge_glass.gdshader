shader_type canvas_item;

uniform float glass_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec2 glass_x = vec2(0.229665072, 0.427631579);
uniform vec2 glass_y = vec2(0.774707758, 0.844845909);

void fragment() {
	if (COLOR.a < 0.5) {
		discard;
	}
	bool glass = UV.x > glass_x.x && UV.x < glass_x.y
		&& UV.y > glass_y.x && UV.y < glass_y.y;
	COLOR.a = glass ? glass_opacity : 1.0;
}
