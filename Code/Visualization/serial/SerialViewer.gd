extends Panel


# -
func _process(_delta: float) -> void:
	_handle_mouse_color()
	
	if visible:

		modulate = SerialHandler.LightColor


# puts the mouse color into serial
func _handle_mouse_color() -> void:
	# get screen texture
	var image := get_viewport().get_texture().get_data()
	image.flip_y()
	
	# get pixel color
	image.lock()
	var color := image.get_pixelv(get_global_mouse_position())
	image.unlock()
	
	SerialHandler.LightColor = color
