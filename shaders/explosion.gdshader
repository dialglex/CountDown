shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0, 0.01);
const float outer_circle_start = 0.0;
const float inner_circle_start = 0.67;
uniform vec4 color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_2 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

bool is_in_circle(vec2 position, float radius) {
	return distance(position, vec2(0.5, 0.5)) < radius;
}

void fragment() {
	float on = 0.0;
	float outer_circle_radius = max(0.0, (progress - outer_circle_start)/(1.0 - outer_circle_start))*0.5;
	float middle_circle_radius = max(0.0, (progress - mix(outer_circle_start, inner_circle_start, progress))/(1.0 - mix(outer_circle_start, inner_circle_start, progress)))*0.5;
	float inner_circle_radius = max(0.0, (progress - inner_circle_start)/(1.0 - inner_circle_start))*0.5;
	bool in_outer_circle = is_in_circle(UV, outer_circle_radius);
	bool in_middle_circle = is_in_circle(UV, middle_circle_radius);
	bool in_inner_circle = is_in_circle(UV, inner_circle_radius);
	if (in_inner_circle) {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	} else if (in_middle_circle) {
		COLOR = color_1;
	} else if (in_outer_circle) {
		COLOR = color_2;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}
