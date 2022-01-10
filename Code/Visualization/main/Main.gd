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
	
	var new_topics: Array = FileHandler.resources["topics"].duplicate()
	
	assert(new_topics.size() != 0)
	
	count = new_topics.size()
	
	# create seamless loop
	new_topics.push_back(new_topics[0])
	
	var sound_topics := []
	
	# load all images
	var i := 0
	for topic in new_topics:
		var topic_name: String = topic["name"]
		
		# load sprites
		var cover_sprite := Sprite.new()
		cover_sprite.texture = FileHandler.load_texture(topic_name, "cover")
		covers.add_child(cover_sprite)
		cover_sprite.name = topic_name.capitalize()
		cover_sprite.position = Vector2(1200 * i, 0)
		cover_sprite.centered = false
		
		var content_sprite := Sprite.new()
		content_sprite.texture = FileHandler.load_texture(topic_name, "content")
		content.add_child(content_sprite)
		cover_sprite.name = topic_name.capitalize()
		content_sprite.position = Vector2(1200 * i, 0)
		content_sprite.centered = false
		
		if i != new_topics.size() - 1:
			var streams := FileHandler.load_streams(topic_name)
			sound_topics.push_back(streams)
		
		i += 1
	
	# initialize audio
	for square in $MainViewport/Viewport/Grid.get_children():
		square.get_node("Sounds").load_streams(sound_topics)
	pass


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
