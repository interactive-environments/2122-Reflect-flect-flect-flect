extends Node


var instruments := [
	"Synth",
	"Glass",
	#"Drum",
	"String"
]

var instrument := "Synth"
var rng := RandomNumberGenerator.new()

export var change_pitch := true
export var starting_frequency := 1.0

var change_instrument_timer := 0.0

var pitch := -1.0


# -
func _ready() -> void:
	rng.randomize()
	
	call_deferred("_initialize_panning")


# initializes panning based on horizontal location
func _initialize_panning() -> void:
	# set panning
	var centre_x: float = (get_parent().start_position + get_parent().start_size / 2).x
	var bus: String = ["LL", "L", "M", "R", "RR"][int(centre_x / 240)]
	
	for instr in get_children():
		for note in instr.get_children():
			(note as AudioStreamPlayer).bus = bus


# returns the notes of the current instrument
func get_notes() -> Array:
	return get_node(instrument).get_children()


# -
func _process(delta: float) -> void:
	# go to next instrument after 20 seconds
	change_instrument_timer += delta
	if change_instrument_timer > 20:
		var current_instrument_index := instruments.find(instrument)
		current_instrument_index = (current_instrument_index + 1) % instruments.size()
		
		instrument = instruments[current_instrument_index]
	
	if not change_pitch:
		return
	
	var new_pitch: float = get_tree().current_scene.pitch
	
	if not is_equal_approx(pitch, new_pitch):
		for note in get_notes():
			(note as AudioStreamPlayer).pitch_scale = starting_frequency * pow(1.05946, new_pitch)
	else:
		pitch = new_pitch


# plays a random note
func play() -> void:
	# get child notes that aren't playing yet
	var not_playing_notes := []
	for note in get_notes():
		if not (note as AudioStreamPlayer).playing:
			not_playing_notes.push_back(note)
	
	if not_playing_notes == []:
		return
	
	# pick a random one and play it
	var random_index := rng.randi_range(0, not_playing_notes.size() - 1)
	(not_playing_notes[random_index] as AudioStreamPlayer).play()
