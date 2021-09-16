extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var newBall = load("res://Assets/Scenes/Gnop/Ball.tscn")
var angle = 0.0
var angleDir = -1
var direction = Vector2(512,512)
var speedmult = 1.0
var lasthit = 0
export var bonusball = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if ! bonusball:
		chooseDir()


##moves the ball and updates its collisions##
func _process(delta):
	
# warning-ignore:return_value_discarded
	move_and_collide(direction*Vector2(sin((angle)),cos((angle)))*delta*speedmult)
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
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).show()
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(0).text = str(GlobalScene.Score[GlobalScene.currentgame][0])+":"+str(GlobalScene.Score[GlobalScene.currentgame][1])
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).text = "LOSE       WIN"
		reset()
	if position.x > 1024:
		##sets scores##
		GlobalScene.setScore(GlobalScene.Score[GlobalScene.currentgame][0]+1,"P1")
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).show()
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(0).text = str(GlobalScene.Score[GlobalScene.currentgame][0])+":"+str(GlobalScene.Score[GlobalScene.currentgame][1])
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).text = "WIN       LOSE"
		reset()

##chooses bounce direction##
func chooseDir():
	angle = round(rand_range(0.0,1.0))*PI+PI/2

##checks who it is interacting with and what it should do in response##
func _on_InteractArea_body_entered(body):
	##bounces when it meets player based on distance to center of paddle##
	if body.is_in_group("Player"):
		if body.position.x > 0:
			lasthit = 0
			angle = (abs((position.angle_to_point(body.position-Vector2(125,0)))))*sign(angle)-PI/2
		if body.position.x < 0:
			lasthit = 1
			angle = ((abs((position.angle_to_point(body.position-Vector2(128,0))))))*sign(angle)+PI/2
		#caps the angles to prevent it going near straigh upwards#
		if rad2deg(abs(angle)) > 135:angle=deg2rad(135*sign(angle))
		if rad2deg(abs(angle))<45:angle=deg2rad(45*sign(angle))
	if body.is_in_group("PowerUp"):
		powerup(body.get_parent().Powerup)
		body.get_parent().queue_free()
	#prevents balls from hitting eachother#
	if body.is_in_group("Ball"):
		$CollisionShape2D.disabled = true
#resets ball#
func reset():
	position = Vector2(0,304)
	speedmult = 1.0
	chooseDir()
	if bonusball:
		queue_free()
	if !bonusball:
		hide()
		direction = Vector2.ZERO
		$CollisionShape2D.disabled = true
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).hide()
		$checkball.start()
##activates powerups##
func powerup(power):
	if power == 0:
		speedmult = 1.5
	if power == 1:
		var newB = newBall.instance()
		get_parent().add_child(newB)
		newB.position = position + Vector2(0,128)
		newB.angle = angle + rand_range(PI/2,-PI/2)
		if rad2deg(abs(newB.angle)) > 135:newB.angle=deg2rad(135*sign(newB.angle))
		if rad2deg(abs(newB.angle))<45:newB.angle=deg2rad(45*sign(newB.angle))
	if power == 2:
		angle += rand_range(-PI,PI)
		if rad2deg(abs(angle)) > 135:angle=deg2rad(135*sign(angle))
		if rad2deg(abs(angle))<45:angle=deg2rad(45*sign(angle))
func _on_WinLose_timeout():
	get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).hide()


func _on_checkball_timeout():
	$WinLose.stop()
	get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).hide()
	if get_tree().get_nodes_in_group("Ball").size() <= 1:
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(3).show()
		position = Vector2(0,304)
		speedmult =	 1.0
		chooseDir()
		direction = Vector2(512,512)
		$CollisionShape2D.disabled = false
		$WinLose.start()
		$checkball.stop()
		show()


func _on_InteractArea_body_exited(body):
	if body.is_in_group("Ball"):
		$CollisionShape2D.disabled = false
