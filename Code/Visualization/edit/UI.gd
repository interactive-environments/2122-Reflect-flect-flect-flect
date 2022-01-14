extends Panel


# -
func _ready() -> void:
	# add topics to list
	for topic in FileHandler.resources["topics"]:
		add_topic(topic["name"])


# add a new topic to the list
func add_topic(topic_name: String) -> void:
	# create element, add as child
	var element: Control = preload("res://edit/EditElement.tscn").instance()
	$ScrollContainer/VBoxContainer.add_child(element)
	
	# load
	element.load_from_file(topic_name)
	
	# connect button signals
	element.cover_button.connect("pressed", $ImageInfo, "_on_Button_pressed", [element.cover_button])
	element.content_button.connect("pressed", $ImageInfo, "_on_Button_pressed", [element.content_button])


# save all topics to file @ Menu changing_scene
func _on_Menu_changing_scene() -> void:
	for element in $ScrollContainer/VBoxContainer.get_children():
		element.save_to_file()


# add new topic @ NewButton pressed
func _on_NewButton_pressed() -> void:
	# create new topic, get topic name
	var new_topic := FileHandler.create_topic()
	
	# add
	add_topic(new_topic)
