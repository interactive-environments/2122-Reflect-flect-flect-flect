extends Panel


export var camera_path: NodePath
onready var camera: Camera2D = get_node(camera_path)

export var editor_path: NodePath
onready var editor: Panel = get_node(editor_path)

var current_button: TextureButton


# -
func _ready() -> void:
	init_button(null)


# initializes the pressed button @ Button pressed
func _on_Button_pressed(button: TextureButton) -> void:
	init_button(button)


# initializes a button
func init_button(button: TextureButton) -> void:
	current_button = button
	
	if not button:
		$TitleLabel.text = "No image selected"
		$FolderLabel.text = "-"
		
		$EditButton.visible = false
		
		$Sprite.visible = false
		return
	
	$TitleLabel.text = button.topic + " - " + button.type.capitalize()
	$FolderLabel.text = FileHandler.folder_from_topic_name(button.topic) + button.type + ".png"
	
	$EditButton.visible = true
	
	var texture := button.texture_normal
	$Sprite.visible = true
	$Sprite.texture = texture


# initialize editor @ EditButton pressed
func _on_EditButton_pressed() -> void:
	if not current_button:
		return
	
	editor.initialize(current_button)
	camera.move_down()
