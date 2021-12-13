extends TextureRect


onready var start_position := rect_position
onready var start_size := rect_size

var timer := 0

var sounds: Node
var prev_target_scale: float


# -
func _ready() -> void:
	rect_position = start_position + start_size / 2
	rect_scale = Vector2()


# -
func _process(_delta: float) -> void:
	# get the pixel at the element's position
	var pos: Vector2 = (start_position + get_parent().position) * (480.0 / 1000)
	var pixel: int = KinectHandler.get_pixel(max(int(pos.x + 50), 0), max(int(pos.y), 0))
	
	var scale := rect_scale.x
	var target_scale := 1.0
	
	if pixel >= 1:
		timer = 20
	else:
		timer -= 1
		
		if timer <= 0:
			timer = 0
			target_scale = 0.0
	
	if not is_equal_approx(prev_target_scale, target_scale):
		$Sounds.play()
		prev_target_scale = target_scale
	
	# animate scale
	scale = lerp(scale, target_scale, 0.15)
	
	# centre
	rect_position = lerp(start_position + start_size / 2, start_position, scale)
	rect_scale = Vector2(scale, scale)
