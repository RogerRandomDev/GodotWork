extends Node2D

var velocity = 256
var angle = 0.0
var targetpos = Vector2.ZERO
var setup = false
func setUp():
	self.update()
	randomize()
	targetpos.x = rand_range(128.0,896.0)
	targetpos.y = 848
	angle = get_angle_to(targetpos+Vector2(0,928))-PI/2
	setup = true
	$Sprite.self_modulate = GlobalScene.randColor()
	$Sprite.rotation = angle

func _physics_process(delta):
		position += Vector2(velocity*sin(-angle),velocity*cos(-angle))*delta
		if position.y >= targetpos.y && setup:
			explode()

func explode():
	$Area2D.update()
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Ally") && body.is_in_group("Enemy"):
			body.hp = 1
			body.hurt()
	self.queue_free()
