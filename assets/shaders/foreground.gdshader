shader_type canvas_item;
void fragment() {
    vec4 pixel = texture(TEXTURE, UV);
    if (pixel.a < 0.5) { discard; }
    COLOR = vec4(pixel.rgb, 1.0);
}
