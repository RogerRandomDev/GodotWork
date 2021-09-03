extends KinematicBody2D

##variables inserted here##

##Camera variable##
export var cam: NodePath
##player motion variables##
export var PlayerID = 1
const moveDist = 64
var direction = Vector2.ZERO
var canMove = true



func _ready():
	pass

func _process(delta):
	if canMove:
		direction = Vector2.ZERO
		##sets Movement Direction
		if Input.is_action_just_pressed("left"):
			direction.x = -moveDist;
		elif Input.is_action_just_pressed("right"):
			direction.x =moveDist;
		elif Input.is_action_just_pressed("down"):
			direction.y = moveDist;
		elif Input.is_action_just_pressed("up"):
			direction.y = -moveDist;
		
		##sets the ability to move to false when in the middle of motion already##
		if direction != Vector2.ZERO:
			canMove=false
			$Timer.start()
	##Applies current motion, the 0.125 is the motion time to interoplate by##
	move_and_collide(direction*0.125)
	##sets camera vertical position
	get_node(cam).position.y = self.position.y


func _on_Timer_timeout():
	canMove = true
