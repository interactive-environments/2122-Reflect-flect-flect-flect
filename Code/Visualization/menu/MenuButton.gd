extends TextureButton


export(String, FILE, "*.tscn") var scene: String


onready var start_position := rect_position
onready var start_size := rect_size

var active := true


# -
func _process(_delta: float) -> void:
	# animate scale
	var new_scale = lerp(rect_scale.x, float(active), 0.15)
	
	# centre
	rect_position = lerp(start_position + start_size / 2, start_position, new_scale)
	rect_scale = new_scale * Vector2.ONE


# -
func _pressed() -> void:
	get_parent().handle_switch()
	
	get_tree().change_scene(scene)
