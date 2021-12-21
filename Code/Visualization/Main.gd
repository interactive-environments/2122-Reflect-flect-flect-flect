extends Node2D


var index := 0
var count: int

var offset := 0.0

var pos := Vector2()

var calc_pitch := 0
var pitch := 0.0


onready var phaser_effect: AudioEffectPhaser = AudioServer.get_bus_effect(0, 2)
onready var lowpass_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(0, 4)


# -
func _ready() -> void:
	var covers := $Cover/Images
	var content := $Content/Images
	
	# get topics from user files
	var topics := []
	var dir := Directory.new()
	dir.open("user://images")
	dir.list_dir_begin()

	while true:
		var next := dir.get_next()
		if next == "":
			break
		
		if not next.begins_with("."):
			topics.push_back(next)
	
	dir.list_dir_end()
	
	assert(topics.size() != 0)
	
	count = topics.size()
	
	# create seamless loop
	topics.push_back(topics[0])
	
	for i in range(topics.size()):
		var topic: String = topics[i].to_lower()
		
		var cover_sprite := _sprite_from_path("user://images/" + topic + "/cover.png")
		covers.add_child(cover_sprite)
		cover_sprite.name = topic.capitalize()
		cover_sprite.position = Vector2(1200 * i, 0)
		cover_sprite.centered = false
		
		var content_sprite := _sprite_from_path("user://images/" + topic + "/content.png")
		content.add_child(content_sprite)
		cover_sprite.name = topic.capitalize()
		content_sprite.position = Vector2(1200 * i, 0)
		content_sprite.centered = false
	
	topics.resize(topics.size() - 1)


# -
func _process(_delta: float) -> void:
	# handle sound effects
	phaser_effect.depth = 0.5 + 0.5 * sin(float(OS.get_ticks_msec()) / 3000.0)
	lowpass_effect.cutoff_hz = 1500 + 500 * sin(float(OS.get_ticks_msec()) / 4000.0)
	
	# change offset and index based on input
	if $Embodiment.left_pressed:
		offset -= 5
	
	if $Embodiment.right_pressed:
		offset += 5
	
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


# moves stuff left
func go_left() -> void:
	index -= 1
	calc_pitch += 1
	reset_squares()


# moves stuff right
func go_right() -> void:
	index += 1
	calc_pitch -= 1
	reset_squares()


# resets all squares
func reset_squares() -> void:
	for square in $MainViewport/Viewport/Grid.get_children():
		square.reset()


# creates a sprite from an image path
func _sprite_from_path(path: String) -> Sprite:
	var image := Image.new()
	image.load(path)
	
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	
	var sprite := Sprite.new()
	sprite.texture = texture
	
	return sprite
