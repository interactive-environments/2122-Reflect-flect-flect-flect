extends Node


var resources := {}

var templates := [
	{
		"image": preload("res://edit/templates/spr_template_0.png"),
		"template": preload("res://edit/templates/Template0.tscn"),
	},
	{
		"image": preload("res://edit/templates/spr_template_1.png"),
		"template": preload("res://edit/templates/Template1.tscn"),
	},
]


# creates a new topic
func create_topic() -> String:
	var directory := Directory.new()
	
	# create new, unique, directory
	var new_id := 0
	var new_folder := ""
	
	var valid := false
	while not valid:
		new_id = randi()
		new_folder = "user://images/" + str(new_id) + "/"
		
		valid = not directory.dir_exists(new_folder)
	
	directory.make_dir_recursive(new_folder + "images/")
	directory.make_dir_recursive(new_folder + "sounds/")
	directory.open(new_folder)
	
	var topic := str(new_id)
	
	resources["topics"].push_back(
		{
			"name": topic,
			"folder": new_folder
		}
	)
	
	# copy contents from default topic
	directory.copy("user://default_topic/re.flect", new_folder + "re.flect")
	directory.copy("user://default_topic/cover.png", new_folder + "cover.png")
	directory.copy("user://default_topic/content.png", new_folder + "content.png")
	
	return topic


# deletes the specified topic
func delete_topic(topic: String) -> void:
	# delete folder
	var folder := folder_from_topic_name(topic)
	
	remove_directory(folder)
	
	# remove from resources
	for t in resources["topics"]:
		if t["name"] == topic:
			resources["topics"].erase(t)


# loads texture from file
func load_texture(topic: String, type: String) -> Texture:
	var path := folder_from_topic_name(topic) + type + ".png"
	
	return load_texture_from_path(path)


func load_texture_from_path(path: String) -> Texture:
	var image := Image.new()
	image.load(path)
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	
	return texture


# saves texture to file
func save_texture(texture: Texture, topic: String, type: String) -> void:
	var path := folder_from_topic_name(topic) + type + ".png"
	
	var dir := Directory.new()
	dir.remove(path)
	
	var data := texture.get_data()
	data.save_png(path)


# -
func _ready() -> void:
	# load resources from file
	resources = load_from_file("user://images/re.flect")


# -
func _exit_tree() -> void:
	# save resources to file
	save_to_file(resources, "user://images/re.flect")


# loads a dictionary from the specified file path
func load_from_file(path: String) -> Dictionary:
	var file := File.new()
	
	if file.open(path, File.READ) != OK:
		push_error("Could not open file " + path)
		return {}
	
	var content: Dictionary = str2var(file.get_as_text())
	
	file.close()
	
	return content


# saves a dictionary to the specified file path
func save_to_file(dictionary: Dictionary, path: String) -> void:
	var file := File.new()
	
	if file.open(path, File.WRITE) != OK:
		push_error("Could not open file " + path)
		return
	
	file.store_string(var2str(dictionary))
	
	file.close()
	
	return


# returns folder from specified topic
func folder_from_topic_name(topic_name: String) -> String:
	for topic in resources["topics"]:
		if topic["name"] == topic_name:
			return topic["folder"]
	
	return ""


# removes directory with files in it
# (modified from: https://www.davidepesce.com/2019/11/04/essential-guide-to-godot-filesystem-api/)
func remove_directory(directory_name: String) -> void:
	var directory := Directory.new()
	
	# open directory
	if directory.open(directory_name) == OK:
		# list directory content
		directory.list_dir_begin(true)
		
		var file_name := directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				remove_directory(directory_name + "/" + file_name)
			else:
				directory.remove(file_name)
			file_name = directory.get_next()
		
		# end listing
		directory.list_dir_end()
		
		# remove current path
		directory.remove(directory_name)
