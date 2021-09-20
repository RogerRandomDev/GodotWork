extends KinematicBody2D


var movespeed = 128
var direction=Vector2.ZERO
var player:NodePath
var deathparticles = preload("res://Assets/Scenes/MashBash/entities/deathparticles.tscn")

func _on_Area2D_body_entered(body):
	
	if body.name=="Player" && $DieTimer.is_stopped():
		$movetimer.start()
		$Sprite.modulate = Color.red
		player = body.get_path()
		$Area2D/CollisionShape2D.shape.radius = 384


func _on_movetimer_timeout():
	direction.x = sign(get_node(player).position.x-position.x)
	$Sprite.flip_h=direction.x<0
# warning-ignore:return_value_discarded
	move_and_collide(direction*movespeed*0.125)
	if (position-get_node(player).position).length() < 48:
		$DieTimer.start()
		$movetimer.stop()


func _on_Area2D_body_exited(body):
	if body.name =="Player":
		$movetimer.stop()
		$Sprite.modulate = Color.white
		$Area2D/CollisionShape2D.shape.radius = 256


func _on_DieTimer_timeout():
		var death = deathparticles.instance()
		get_parent().add_child(death)
		death.position = self.position
		queue_free()
