shader_type canvas_item;

uniform float width : hint_range(0, 100) = 1.0;

uniform sampler2D bg_tex;
uniform sampler2D fg_tex;

vec4 calculate_pixel(vec2 uv, vec2 texture_pixel_size, sampler2D main_tex) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if (xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(main_tex, xy).a == 0.0)
				return texture(fg_tex, uv);
		}
	}
	
	return texture(bg_tex, uv);
}


void fragment() {
	COLOR = calculate_pixel(UV, TEXTURE_PIXEL_SIZE, TEXTURE);
}