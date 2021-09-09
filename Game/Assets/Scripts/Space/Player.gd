extends KinematicBody2D


##player motion variables##
export var PlayerID = "P1"
const moveDist = 256
var direction = Vector2.ZERO
var PrevPos = Vector2.ZERO
##sets when motion can be done, so you dont get off of the grid-based motion
var canMove = true

#signals for motion, to set controls, and for CPU, to process what they should choose to do
# warning-ignore:unused_signal
signal P1
# warning-ignore:unused_signal
signal P2
# warning-ignore:unused_signal
signal CPU
##current score
var score = 0

func _ready():
	PrevPos = position
# warning-ignore:return_value_discarded
	connect("P1",self,"P1Move")
# warning-ignore:return_value_discarded
	connect("P2",self,"P2Move")
# warning-ignore:return_value_discarded
	connect("CPU",self,"cpuMove")
	pass

func _process(delta):
	if canMove:
		direction = Vector2.ZERO
		##sets Movement Direction
		emit_signal(PlayerID)
		
# warning-ignore:return_value_discarded
		move_and_collide(direction*delta)

func P1Move():
	if Input.is_action_pressed("leftP1"):
		direction.x -= moveDist
	if Input.is_action_pressed("rightP1"):
		direction.x += moveDist
