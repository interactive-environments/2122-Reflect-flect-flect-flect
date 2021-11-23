extends Node2D


func _ready() -> void:
	_set_animation_factor(1.0)


func _set_animation_factor(animation_factor: float) -> void:
	$Level1.animation_factor = clamp(animation_factor - 0, 0, 3)
	$Level2.animation_factor = clamp(animation_factor - 1, 0, 3)
	$Level3.animation_factor = clamp(animation_factor - 2, 0, 3)
	$Level4.animation_factor = clamp(animation_factor - 3, 0, 3)
	$Level5.animation_factor = clamp(animation_factor - 4, 0, 3)


func _on_HSlider_value_changed(value: float) -> void:
	_set_animation_factor(value)

