extends "res://main/Main.gd"


# (EXTENSION) loads topics
func _load_topics() -> void:
	count = 1
	
	var party_sounds: PackedScene = preload("res://party/PartySounds.tscn")
	
	# initialize audio
	for square in $MainViewport/Viewport/Grid.get_children():
		square.get_node("Sounds").add_child(party_sounds.instance())
