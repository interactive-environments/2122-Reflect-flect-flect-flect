extends Node2D


var left_pressed: bool
var right_pressed: bool

onready var left_animation: AnimationPlayer = $LeftAnimation
onready var right_animation: AnimationPlayer = $RightAnimation

var left_time := 0.0
var right_time := 0.0

var left_prev_switch := false
var right_prev_switch := false


# -
func _ready() -> void:
	left_animation.play("LeftAnimation")
	left_animation.stop(false)
	
	right_animation.play("RightAnimation")
	right_animation.stop(true)


# -
func _process(delta: float) -> void:
	# get left and right pressed
	left_pressed = (KinectHandler.get_pixel(0, 0) == 2)
	right_pressed = (KinectHandler.get_pixel(52, 0) == 2)
	
	if left_pressed and right_pressed:
		left_pressed = false
		right_pressed = false
	
	# handle pressing left
	if left_pressed or left_time > 2:
		if left_time > 2 and not left_prev_switch:
			left_prev_switch = true
			get_tree().current_scene.go_left()
		
		left_time += delta
	else:
		left_prev_switch = false
		left_time /= 1.1
	
	# handle pressing right
	if right_pressed or right_time > 2:
		if right_time > 2 and not right_prev_switch:
			right_prev_switch = true
			get_tree().current_scene.go_right()
		
		right_time += delta
	else:
		right_prev_switch = false
		right_time /= 1.1
	
	if left_time > 4:
		left_time = 0
		left_prev_switch = false
	
	if right_time > 4:
		right_time = 0
		right_prev_switch = false
	
	left_animation.seek(left_time, true)
	right_animation.seek(right_time, true)
