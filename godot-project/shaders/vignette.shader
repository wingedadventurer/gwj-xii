shader_type canvas_item;
render_mode unshaded;

uniform float amount : hint_range(0, 1);

float calculate_vignette(vec2 uv, float amt) {
	uv *=  1.0 - uv.yx;
    float v = uv.x*uv.y * 15.0;
    v = pow(v, amt);
    v = 1.0 - v;
	return v;
}

void fragment() {
	float vignette = calculate_vignette(UV, amount);
    COLOR = vec4(1.0, 1.0, 1.0, vignette);
}
