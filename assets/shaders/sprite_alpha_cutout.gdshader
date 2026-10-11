shader_type canvas_item;

// Reject faint generator halos while preserving the opaque sprite silhouette.
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	if (COLOR.a < alpha_threshold) {
		discard;
	}
	COLOR.a = 1.0;
}
