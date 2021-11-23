extends Node2D


var animation_factor := 0.0 setget _set_animation_factor
func _set_animation_factor(new_animation_factor: float) -> void:
	animation_factor = new_animation_factor
	
	for child in get_children():
		var panel := child as InteractivePanel
		panel.animation_factor = animation_factor


func _assert_panels() -> void:
	var positions := PoolVector2Array([])
	
	for child in get_children():
		var panel := child as InteractivePanel
		var _panel_name := panel.name
		
		assert(int(panel.rect_position.x) % 60 == 0)
		assert(int(panel.rect_position.y) % 60 == 0)
		
		assert((int(panel.rect_size.x) - 54) % 60 == 0)
		assert((int(panel.rect_size.y) - 54) % 60 == 0)
		
		for pos in positions:
			assert(not (pos as Vector2).is_equal_approx(panel.rect_position))
		
		positions.push_back(panel.rect_position)
	
	print("Panel checks succeeded!")

