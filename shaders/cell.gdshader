shader_type canvas_item;


uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 nucleus_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 inner_nucleus_color: source_color = vec3(1.0, 1.0, 1.0);
uniform float nucleus_size = 0.25;
uniform float inner_nucleus_size = 0.1;
uniform float amplitude = 0.05;
uniform float frequency = 4.0;
uniform float speed = 2.0;
uniform float direction = 1;
const float edge_smoothing = 0.2;
uniform float seed = 0.0;

vec2 hash22(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)),
              dot(uv, vec2(269.5, 183.3)));
    return 2.0 * fract(sin(uv) * 43758.5453123) - 1.0;
}

// returns a value between 0 and 1
float noise(vec2 uv) {
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    vec2 blur = smoothstep(0.0, 1.0, fuv);
    return mix(mix(dot(hash22(iuv + vec2(0.0, 0.0)), fuv - vec2(0.0, 0.0)),
                   dot(hash22(iuv + vec2(1.0, 0.0)), fuv - vec2(1.0, 0.0)), blur.x),
               mix(dot(hash22(iuv + vec2(0.0, 1.0)), fuv - vec2(0.0, 1.0)),
                   dot(hash22(iuv + vec2(1.0, 1.0)), fuv - vec2(1.0, 1.0)), blur.x), blur.y) + 0.5;
}

void fragment() {
	float size = 0.5 - amplitude;
	
	float a = atan(UV.y - 0.5, UV.x - 0.5);
	float d = distance(UV, vec2(0.5, 0.5));
	float n = noise(seed + frequency*vec2(a, d) + TIME*vec2(direction*speed, speed));
	if (a < -PI + edge_smoothing || a > PI - edge_smoothing) {
		n = mix(0.5, n, (PI - abs(a))/edge_smoothing);
	}
	float cell_d = clamp(d + (2.0*n - 1.0)*amplitude, 0.0, 1.0);
	float nucleus_d = clamp(d + (2.0*n - 1.0)*amplitude*2.0*nucleus_size, 0.0, 1.0);
	float inner_nucleus_d = clamp(d + (2.0*n - 1.0)*amplitude*2.0*inner_nucleus_size, 0.0, 1.0);
	if (inner_nucleus_d < inner_nucleus_size) {
		COLOR = vec4(inner_nucleus_color, 1.0);
	} else if (nucleus_d < nucleus_size) {
		COLOR = vec4(nucleus_color, 1.0);
	} else if (cell_d < size) {
		COLOR = vec4(color, 1.0);
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}