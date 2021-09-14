extends KinematicBody2D


##player motion variables##
export var PlayerID = "P1"
const moveDist = 101
var direction = Vector2.ZERO
var currentLine : NodePath
##declares if you have items##
var hasdrink = false
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
		direction = Vector2.ZERO
		##sets Movement Direction
		emit_signal(PlayerID)
		
# warning-ignore:return_value_discarded
		move_and_collide(direction)
		position.y = min(position.y,601)
		position.y = max(position.y,197)
##motion scripts##
func P1Move():
	if Input.is_action_just_pressed("upP1"):
		direction.y -= moveDist
	if Input.is_action_just_pressed("downP1"):
		direction.y += moveDist
	if Input.is_action_just_pressed("rightP1") and !hasdrink:
		$Timer.start()
	if Input.is_action_just_released("rightP1"):
		$Timer.stop()
	if Input.is_action_pressed("leftP1") and hasdrink:
		get_node(currentLine).placeItem()
		hasdrink = false
	if !$Timer.is_stopped():
		direction = Vector2.ZERO

func P2Move():
	if Input.is_action_just_pressed("upP2"):
		direction.y -= moveDist
	if Input.is_action_just_pressed("downP2"):
		direction.y += moveDist


func _on_Timer_timeout():
	hasdrink = true
