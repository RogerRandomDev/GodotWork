extends PathFollow2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://Assets/Textures/Tapp/Person"+str(round(rand_range(0.0,3.0)))+".png")
	unit_offset = 0.0
	show()


func drink():
	GlobalScene.setScore(GlobalScene.Score[2][0]+100,"P1")
	GlobalScene.playSound0("res://Assets/Audio/Tapp/leave.wav")
	self.queue_free()
	pass

var currentcount = 0
func _on_AngerTimer_timeout():
	currentcount = 0
	for child in get_parent().get_children():
		if child.unit_offset >= unit_offset+0.05 and child.unit_offset < unit_offset+0.125:
			currentcount += 1
	if currentcount < 1:
		unit_offset += 0.05
	if unit_offset >= 0.95:
		GlobalScene.trueover("P1")
