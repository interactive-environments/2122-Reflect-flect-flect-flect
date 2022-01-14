extends FileDialog


onready var start_position := rect_position


# popup @ Button pressed
func _on_Button_pressed() -> void:
	popup()
	
	# position in centre of screen
	rect_position.x = 400
	rect_position.y = 1400
