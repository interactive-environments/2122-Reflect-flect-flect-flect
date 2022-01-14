extends Camera2D


var target_y := 550.0


# -
func _process(_delta: float) -> void:
	# interpolate to position
	position.y = lerp(position.y, target_y, 0.07)


# moves the camera to the top
func move_up() -> void:
	target_y = 550


# moves the camera to the bottom
func move_down() -> void:
	target_y = 550 + 1100
