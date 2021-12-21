extends Panel


# -
func _ready() -> void:
	$KinectViewer.visible = KinectHandler.opened
	$KinectLabel.visible = not KinectHandler.opened
