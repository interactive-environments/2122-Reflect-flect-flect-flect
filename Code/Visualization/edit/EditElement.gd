extends Control


var topic: String

onready var cover_button: TextureButton = $CoverButton
onready var content_button: TextureButton = $ContentButton


# loads the element from user files
func load_from_file(new_topic: String) -> void:
	topic = new_topic
	
	# set title text
	$Title.text = topic
	
	# load images
	cover_button.initialize(topic, "cover")
	content_button.initialize(topic, "content")


# saves the element to user files
func save_to_file() -> void:
	# save images into folder
	FileHandler.save_texture(cover_button.texture_normal, topic, "cover")
	FileHandler.save_texture(content_button.texture_normal, topic, "content")


func _on_Title_text_changed(new_text: String) -> void:
	for t in FileHandler.resources["topics"]:
		if t["name"] == topic:
			t["name"] = new_text
			
			topic = new_text
			
			cover_button.topic = new_text
			content_button.topic = new_text
			
			return


func _on_DeleteButton_pressed() -> void:
	# delete files
	FileHandler.delete_topic(topic)
	
	# deselect cover or content if needed
	var image_info := $"../../../ImageInfo"
	var current_button: TextureButton = image_info.current_button
	
	if current_button == cover_button or current_button == content_button:
		image_info.init_button(null)
	
	# delete element
	queue_free()


func _on_RevealButton_pressed() -> void:
	var folder := FileHandler.folder_from_topic_name(topic)
	var abs_folder := ProjectSettings.globalize_path(folder)
	
	OS.shell_open(abs_folder)
