shader_type canvas_item;
uniform float ambience_phase=0.0;

float star_at(vec2 p,vec2 center,float offset) {
    vec2 d=abs(p-center);
    float square=(1.0-smoothstep(3.0,5.0,d.x))*(1.0-smoothstep(3.0,5.0,d.y));
    float pulse=0.5+0.5*cos(2.0*ambience_phase+offset);
    float brightness=0.20+0.80*pow(pulse,1.5);
    return square*(brightness-1.0);
}

void fragment() {
    vec2 size=vec2(1672.0,941.0);
    vec2 p=UV*size;
    vec4 original=texture(TEXTURE,UV);
    // A procedural shoreline bounds the sea; no auxiliary mask textures.
    float shore_y=738.0-0.073*p.x;
    float water=smoothstep(442.0,472.0,p.y)*(1.0-smoothstep(shore_y-18.0,shore_y+5.0,p.y));
    float row=p.y*0.022;
    float dy=2.0*(sin(ambience_phase+row)-sin(row))*water;
    float dx=1.2*(sin(ambience_phase+p.y*0.035)-sin(p.y*0.035))*water;
    vec4 result=texture(TEXTURE,(p-vec2(dx,dy))/size);
    float reflection=step(0.48,original.r)*step(0.36,original.g)*water;
    result.rgb*=1.0+0.07*reflection*(sin(ambience_phase+p.y*0.075)-sin(p.y*0.075));
    float star_weight=0.0;
    star_weight+=star_at(p,vec2(689.095,20.959),0.00000);
    star_weight+=star_at(p,vec2(49.207,65.451),1.74944);
    star_weight+=star_at(p,vec2(876.650,75.000),3.49887);
    star_weight+=star_at(p,vec2(1572.000,75.000),5.24831);
    star_weight+=star_at(p,vec2(1142.431,91.914),0.68992);
    star_weight+=star_at(p,vec2(1014.423,145.090),2.43935);
    star_weight+=star_at(p,vec2(825.500,156.500),4.18879);
    star_weight+=star_at(p,vec2(953.071,214.929),5.93823);
    star_weight+=star_at(p,vec2(1116.500,271.000),1.37984);
    star_weight+=star_at(p,vec2(989.500,293.000),3.12927);
    if(p.y<440.0) {
        // Affect the bright painted star pixels, retaining the surrounding sky.
        float painted_star=step(0.50,max(original.r,max(original.g,original.b)));
        vec3 sky_color=0.5*(texture(TEXTURE,(p+vec2(0.0,12.0))/size).rgb+texture(TEXTURE,(p-vec2(0.0,12.0))/size).rgb);
        result.rgb=mix(result.rgb,sky_color,clamp(-star_weight*painted_star,0.0,1.0));
    }
    COLOR=result;
}
