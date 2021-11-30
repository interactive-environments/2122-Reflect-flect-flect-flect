extends Node2D


var active := false
var active_index := 0

var blur_amount := 10.0


# -
func _process(_delta: float) -> void:
	var new_blur_amount = lerp(blur_amount, 0.0 if active else 4.0, 0.1)
	
	if blur_amount != new_blur_amount:
		blur_amount = new_blur_amount
		
		#var material: ShaderMaterial = $"../../../ViewportContainer".material
		#material.set_shader_param("blur_amount", blur_amount)
	
	$"../Grid".modulate.a = lerp($"../Grid".modulate.a, 0.0 if active else 1.0, 0.1)


# -
func _unhandled_input(event: InputEvent) -> void:
	var handled := false
	
	if event.is_action_pressed("ui_accept"):
		active = not active
		
		_activate(active_index if active else -1)
		handled = true
	
	if active:
		if event.is_action_pressed("ui_left"):
			active_index = posmod(active_index - 1, 4)
			_activate(active_index)
			handled = true
		elif event.is_action_pressed("ui_right"):
			active_index = posmod(active_index + 1, 4)
			_activate(active_index)
			handled = true
	
	if handled:
		get_tree().set_input_as_handled()


# activates the specified panel
func _activate(index: int) -> void:
	for child in get_children():
		child.active = false
	
	if index == -1:
		return
	
	get_child(index).active = true
