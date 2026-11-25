shader_type canvas_item;
uniform float glass_opacity : hint_range(0.0, 1.0) = 0.48;
void fragment() {
    vec4 pixel = texture(TEXTURE, UV);
    if (pixel.a < 0.5) { discard; }
    // AtlasTexture sends full-source UVs. Match the existing production glass area.
    bool glass = UV.x > 0.1567 && UV.x < 0.8537 && UV.y > 0.3208 && UV.y < 0.7077;
    COLOR = vec4(pixel.rgb, glass ? glass_opacity : 1.0);
}
