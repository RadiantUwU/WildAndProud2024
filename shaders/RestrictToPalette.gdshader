shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, filter_nearest;
uniform sampler2D u_palette : filter_nearest;
uniform sampler2D u_dither : repeat_enable,filter_nearest;
uniform bool dither = true;
uniform float dither_scale : hint_range(0,999) = 1;

void closest(inout vec3 source_col) {
    vec3 currently_closest = source_col;
    float last_dist = 9e36f;// HUGE_VAL
    ivec2 size = textureSize(u_palette,0);
    for (int x = 0; x < size.x; x++) {
        for (int y = 0; y < size.y; y++) {
            vec3 sampled = texelFetch(u_palette,ivec2(x,y),0).xyz;
            float curr_dist = distance(sampled,source_col);
            if (curr_dist < last_dist) {
                currently_closest = sampled;
                last_dist = curr_dist;
            }
        }
    }
    source_col = currently_closest;
}
void closest2(inout vec3 source_col, in float aspect_ratio, in vec2 uv) {
	vec3 c1=source_col,c2;
	float ld1,ld2;
	bool found_2nd = false;
    ld1 = 9e36f;ld2 = 9e36f;// HUGE_VAL
    ivec2 size = textureSize(u_palette,0);
    for (int x = 0; x < size.x; x++) {
        for (int y = 0; y < size.y; y++) {
            vec3 sampled = texelFetch(u_palette,ivec2(x,y),0).xyz;
            float curr_dist = distance(sampled,source_col);
            if (curr_dist < ld1) {
				c2 = c1;
				ld2 = ld1;
                c1 = sampled;
                ld1 = curr_dist;
				found_2nd = ld2 != 9e36f;
            } else if (curr_dist < ld2) {
				c2 = sampled;
				ld2 = curr_dist;
			}
        }
    }
	if (!found_2nd || ld1 < 0.01) {
    	source_col = c1;
	} else {
		float vd = distance(c1,c2);
		float vz = ld1-ld2+vd;
		
		float to_dither = vz;
		to_dither += texture(u_dither, uv*dither_scale*vec2(aspect_ratio,1)).r;
		if (to_dither > .5)
			source_col = c2;
		else
			source_col = c1;
	}
}

void fragment() {
	COLOR = texture(screen,SCREEN_UV);
	if (dither) {
		vec2 res = 1.0/SCREEN_PIXEL_SIZE;
		float aspect_ratio = res.x/res.y;
		closest2(COLOR.xyz,aspect_ratio, SCREEN_UV);
	} else {
		closest(COLOR.xyz);
	}
}
