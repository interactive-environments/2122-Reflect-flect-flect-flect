extends Viewport


var topic: String
var type: String
var button: TextureButton

var save := 0


func save_texture() -> void:
	save = 1


func _process(_delta: float) -> void:
	if save > 0:
		save += 1
		
		if save == 3:
			save = 0
			FileHandler.save_texture(get_texture(), topic, type)
			$Template.queue_free()
			
			# re-initialize overiew button
			button.initialize(topic, type)
