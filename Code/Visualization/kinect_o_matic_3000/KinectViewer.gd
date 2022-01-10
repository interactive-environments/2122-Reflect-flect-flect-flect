extends Node2D


# -
func _process(_delta: float) -> void:
	if visible:
		update()


# -
func _draw() -> void:
	if not visible:
		return
	
	var colors := [
		Color(0.0, 0.0, 0.0),
		Color(0.5, 0.5, 0.5),
		Color(1.0, 1.0, 1.0)
	]
	
	for y in range(KinectHandler.height):
		for x in range(KinectHandler.width):
			var pixel: int = KinectHandler.get_pixel(x, y)
			
			if pixel != 0:
				draw_rect(Rect2(x, y, 1, 1), colors[pixel])


# toggle draw @ CheckBox toggled
func _on_CheckBox_toggled(button_pressed: bool) -> void:
	visible = button_pressed
