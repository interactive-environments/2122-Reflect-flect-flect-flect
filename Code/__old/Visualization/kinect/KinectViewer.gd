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
	
	var s := 4
	
	for y in range(0, KinectHandler.height * KinectHandler.square_size, s):
		for x in range(0, KinectHandler.width * KinectHandler.square_size, s):
			draw_rect(Rect2(x, y, s, s), colors[KinectHandler.get_pixel(x, y)])


# toggle draw @ CheckBox toggled
func _on_CheckBox_toggled(button_pressed: bool) -> void:
	visible = button_pressed
