extends Node2D


##Sets variables for bullet itself##
var angle = 0
var velocity = 1024
var target = "Enemy"
var id = 0
var idlib = {0:"P1",1:"P2"}

##moves bullet##
func _physics_process(delta):
	position += Vector2(sin(angle)*velocity*delta,cos(angle)*velocity*delta)
	$Area2D.update()
	if position.y <= -928 or position.y >= 256:
		if id < 3:
			GlobalScene.currentbullets[id] -= 1
		queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group(target):
		if body.is_in_group("oneshot"):
			if body.get_parent().get_parent().is_in_group("Line"):
				body.get_parent().get_parent().get_parent().updateChildren()
			body.get_parent().free()
			if id < 3:
				GlobalScene.currentbullets[id] -= 1
				GlobalScene.setScore(GlobalScene.Score[1][id]+100,idlib[id])
			self.queue_free()
		else:
			body.hurt()
			self.queue_free()
