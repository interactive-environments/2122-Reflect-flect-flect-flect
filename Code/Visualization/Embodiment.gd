extends Node2D


var left_pressed: bool
var right_pressed: bool

onready var left_animation: AnimationPlayer = $LeftAnimation
onready var right_animation: AnimationPlayer = $RightAnimation

var left_time := 0.0
var right_time := 0.0


func _ready() -> void:
	left_animation.play("LeftAnimation")
	left_animation.stop(false)
	
	right_animation.play("RightAnimation")
	right_animation.stop(true)



func _process(delta: float) -> void:
	if left_pressed or left_time > 2:
		left_time += delta
	else:
		if left_time > 2:
			left_time = 0
		
		left_time /= 1.1
	
	if right_pressed or right_time > 2:
		right_time += delta
	else:
		if right_time > 2:
			right_time = 0
		
		right_time /= 1.1
	
	if left_time > 4:
		left_time = 0
	
	if right_time > 4:
		right_time = 0
	
	left_animation.seek(left_time, true)
	right_animation.seek(right_time, true)
