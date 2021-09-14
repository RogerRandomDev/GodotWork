extends KinematicBody2D

##variables inserted here##

##Camera variable##
export var cam: NodePath
##map node so you can change position and others##
export var Map: NodePath
##player motion variables##
export var PlayerID = "P1"
const moveDist = 64
var direction = Vector2.ZERO
var PrevPos = Vector2.ZERO
##sets when motion can be done, so you dont get off of the grid-based motion
var canMove = true
##forces player to move up at a set pace, as the value your camera will be at lowest and the rate it goes up
var cameraY = 448
export var climbRate = 16
##sets player sprite image using thins##
var spritePos = Vector2(0,7.5)
var spriteSize = Vector2(8,8)
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
	$Sprite.region_rect.position.x = (int(PlayerID!="P1")*18)
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
		
		##sets the ability to move to false when in the middle of motion already##
		if direction != Vector2.ZERO && canMove:
			canMove=false
			PrevPos = position
			$Timer.start()
			$Sprite.region_rect.position.x += 9
			GlobalScene.playmove()
	##Applies current motion, the 0.125 is the motion time to interoplate by##
	if !canMove:
# warning-ignore:return_value_discarded
		move_and_collide(direction*delta/$Timer.wait_time)
	position.x = max(min(768,position.x),0)
	##sets camera vertical position and minimum vertical position
	cameraY-=climbRate*delta
	cameraY = min(self.position.y,cameraY)
	get_node(cam).position.y = cameraY
	if position.y-cameraY>512 && GlobalScene.cancontinue:
		GlobalScene.trueover(PlayerID)


func _on_Timer_timeout():
	#reenables motion and realligns you to the grid by resetting position and moving without interp
	position = PrevPos
# warning-ignore:return_value_discarded
	move_and_collide(direction)
	canMove = true
	##resets player image##
	$Sprite.region_rect.position.x = (int(PlayerID!="P1")*18)

func P1Move():
	if Input.is_action_just_pressed("leftP1"):
		direction.x = -moveDist;
		$Sprite.rotation_degrees = -90
	elif Input.is_action_just_pressed("rightP1"):
		direction.x =moveDist;
		$Sprite.rotation_degrees = 90
	elif Input.is_action_just_pressed("downP1"):
		direction.y = moveDist;
		$Sprite.rotation_degrees = 180
	elif Input.is_action_just_pressed("upP1"):
		direction.y = -moveDist;
		$Sprite.rotation_degrees = 0
	get_node(Map).ModulePosition = max(-position.y+2304,get_node(Map).ModulePosition)

func P2Move():
	if Input.is_action_just_pressed("leftP2"):
		direction.x = -moveDist;
		$Sprite.rotation_degrees = -90
	elif Input.is_action_just_pressed("rightP2"):
		direction.x =moveDist;
		$Sprite.rotation_degrees = 90
	elif Input.is_action_just_pressed("downP2"):
		direction.y = moveDist;
		$Sprite.rotation_degrees = 180
	elif Input.is_action_just_pressed("upP2"):
		direction.y = -moveDist;
		$Sprite.rotation_degrees = 0
	get_node(Map).ModulePosition = max(-position.y+2304,get_node(Map).ModulePosition)

#Deprecated, currently un-used and unupdated, will work on as is seen fit
func cpuMove():
	pass


func _on_ScoreTimer_timeout():
	#updates score over time
	score += round(-(position.y/6400))+1
	GlobalScene.setScore(abs(round(score-0.5)),PlayerID)
	$ScoreTimer.start()
