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
	init_button(null if current_button == button else button)


# initializes a button
func init_button(button: TextureButton) -> void:
	if current_button:
		current_button.modulate = Color.white
	
	current_button = button
	
	if not button:
		$TitleLabel.text = "No image selected"
		$FolderLabel.text = "Select an image to continue"
		
		$EditButton.visible = false
		
		$Sprite.modulate = Color.black
		return
	
	$TitleLabel.text = button.topic + " - " + button.type.capitalize()
	$FolderLabel.text = FileHandler.folder_from_topic_name(button.topic) + button.type + ".png"
	
	$EditButton.visible = true
	
	var texture := button.texture_normal
	$Sprite.modulate = Color.white
	$Sprite.texture = texture


func _process(_delta: float) -> void:
	if current_button:
		current_button.modulate = Color.white if ((OS.get_ticks_msec() % 700) < 350) else Color.silver


# initialize editor @ EditButton pressed
func _on_EditButton_pressed() -> void:
	if not current_button:
		return
	
	editor.initialize(current_button)
	camera.move_down()
