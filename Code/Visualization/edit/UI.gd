extends Panel


# -
func _ready() -> void:
	for topic in FileHandler.resources["topics"]:
		add_topic(topic["name"])


func add_topic(topic_name: String) -> void:
	var element: Control = preload("res://edit/EditElement.tscn").instance()
	
	$ScrollContainer/VBoxContainer.add_child(element)
	
	element.load_from_file(topic_name)
	
	element.cover_button.connect("pressed", $ImageInfo, "_on_Button_pressed", [element.cover_button])
	element.content_button.connect("pressed", $ImageInfo, "_on_Button_pressed", [element.content_button])


func _on_Menu_changing_scene() -> void:
	for element in $ScrollContainer/VBoxContainer.get_children():
		element.save_to_file()


func _on_NewButton_pressed() -> void:
	var new_topic := FileHandler.create_topic()
	
	add_topic(new_topic)
