extends Panel


# -
func _ready() -> void:
	visible = false
	
	if not KinectHandler.opened:
		$KinectLabel.visible = true
		visible = true
		$KinectViewer.visible = true


# -
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("control"):
		visible = not visible
		$KinectViewer.visible = visible and KinectHandler.opened
		
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		if OS.window_fullscreen:
			OS.window_fullscreen = false
		else:
			get_tree().quit()
		
		get_tree().set_input_as_handled()
