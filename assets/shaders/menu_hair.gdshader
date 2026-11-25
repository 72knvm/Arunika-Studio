shader_type canvas_item;
uniform float wind_phase=0.0;
uniform float saka_amplitude=5.5813953488;
uniform float tara_amplitude=18.1395348837;

void fragment() {
	vec2 size=vec2(1920.0,1080.0);
	vec2 p=UV*size;
	float dx=0.0;
	if(p.x<976.7441860465) {
		// Upper Saka hair bends; nape and the lower part remain anchored.
		float tip=clamp((400.7812500000-p.y)/286.8750000000,0.0,1.0);
		dx=saka_amplitude*pow(tip,1.3)*sin(wind_phase-0.7*tip);
	} else {
		// Tara's head and upper hair are fixed. One broad wave travels to the tips.
		float length_position=clamp((p.y-541.4062500000)/351.5625000000,0.0,1.0);
		float anchored=smoothstep(541.4062500000,618.7500000000,p.y);
		dx=tara_amplitude*pow(length_position,1.25)*anchored*sin(wind_phase-1.8*length_position);
	}
	COLOR=texture(TEXTURE,(p-vec2(dx,0.0))/size);
}
