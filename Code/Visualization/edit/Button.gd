extends TextureButton


var topic: String
var type: String


# initializes the button
func initialize(new_topic: String, new_type: String) -> void:
	topic = new_topic
	type = new_type
	
	load_image()


# loads the image from its path
func load_image() -> void:
	texture_normal = FileHandler.load_texture(topic, type)
