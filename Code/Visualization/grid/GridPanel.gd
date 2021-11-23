class_name GridPanel
extends Panel


var panel_children := []

var panel_parent: GridPanel

var animation_factor := 0.0

onready var start_position := rect_position
onready var start_size := rect_size


func _ready() -> void:
	# add sprite
	if not get_node_or_null("Content"):
		var new_sprite: = preload("res://Sprite.tscn").instance()
		add_child(new_sprite)
	
	var level := int(get_parent().name.right(5))
	
	if level == 1:
		return
	
	var rect := Rect2(rect_position - Vector2(1, 1), rect_size + Vector2(1, 1))
	
	for child in get_node("../../Level" + str(level - 1)).get_children():
		var panel := child as Panel
		
		if rect.has_point(panel.rect_position):
			panel_children.append(panel)
			panel.panel_parent = self


func _process(_delta: float) -> void:
	modulate.a = clamp(animation_factor if animation_factor < 2 else 0.0, 0, 1)
	
	# ignore if no parent
	if not panel_parent:
		return
	
	# animate towards parent
	rect_position = start_position.linear_interpolate(panel_parent.start_position, clamp(animation_factor - 1, 0, 1))
	rect_size = start_size.linear_interpolate(panel_parent.start_size, clamp(animation_factor - 1, 0, 1))
	
	# animate color according to depth values
	var pos := (rect_position + 0.5 * rect_size) / 2.5
	var value: int = KinectHandler.get_pixel(int(pos.x) + 200, int(pos.y)) * 127
	
	modulate.r = 1.0
	modulate.g = lerp(modulate.g, value / 255.0, 0.2)
	modulate.b = 1.0
