extends Node2D


var active := true


signal changing_scene


# -
func _ready() -> void:
	visible = true


# -
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("control"):
		active = not active
		
		for button in get_children():
			button.active = active


func handle_switch() -> void:
	emit_signal("changing_scene")


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
