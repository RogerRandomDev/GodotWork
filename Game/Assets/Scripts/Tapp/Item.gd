extends PathFollow2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var progress = 0
func _physics_process(delta):
	progress += 0.0075
	unit_offset = 1-progress
	$Area2D.update()
	if unit_offset <= 0.0125:
		GlobalScene.health[0] -= 1
		get_tree().get_nodes_in_group("Spills")[0].text = "SPILLED GLASSES:"+str(3-GlobalScene.health[0])+"/3"
		if GlobalScene.health[0]==0:
			GlobalScene.gameover("P1")
		
		self.queue_free()
func _on_Area2D_body_entered(body):
	if body.is_in_group("Person"):
		body.get_parent().drink()
		self.queue_free()
