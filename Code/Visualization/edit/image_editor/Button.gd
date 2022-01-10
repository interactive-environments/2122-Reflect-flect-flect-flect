extends Button


var image_link: String

onready var sprite: Sprite = $Sprite


func _ready() -> void:
	#connect("pressed", get_parent().get_parent().get_parent(), "_on_Button_pressed", [self])
	connect("pressed", get_parent(), "_on_Button_pressed", [self])


func initialize(new_image_link: String) -> void:
	image_link = new_image_link
	
	sprite.texture = FileHandler.load_texture_from_path(image_link)


func fit(bounding_rect: Rect2, scale_factor: float) -> void:
	# get region rect according to rect
	sprite.region_rect.position = (rect_position - bounding_rect.position) / scale_factor
	sprite.region_rect.size = rect_size / scale_factor
	
	sprite.scale = Vector2.ONE * scale_factor
