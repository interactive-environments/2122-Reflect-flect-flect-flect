extends Sprite


var active := false

var timer := 0


func _process(delta: float) -> void:
	visible = active
