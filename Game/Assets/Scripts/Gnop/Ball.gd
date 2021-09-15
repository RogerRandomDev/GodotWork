extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var angle = 0.0
var angleDir = -1
var direction = Vector2(512,512)
# Called when the node enters the scene tree for the first time.
func _ready():
	chooseDir()


##moves the ball and updates its collisions##
func _process(delta):
	move_and_collide(direction*Vector2(sin((angle)),cos((angle)))*delta)
	if position.y >= 640:
		angle = PI-angle
		position.y = 639
	if position.y <= 64:
		angle = PI-angle
		position.y = 65
	update()
	$InteractArea.update()
	if position.x < -1024:
		##sets scores##
		GlobalScene.setScore(GlobalScene.Score[GlobalScene.currentgame][1]+1,"P2")
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(0).text = str(GlobalScene.Score[GlobalScene.currentgame][0])+":"+str(GlobalScene.Score[GlobalScene.currentgame][1])
		reset()
	if position.x > 1024:
		##sets scores##
		GlobalScene.setScore(GlobalScene.Score[GlobalScene.currentgame][0]+1,"P1")
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(0).text = str(GlobalScene.Score[GlobalScene.currentgame][0])+":"+str(GlobalScene.Score[GlobalScene.currentgame][1])
		reset()

##chooses bounce direction##
func chooseDir():
	angle = round(rand_range(0.0,1.0))*PI+PI/2

##checks who it is interacting with and what it should do in response##
func _on_InteractArea_body_entered(body):
	##bounces when it meets player based on distance to center of paddle##
	if body.is_in_group("Player"):
		if body.position.x > 0:
			angle = (abs((position.angle_to_point(body.position))))*sign(angle)-PI
		if body.position.x < 0:
			angle = (abs((position.angle_to_point(body.position))))*sign(angle)+PI/2
		#caps the angles to prevent it going near straigh upwards#
		if rad2deg(abs(angle)) > 135:angle=deg2rad(135*sign(angle))
		if rad2deg(abs(angle))<45:angle=deg2rad(45*sign(angle))

#resets ball#
func reset():
	position = Vector2(0,304)
	chooseDir()
