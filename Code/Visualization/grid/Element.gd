extends TextureRect


onready var start_position := rect_position
onready var start_size := rect_size

var timer := 0


# -
func _ready() -> void:
	rect_position = start_position + start_size / 2
	rect_scale = Vector2()


# -
func _process(_delta: float) -> void:
	# get the pixel at the element's position
	var pos: Vector2 = (rect_position + get_parent().position) * 0.5
	var pixel: int = KinectHandler.get_pixel(max(int(pos.x), 0), max(int(pos.y), 0))
	
	#var mouse_pos := Vector2(get_global_mouse_position().x, 900 + get_global_mouse_position().y)
	#var pixel := 2 if Rect2(start_position, start_size).has_point(mouse_pos) else 0
	
	var scale := rect_scale.x
	var target_scale := 1.0
	
	if pixel >= 2:
		timer = 20
	else:
		timer -= 1
		
		if timer <= 0:
			timer = 0
			target_scale = 0.0
	
	# animate scale
	scale = lerp(scale, target_scale, 0.15)
	
	# centre
	rect_position = lerp(start_position + start_size / 2, start_position, scale)
	rect_scale = Vector2(scale, scale)
