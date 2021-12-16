extends Node2D


export var topics: PoolStringArray

var index := 0
var count: int

var offset := 0.0

var left_timer := 0.0
var right_timer := 0.0

var pos := Vector2()

var calc_pitch := 0
var pitch := 0.0

onready var phaser_effect: AudioEffectPhaser = AudioServer.get_bus_effect(0, 2)
onready var lowpass_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(0, 4)


# -
func _ready() -> void:
	var covers := $Cover/Images
	var content := $Content/Images
	
	assert(topics.size() != 0)
	
	count = topics.size()
	
	topics.push_back(topics[0])
	
	for i in range(topics.size()):
		var topic: String = topics[i].to_lower()
		
		var cover_sprite := Sprite.new()
		cover_sprite.texture = load("images/" + topic + "/cover.png")
		covers.add_child(cover_sprite)
		cover_sprite.name = topic.capitalize()
		cover_sprite.position = Vector2(1200 * i, 0)
		cover_sprite.centered = false
		
		var content_sprite := Sprite.new()
		content_sprite.texture = load("images/" + topic + "/content.png")
		content.add_child(content_sprite)
		cover_sprite.name = topic.capitalize()
		content_sprite.position = Vector2(1200 * i, 0)
		content_sprite.centered = false
	
	topics.resize(topics.size() - 1)


# -
func _process(delta: float) -> void:
	# handle sound effects
	phaser_effect.depth = 0.5 + 0.5 * sin(float(OS.get_ticks_msec()) / 3000.0)
	lowpass_effect.cutoff_hz = 1500 + 500 * sin(float(OS.get_ticks_msec()) / 4000.0)
	
	# get left and right pressed
	var left_pressed := Input.is_action_pressed("ui_left")
	var right_pressed := Input.is_action_pressed("ui_right")
	
	if left_pressed and right_pressed:
		left_pressed = false
		right_pressed = false
	
	# set embodiment activity
	$Embodiment.left_pressed = left_pressed
	$Embodiment.right_pressed = right_pressed
	
	# change offset and index based on input
	if left_pressed:
		left_timer += delta
		offset -= 5
		
		if left_timer > 2:
			index -= 1
			calc_pitch += 1
			left_timer = 0.0
			reset_squares()
	else:
		left_timer = 0
	
	if right_pressed:
		right_timer += delta
		offset += 5
		
		if right_timer > 2:
			index += 1
			calc_pitch -= 1
			right_timer = 0.0
			reset_squares()
	else:
		right_timer = 0
	
	pos.x = lerp(pos.x, -1200 * index - offset, 0.05)
	
	# handle looping
	var width := 1200 * count
	
	if pos.x < -width:
		pos.x += width
		index -= count
	
	if pos.x > 0:
		pos.x -= width
		index += count
	
	offset /= 1.03
	
	# calculate pitch
	calc_pitch = posmod(calc_pitch, 3)
	pitch = lerp(pitch, calc_pitch, 0.05)


func reset_squares() -> void:
	for square in $MainViewport/Viewport/Grid.get_children():
		square.reset()