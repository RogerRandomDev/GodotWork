extends KinematicBody2D

##variables inserted here##

##Camera variable##
export var cam: NodePath
##player motion variables##
export var PlayerID = "P1"
const moveDist = 64
var direction = Vector2.ZERO
##sets when motion can be done, so you dont get off of the grid-based motion
var canMove = true

##forces player to move up at a set pace, as the value your camera will be at lowest and the rate it goes up
var cameraY = 448
export var climbRate = 32

#signals for motion, to set controls, and for CPU, to process what they should choose to do
signal P1
signal P2
signal CPU


func _ready():
	connect("P1",self,"P1Move")
	connect("P2",self,"P2Move")
	connect("CPU",self,"cpuMove")
	pass

func _process(delta):
	if canMove:
		direction = Vector2.ZERO
		##sets Movement Direction
		emit_signal(PlayerID)
		
		##sets the ability to move to false when in the middle of motion already##
		if direction != Vector2.ZERO:
			canMove=false
			$Timer.start()
	##Applies current motion, the 0.125 is the motion time to interoplate by##
	move_and_collide(direction*0.125)
	position.x = max(min(512,position.x),0)
	##sets camera vertical position and minimum vertical position
	cameraY-=climbRate*delta
	cameraY = min(self.position.y,cameraY)
	get_node(cam).position.y = cameraY


func _on_Timer_timeout():
	canMove = true

func P1Move():
	if Input.is_action_just_pressed("leftP1"):
		direction.x = -moveDist;
	elif Input.is_action_just_pressed("rightP1"):
		direction.x =moveDist;
	elif Input.is_action_just_pressed("downP1"):
		direction.y = moveDist;
	elif Input.is_action_just_pressed("upP1"):
		direction.y = -moveDist;

func P2Move():
	if Input.is_action_just_pressed("leftP2"):
		direction.x = -moveDist;
	elif Input.is_action_just_pressed("rightP2"):
		direction.x =moveDist;
	elif Input.is_action_just_pressed("downP2"):
		direction.y = moveDist;
	elif Input.is_action_just_pressed("upP2"):
		direction.y = -moveDist;
func cpuMove():
	pass
