extends FileDialog


onready var start_position := rect_position


func _on_Button_pressed() -> void:
	popup()
	rect_position.y += 1200
