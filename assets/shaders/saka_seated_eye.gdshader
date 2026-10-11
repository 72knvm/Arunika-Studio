shader_type canvas_item;

uniform bool normal_eye = false;

void fragment() {
	if (COLOR.a < 0.5) {
		discard;
	}
	// The mirrored pose shows Saka's normal left eye, not his cyan right lens.
	if (normal_eye && UV.y < 0.4 && COLOR.b > COLOR.r * 1.25 && COLOR.g > COLOR.r * 1.25) {
		COLOR.rgb = vec3(0.68, 0.70, 0.71);
	}
	COLOR.a = 1.0;
}
