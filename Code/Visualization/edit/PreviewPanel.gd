extends Panel


func initialize(data: Dictionary) -> void:
	# add template; this is the ugliest line of code i've ever written
	var template: Control = FileHandler.templates[data["template"]]["template"].instance()
	
	add_child(template)
	
	template.initialize(data)


func clear() -> void:
	for template in get_children():
		template.queue_free()


func save_to_data() -> Dictionary:
	return $Template.save_to_data()
