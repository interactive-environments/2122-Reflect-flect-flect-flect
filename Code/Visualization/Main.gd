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
	# get left and right pressed
	var left_pressed = (KinectHandler.get_pixel(10, 0) == 2)
	var right_pressed = (KinectHandler.get_pixel(630, 0) == 2)
	if left_pressed and right_pressed:
		left_pressed = false
		right_pressed = false
	
	# change offset and index based on input
	if left_pressed:
		left_timer += delta
		offset += 5
		
		if left_timer > 2:
			index += 1
			calc_pitch += 1
			left_timer = 0.0
	else:
		left_timer = 0
	
	if right_pressed:
		right_timer += delta
		offset -= 5
		
		if right_timer > 2:
			index -= 1
			calc_pitch -= 1
			right_timer = 0
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
