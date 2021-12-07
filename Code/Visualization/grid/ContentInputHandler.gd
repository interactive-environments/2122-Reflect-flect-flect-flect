extends Node


onready var content: Node2D = $"../ContentViewport/Content"


func _unhandled_input(event: InputEvent) -> void:
	var h := int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left"))
	
	if h != 0:
		content.index += h
		
		get_tree().set_input_as_handled()
