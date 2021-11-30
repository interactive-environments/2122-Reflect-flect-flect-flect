shader_type canvas_item;

uniform bool blur = false;

uniform float bg_effect_amount : hint_range(0, 10) = 0;

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
	
	int i_bg_effect_amount = int(bg_effect_amount);
	
	if (bg_effect_amount > 0.125) {
		if (blur) {
			bg_color = vec4(0, 0, 0, 0);
			
			// sum the pixels colors
			for(int x=-i_bg_effect_amount; x <= i_bg_effect_amount; x++) {
				for(int y = -i_bg_effect_amount; y <= i_bg_effect_amount; y++) {
					
					// get the pixel coordinates at offset (x, y)
					vec2 coordinate = UV + vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE;
					
					// sum the color
					bg_color += texture(bg_tex, coordinate);
				}
			}
			
			// divide the color by the number of colors you sumed up
			int num_neighbours = (i_bg_effect_amount * 2 + 1) * (i_bg_effect_amount * 2 + 1);
			bg_color /= float(num_neighbours);
		}
		else {
			vec2 pixel_uv = (floor((UV / bg_effect_amount) / TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE) * bg_effect_amount;
			bg_color = texture(bg_tex, pixel_uv);
		}
		
		// darken the background
		bg_color /= 1.0 + (0.125 * bg_effect_amount);
		bg_color.a = 1.0;
	}
	
	for (int i = 0; i <= shadow_amount; i++) {
		vec2 vec = UV - vec2(float(i), float(i)) * TEXTURE_PIXEL_SIZE;
		
		if (vec.x < 0.0 || vec.x > 1.0 || vec.y < 0.0 || vec.y > 1.0 || texture(TEXTURE, vec).a < 0.5) {
			bg_color /= 1.05;
			bg_color.a = 1.0;
		}
	}
	
	//COLOR = active ? fg_color : bg_color;
	COLOR = mix(bg_color, fg_color, a);
}