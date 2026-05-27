shader_type canvas_item;

uniform sampler2D our_texture;
uniform sampler2D noise_texture;
uniform float time = 0;
const vec4 transparent = vec4(0, 0, 0, 0);

float intensity(vec4 colour) { return (colour.r + colour.b + colour.g) / 3.0; }

void fragment() {
	float noise = intensity(texture(noise_texture, UV));
	vec4 texture_colour = texture(our_texture, UV);
	vec4 out_colour;
	if (noise < time) {
		out_colour = transparent;
	}
	else {
		out_colour = texture_colour;
	}
	COLOR = out_colour;//texture(noise_texture, grid_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
