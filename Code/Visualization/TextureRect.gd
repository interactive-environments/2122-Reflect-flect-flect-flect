extends TextureRect


onready var panel: Panel = get_parent().get_parent()


func _process(_delta: float) -> void:
	rect_size = panel.rect_size
