extends Control


onready var preview_panel: Panel

const default_image_link := "user://default_image.png"

var current_image_button: TextureButton


# initializes the template
func initialize(data: Dictionary) -> void:
	current_image_button = null
	
	# initialize children
	for child in get_children():
		var image_link: String = data["images"].get(child.name, default_image_link)
		
		child.initialize(image_link)
	
	fit()


# selects the pressed button @ Button pressed
func _on_Button_pressed(button: Button) -> void:
	if not current_image_button:
		return
	
	button.initialize(current_image_button.path)
	
	fit()


# selects the image path for the pressed button
func select(button: TextureButton) -> void:
	print("selected ", button)
	
	if current_image_button:
		current_image_button.modulate = Color.white
	
	current_image_button = null if current_image_button == button else button


# -
func _process(_delta: float) -> void:
	if current_image_button:
		current_image_button.modulate = Color.white if ((OS.get_ticks_msec() % 700) < 350) else Color.silver


# fits all images to the buttons that have them
func fit() -> void:
	# get index from image link to buttons
	var link_to_buttons := {}
	for button in get_children():
		var link: String = button.image_link
		
		if not (link in link_to_buttons):
			link_to_buttons[link] = []
		
		link_to_buttons[link].push_back(button)
	
	# process every image link separately
	for link in link_to_buttons:
		var buttons: Array = link_to_buttons[link]
		
		# get smallest encompassing rectangle for buttons with the same image
		var rect: Rect2 = buttons[0].get_rect()
		for button in buttons:
			rect = rect.merge(button.get_rect())
		
		var image_size: Vector2 = buttons[0].sprite.texture.get_size()
		var scale_factor := max(rect.size.x / image_size.x, rect.size.y / image_size.y)
		
		# get corrected rectangle, align centre to rect
		var bounding_rect := Rect2(Vector2(), image_size * scale_factor)
		bounding_rect.position = (rect.position + 0.5 * rect.size) - (bounding_rect.size / 2)
		
		for button in buttons:
			button.fit(bounding_rect, scale_factor)


# saves the image data
func save_to_data() -> Dictionary:
	var result := {}
	
	for child in get_children():
		var link: String = child.image_link
		
		if link != default_image_link:
			result[child.name] = link
	
	return result
