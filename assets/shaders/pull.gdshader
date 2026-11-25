shader_type canvas_item;
render_mode unshaded;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 origin;
uniform vec2 target;
uniform vec2 direction = vec2(-1.0, 0.0);
uniform float half_span = 60.0;
varying vec2 pulled_position;

void vertex() {
	float leading = clamp(0.5 + dot(VERTEX - origin, direction) / (2.0 * half_span), 0.0, 1.0);
	// The near edge enters first, with a short delay for the trailing silhouette.
	float begins = mix(0.22, 0.0, leading);
	float arrives = mix(1.0, 0.82, leading);
	float intake = smoothstep(begins, arrives, progress);
	vec2 normal = vec2(-direction.y, direction.x);
	// Share the perpendicular squeeze across the body to avoid shearing the face.
	float narrowing = 1.0 - smoothstep(0.25, 1.0, progress);
	float centering = smoothstep(0.0, 1.0, progress);
	vec2 point = target + direction * dot(VERTEX - target, direction) * (1.0 - intake)
		+ normal * (dot(origin - target, normal) * (1.0 - centering)
		+ dot(VERTEX - origin, normal) * narrowing);
	VERTEX = floor(point + vec2(0.5));
	pulled_position = VERTEX;
}

void fragment() {
	vec4 sprite = texture(TEXTURE, UV);
	float core = length((pulled_position - target) / vec2(22.0, 32.0));
	if (sprite.a < 0.5 || (progress > 0.1 && core < 1.0)) {
		discard;
	}
	COLOR = vec4(sprite.rgb, 1.0);
}
