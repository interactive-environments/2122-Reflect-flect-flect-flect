extends Node2D


onready var content_handler := get_tree().current_scene.get_node("ContentHandler")


# -
func _process(_delta: float) -> void:
	position = content_handler.pos
