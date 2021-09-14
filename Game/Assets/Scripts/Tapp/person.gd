extends PathFollow2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func drink():
	GlobalScene.setScore(GlobalScene.Score[2][0]+100,"P1")
	self.queue_free()
	pass


func _on_AngerTimer_timeout():
	unit_offset += 0.05
