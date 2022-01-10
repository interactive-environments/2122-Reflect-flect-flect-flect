extends Node


var rng := RandomNumberGenerator.new()


# -
func _ready() -> void:
	rng.randomize()
	
	call_deferred("_initialize_panning")


# initializes the sounds
func load_streams(topics: Array) -> void:
	for child in get_children():
		child.queue_free()
	
	for streams in topics:
		var sound := Node.new()
		
		for stream in streams:
			var stream_player := AudioStreamPlayer.new()
			stream_player.volume_db = -25
			
			stream_player.stream = stream
			
			sound.add_child(stream_player)
		
		add_child(sound)


func get_current_notes() -> Array:
	var main := get_tree().current_scene
	var index = posmod(main.index, main.count)
	
	return get_child(index).get_children()


# initializes panning based on horizontal location
func _initialize_panning() -> void:
	# set panning
	var centre_x: float = (get_parent().start_position + get_parent().start_size / 2).x
	var bus: String = ["LL", "L", "M", "R", "RR"][int(centre_x / 240)]
	
	for note in get_current_notes():
		(note as AudioStreamPlayer).bus = bus


# plays a random note
func play() -> void:
	# get child notes that aren't playing yet
	var not_playing_notes := []
	for note in get_current_notes():
		if not (note as AudioStreamPlayer).playing:
			not_playing_notes.push_back(note)
	
	if not_playing_notes == []:
		return
	
	# pick a random one and play it
	var random_index := rng.randi_range(0, not_playing_notes.size() - 1)
	(not_playing_notes[random_index] as AudioStreamPlayer).play()
