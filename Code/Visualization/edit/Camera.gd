extends Camera2D


var target_y := 550.0


func _process(_delta: float) -> void:
	position.y = lerp(position.y, target_y, 0.07)


func move_up() -> void:
	target_y = 550


func move_down() -> void:
	target_y = 550 + 1100
