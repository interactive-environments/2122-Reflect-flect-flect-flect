extends Panel


export var camera_path: NodePath
onready var camera: Camera2D = get_node(camera_path)

var button: TextureButton

var topic: String
var type: String

var data: Dictionary

var init := false

func initialize(new_button: TextureButton, skip_load := false) -> void:
	button = new_button
	
	topic = button.topic
	type = button.type
	
	# skip loading if already done
	if not skip_load:
		var file_path := FileHandler.folder_from_topic_name(topic) + "re.flect"
		data = FileHandler.load_from_file(file_path)
	
	if data[type]["template"] == -1:
		init = true
		
		$InitPanel.initialize()
	else:
		$PreviewPanel.initialize(data[type])
		$ScrollContainer/Images.initialize(topic)


func _on_SaveButton_pressed() -> void:
	data[type]["images"] = $PreviewPanel.save_to_data()
	
	FileHandler.save_to_file(data, FileHandler.folder_from_topic_name(topic) + "re.flect")
	
	var template := $PreviewPanel/Template
	$PreviewPanel.remove_child(template)
	$Viewport.add_child(template)
	
	$Viewport.topic = topic
	$Viewport.type = type
	$Viewport.button = button
	
	$Viewport.save_texture()
	
	# return to menu
	_on_ReturnButton_pressed()


func _on_ReturnButton_pressed() -> void:
	$ScrollContainer/Images.clear()
	$PreviewPanel.clear()
	
	button = null
	topic = ""
	type = ""
	
	camera.move_up()


func _on_ImagePickerButton_pressed(path: String) -> void:
	$PreviewPanel/Template.select(path)
