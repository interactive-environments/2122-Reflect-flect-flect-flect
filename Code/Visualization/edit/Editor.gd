extends Panel


export var camera_path: NodePath
onready var camera: Camera2D = get_node(camera_path)

var button: TextureButton

var topic: String
var type: String

var data: Dictionary

var init := false

var texture_cache := {}


# initializes the editor based on the new button
func initialize(new_button: TextureButton, skip_load := false) -> void:
	button = new_button
	
	topic = button.topic
	type = button.type
	
	# skip loading if already done
	if not skip_load:
		var file_path := FileHandler.folder_from_topic_name(topic) + "re.flect"
		data = FileHandler.load_from_file(file_path)
	
	if data[type]["template"] == -1:
		# ask for the template
		init = true
		
		$InitPanel.initialize()
	else:
		# initialize images
		$ScrollContainer/Images.initialize(topic)
		
		# initialize preview
		$PreviewPanel.initialize(data[type])


# loads the texture from the given link, with caching
func get_texture(image_link: String) -> Texture:
	# set cache if not present
	if not (image_link in texture_cache):
		texture_cache[image_link] = FileHandler.load_texture_from_path(image_link)
	
	# return from cache
	return texture_cache[image_link]


# save the new image @ SaveButton pressed
func _on_SaveButton_pressed() -> void:
	# update images
	data[type]["images"] = $PreviewPanel.save_to_data()
	
	# save data to file
	FileHandler.save_to_file(data, FileHandler.folder_from_topic_name(topic) + "re.flect")
	
	# move template to viewport for screenshotting
	var template := $PreviewPanel/Template
	$PreviewPanel.remove_child(template)
	$Viewport.add_child(template)
	
	# deselect image button in template
	template.select(null)
	
	# set the viewport's attributes
	$Viewport.topic = topic
	$Viewport.type = type
	$Viewport.button = button
	
	# save the texture
	$Viewport.save_texture()
	
	# return to menu
	_on_ReturnButton_pressed()


# return to menu @ ReturnButton pressed
func _on_ReturnButton_pressed() -> void:
	# clear editor images and preview
	$PreviewPanel.clear()
	$ScrollContainer/Images.clear()
	
	$"../UI/ImageInfo".init_button(null)
	
	# reset attributes
	button = null
	topic = ""
	type = ""
	
	# move camera to overview
	camera.move_up()


# select the specified image @ ImagePickerButton pressed
func _on_ImagePickerButton_pressed(image_picker_button: TextureButton) -> void:
	$PreviewPanel/Template.select(image_picker_button)
