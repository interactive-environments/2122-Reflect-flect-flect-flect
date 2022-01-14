extends Panel


onready var editor: Panel = get_parent()


# -
func _ready() -> void:
	visible = false
	
	var i := 0
	
	for t in FileHandler.templates:
		var button := TextureButton.new()
		
		button.texture_normal = t["image"]
		
		$ScrollContainer/Images.add_child(button)
		
		button.connect("pressed", self, "_on_Button_pressed", [i])
		
		i += 1


# initializes the panel
func initialize() -> void:
	visible = true
	
	yield(get_tree(), "idle_frame")
	
	for _button in $ScrollContainer/Images.get_children():
		var button := _button as TextureButton
		
		button.rect_scale = Vector2.ONE * 0.5
		
		button.margin_left = 550


func _on_Button_pressed(index: int) -> void:
	editor.data[editor.type]["template"] = index
	
	editor.initialize(editor.button, true)
	
	visible = false
