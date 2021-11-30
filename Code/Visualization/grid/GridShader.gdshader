shader_type canvas_item;

uniform float blur_amount : hint_range(0, 10) = 0;

uniform int shadow_amount : hint_range(0, 10) = 15;

uniform float width : hint_range(0, 100) = 1.0;

uniform sampler2D bg_tex;
uniform sampler2D fg_tex;

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if (xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a == 0.0) {
				return true;
			}
		}
	}
	
	return false;
}


void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	//bool active = (COLOR.a < 0.5);
	//active = active || hasContraryNeighbour(UV, TEXTURE_PIXEL_SIZE, TEXTURE);
	
	float a = 1.0 - COLOR.a;
	a = max(a, hasContraryNeighbour(UV, TEXTURE_PIXEL_SIZE, TEXTURE) ? 1.0 : 0.0);
	
	vec4 fg_color = texture(fg_tex, UV);
	vec4 bg_color = texture(bg_tex, UV);
	
	int iblur_amount = int(blur_amount);
	
	if (iblur_amount != 0) {
		bg_color = vec4(0, 0, 0, 0);
		
		// sum the pixels colors
		for(int x=-iblur_amount; x <= iblur_amount; x++) {
			for(int y = -iblur_amount; y <= iblur_amount; y++) {
				
				// get the pixel coordinates at offset (x, y)
				vec2 coordinate = UV + vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE;
				
				// sum the color
				bg_color += texture(bg_tex, coordinate);
			}
		}

		// divide the color by the number of colors you sumed up
		int num_neighbours = (iblur_amount * 2 + 1) * (iblur_amount * 2 + 1);
		bg_color /= float(num_neighbours);
	}
	
	for (int i = 0; i <= shadow_amount; i++) {
		vec2 vec = UV - vec2(float(i), float(i)) * TEXTURE_PIXEL_SIZE;
		
		if (vec.x < 0.0 || vec.x > 1.0 || vec.y < 0.0 || vec.y > 1.0 || texture(TEXTURE, vec).a < 0.5) {
			bg_color /= 1.05;
			bg_color.a = 1.0;
		}
	}
	
	bg_color /= 1.0 + (0.125 * blur_amount);
	bg_color.a = 1.0;
	
	//COLOR = active ? fg_color : bg_color;
	COLOR = mix(bg_color, fg_color, a);
}