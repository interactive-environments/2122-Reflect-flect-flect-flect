extends Node


export(String, "Synth", "Glass", "Drum", "String") var instrument := "Synth"
var rng := RandomNumberGenerator.new()

onready var content_handler := get_tree().current_scene.get_node("ContentHandler")

export var change_pitch := true
export var starting_frequency := 1.0

var pitch := -1.0


# -
func _ready() -> void:
	rng.randomize()
	
	# set panning
	var centre_x: float = (get_parent().start_position + get_parent().start_size / 2).x
	var bus: String = ["LL", "L", "M", "R", "RR"][int(centre_x / 240)]
	
	for instr in get_children():
		for note in instr.get_children():
			(note as AudioStreamPlayer).bus = bus


# returns the notes of the current instrument
func get_notes() -> Array:
	return get_node(instrument).get_children()


func _process(_delta: float) -> void:
	if not change_pitch:
		return
	
	var new_pitch: float = content_handler.pitch
	
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
