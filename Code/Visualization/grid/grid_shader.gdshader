shader_type canvas_item;

uniform float width : hint_range(0, 100) = 1.0;

uniform sampler2D cover_texture;
uniform sampler2D content_texture;

vec4 calculate_pixel(vec2 uv, vec2 texture_pixel_size, sampler2D main_texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if (xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(main_texture, xy).a == 0.0)
				return texture(cover_texture, uv);
		}
	}
	
	return texture(content_texture, uv);
}


void fragment() {
	COLOR = calculate_pixel(UV, TEXTURE_PIXEL_SIZE, TEXTURE);
}