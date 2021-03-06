extends VBoxContainer


var topic: String


# initializes the images
func initialize(new_topic: String) -> void:
	topic = new_topic
	
	# go through images folder of topic
	var folder_path := FileHandler.folder_from_topic_name(topic) + "images/"
	
	var directory := Directory.new()
	directory.open(folder_path)
	directory.list_dir_begin()
	
	while true:
		var next := directory.get_next()
		if next == "":
			break
		
		if not next.begins_with("."):
			# add image
			add_image(folder_path + next)
	
	directory.list_dir_end()


# clears all children
func clear():
	for child in get_children():
		if child is TextureButton:
			child.queue_free()


# adds the image with the specified path
func add_image(path: String) -> void:
	var rect := preload("res://edit/image_editor/ImagePickerButton.gd").new()
	add_child(rect)
	
	rect.initialize(path)


# adds the selected images @ FileDialog files_selected
func _on_FileDialog_files_selected(paths: PoolStringArray) -> void:
	var directory := Directory.new()
	
	# go through all selected files
	for _path in paths:
		var path := _path as String
		
		var new_path := FileHandler.folder_from_topic_name(topic) + "images/" + path.get_file()
		
		directory.copy(path, new_path)
		
		add_image(new_path)
