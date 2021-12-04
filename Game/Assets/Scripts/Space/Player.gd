extends KinematicBody2D


##player motion variables##
export var PlayerID = "P1"
const moveDist = 512
var direction = Vector2.ZERO
var PrevPos = Vector2.ZERO
##sets when motion can be done, so you dont get off of the grid-based motion
var canMove = true
##preloads bullets##
var bulletBase = preload("res://Assets/Scenes/Space/Bullet.tscn")
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
	PrevPos = position
# warning-ignore:return_value_discarded
	connect("P1",self,"P1Move")
# warning-ignore:return_value_discarded
	connect("P2",self,"P2Move")
# warning-ignore:return_value_discarded
	connect("CPU",self,"cpuMove")
	pass

#when player is active, allows motion$
func _process(delta):
	if canMove:
		direction = Vector2.ZERO
		##sets Movement Direction
		emit_signal(PlayerID)
		
# warning-ignore:return_value_discarded
		move_and_collide(direction*delta)
		#caps position between the range of x = 32, x = 98
		position.x = min(position.x,998)
		position.x = max(position.x,32)
##motion scripts##
func P1Move():
	if Input.is_action_pressed("leftP1"):
		direction.x -= moveDist
	if Input.is_action_pressed("rightP1"):
		direction.x += moveDist
	if Input.is_action_just_pressed("upP1") && GlobalScene.currentbullets[0] < 1:
		shoot()
	if GlobalScene.inVR:
		Input.action_release("downP1")
		Input.action_release("upP1")
func P2Move():
	if Input.is_action_pressed("leftP2"):
		direction.x -= moveDist
	if Input.is_action_pressed("rightP2"):
		direction.x += moveDist
	if Input.is_action_just_pressed("upP2") && GlobalScene.currentbullets[1] < 1:
		shoot()


##fires bullets##
func shoot():
	#creates bullet
	var newBullet = bulletBase.instance()
	#adds as child to scene
	get_parent().add_child(newBullet)
	#sets location,target,position,and fire angle of bullet
	newBullet.position = position
	newBullet.target = "Enemy"
	newBullet.angle = PI
	#says who fired the bullet
	newBullet.id = convID[PlayerID]
	GlobalScene.currentbullets[convID[PlayerID]] += 1
	pass
##hurts the player##
func hurt():
	GlobalScene.addhealth(-1,PlayerID)
