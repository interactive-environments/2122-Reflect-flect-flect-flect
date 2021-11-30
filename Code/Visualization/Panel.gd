extends TextureRect


onready var start_position := rect_position
onready var start_size := rect_size

var active := false


# -
func _ready() -> void:
	rect_position = start_position + start_size / 2
	rect_scale = Vector2()


# -
func _process(_delta: float) -> void:
	var scale := rect_scale.x
	var target_scale := 1.0 if active else 0.0
	
	# animate scale
	scale = lerp(scale, target_scale, 0.15)
	
	# centre
	rect_position = lerp(start_position + start_size / 2, start_position, scale)
	rect_scale = Vector2(scale, scale)
