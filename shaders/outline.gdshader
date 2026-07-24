shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

const float thickness = 8.0;
const float min_thickness = 2.0;
uniform bool on = false;
uniform float scale = 1.0;
uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);
uniform float circle_iterations = 16.0;
uniform float line_iterations = 1.0;

void fragment() {
	vec4 sprite_color = texture(screen_texture, SCREEN_UV);
	if (!on || sprite_color.a == 1.0) {
		COLOR = sprite_color;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
		bool break_pls = false;
		vec2 max_line_length = SCREEN_PIXEL_SIZE*max(thickness*scale, min_thickness);
		vec2 line_increment = max_line_length/line_iterations;
		float angle_increment = TAU/circle_iterations;
		for (vec2 line_length = line_increment; line_length.x <= max_line_length.x; line_length += line_increment) {
			for (float angle = 0.0; angle < TAU; angle += angle_increment) {
				vec4 nearest_color = texture(screen_texture, SCREEN_UV + vec2(sin(angle), cos(angle))*line_length);
				if (nearest_color.a == 1.0) {
					COLOR = vec4(color, 1.0);
					break_pls = true;
					break;
				}
			}
			if (break_pls) {
				break;
			}
		}
	}
}