extends TextureButton


var path: String


func initialize(new_path: String) -> void:
	path = new_path
	
	texture_normal = $"../../../".get_texture(path)
	
	var tex_size := texture_normal.get_size()
	
	expand = true
	
	rect_size = Vector2(get_parent().rect_size.x, get_parent().rect_size.x * (tex_size.y / tex_size.x))
	rect_min_size = rect_size
	
	connect("pressed", get_parent().get_parent().get_parent(), "_on_ImagePickerButton_pressed", [self])
