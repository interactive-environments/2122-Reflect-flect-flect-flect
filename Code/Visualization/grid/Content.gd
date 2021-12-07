extends Node2D


var index := 0
var count := 3


func _process(_delta: float) -> void:
	position.x = lerp(position.x, -1200 * index, 0.01)
	
	var width := 1200 * count
	
	if position.x < -width:
		position.x += width
		index -= count
	
	if position.x > width:
		position.x -= width
		index += count
