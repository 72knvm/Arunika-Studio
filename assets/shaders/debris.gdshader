shader_type canvas_item;

uniform bool align_front_face = false;
uniform float front_face_local_y = 162.0;
varying float local_y;

void vertex() {
	local_y=VERTEX.y;
}

void fragment() {
	vec2 step_uv = TEXTURE_PIXEL_SIZE*3.0;
	vec2 center_uv = (floor(UV/step_uv)+vec2(0.5))*step_uv;
	vec4 pixel = vec4(0.0);
	for (int x=-1;x<=1;x++) {
		for (int y=-1;y<=1;y++) {
			pixel += texture(TEXTURE,center_uv+vec2(float(x),float(y))*TEXTURE_PIXEL_SIZE);
		}
	}
	pixel /= 9.0;
	if (pixel.a<0.5) { discard; }
	float value = max(pixel.r,max(pixel.g,pixel.b));
	vec3 color = vec3(0.066666667,0.094117647,0.141176471);
	if (value>0.15) { color=vec3(0.141176471,0.192156863,0.235294118); }
	if (value>0.30) { color=vec3(0.254901961,0.286274510,0.352941176); }
	if (value>0.43) { color=vec3(0.384313725,0.392156863,0.466666667); }
	if (value>0.70) { color=vec3(0.541176471,0.517647059,0.580392157); }
	if (align_front_face && local_y>front_face_local_y) {
		color = value<0.15 ? vec3(0.066666667,0.094117647,0.141176471) : vec3(0.141176471,0.192156863,0.235294118);
	}
	COLOR=vec4(color,1.0);
}
