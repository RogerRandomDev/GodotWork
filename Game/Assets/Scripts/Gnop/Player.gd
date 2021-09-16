extends KinematicBody2D


##player motion variables##
export var PlayerID = "P1"
const moveDist = 768
var direction = Vector2.ZERO
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
var convID = {"P1":0,"P2":1}
func _ready():
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
		position.y = max(position.y,96)
		position.y = min(position.y,608)
		position.x = sign(convID[PlayerID]-0.5)*992
##motion scripts##
func P1Move():
	if Input.is_action_pressed("downP1"):
		direction.y += moveDist
	if Input.is_action_pressed("upP1"):
		direction.y -= moveDist

func P2Move():
	if Input.is_action_pressed("downP2"):
		direction.y += moveDist
	if Input.is_action_pressed("upP2"):
		direction.y -= moveDist
