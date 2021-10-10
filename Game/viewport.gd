extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inVR = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if inVR:
		GlobalScene.setvolume(10)
		GlobalScene.setnoise(0)
	pass # Replace with function body.
func freechildren():
	for child in get_children():
		child.queue_free()
	pass
