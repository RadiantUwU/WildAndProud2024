shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;
uniform sampler2D u_palette : filter_nearest;

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

void fragment() {
	COLOR = texture(screen,SCREEN_UV);
	closest(COLOR.xyz);
}
