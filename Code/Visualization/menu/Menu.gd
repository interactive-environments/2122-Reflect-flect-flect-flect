extends Node2D


var active := true


# -
func _process(_delta: float) -> void:
	if active:
		if get_local_mouse_position().x > 400:
			active = false
	else:
		if get_local_mouse_position().x < 300:
			active = true
	
	for button in get_children():
		button.active = active


# -
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		if OS.window_fullscreen:
			OS.window_fullscreen = false
		else:
			get_tree().quit()
		
		get_tree().set_input_as_handled()
