class_name InteractivePanel
extends Panel


var panel_children := []

var panel_parent: InteractivePanel

var animation_factor := 0.0

onready var start_position := rect_position
onready var start_size := rect_size

onready var main := get_parent().get_parent().get_parent()


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
	#var pos1 := (rect_position) / 2.5
	#var pos2 := (rect_position + Vector2(rect_size.x, 0)) / 2.5
	#var pos3 := (rect_position + rect_size) / 2.5
	#var pos4 := (rect_position + Vector2(0, rect_size.y)) / 2.5
	#var pos5 := (rect_position + 0.5 * rect_size) / 2.5
	
	#var value := 0.0
	#for pos in [pos1, pos2, pos3, pos4, pos5]:
	#	value += main.GetPixel(int(pos.x) + 200, int(pos.y))
	
	var pos := (rect_position + 0.5 * rect_size) / 2.5
	var value: int = main.GetPixel(int(pos.x) + 200, int(pos.y)) * 127
	#value = round(value / 5) * 127
	
	modulate.r = lerp(modulate.r, value / 255.0, 0.2)
	modulate.g = modulate.r
	modulate.b = modulate.r
	
	
	#var f := clamp(animation_factor - 1.0, 0, 1)
	#rect_position = start_position.move_toward(panel_parent.start_position, f * 6)
	#rect_size = start_size.move_toward(panel_parent.start_size, f * 6)
