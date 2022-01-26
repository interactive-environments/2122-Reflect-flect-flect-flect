extends Node


var pitches := [
	-5,
	-3,
	-5,
	0,
	-1,
	-1,
	-5,
	-3,
	-5,
	2,
	0,
	0,
	-5,
	7,
	4,
	0,
	-1,
	-3,
	5,
	4,
	0,
	2,
	0,
	0
]

var timer := 29
var index := 0

func _process(_delta: float) -> void:
	timer += 1
	
	if timer == 30:
		timer = 0
		
		index = (index + 1) % pitches.size()
		
		$AudioStreamPlayer.pitch_scale = pow(1.05946, pitches[index])
