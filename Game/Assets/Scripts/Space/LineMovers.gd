extends Path2D



const maxlength = 288
const moverate = 32
const YRate = 64
var direction = 1
var aliens = 8
var id = "P1"
##preloads bullets##
var bulletBase = preload("res://Assets/Scenes/Space/Bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ShootTimer.wait_time = rand_range(0.5,10.0)
	pass # Replace with function body.

##moves whenever this times out by set amount, and checks if it needs to flip##
func _on_MoveTimer_timeout():
	##moves here
	$PathFollow2D.offset += moverate*direction
	#checking if at edge and if so, flip direction and move down 1
	if $PathFollow2D.offset >= 288 or $PathFollow2D.offset <=0:
		$PathFollow2D.offset = round($PathFollow2D.offset)
		direction = -direction
		$movedowntimer.start()

##moves down one and if it reaches the player, it initiates true game over, where you cant
#continue##
func _on_movedowntimer_timeout():
	position.y = position.y+YRate
	if position.y >= 816:
		GlobalScene.trueover(id)
##updates when a mover is killed, so it can remove itself when there are none left##
func updateChildren():
	aliens -=1
	if aliens == 0:
		get_parent().updateMovers()
		queue_free()


func _on_ShootTimer_timeout():
	var shooter = round(rand_range(0.0,aliens-1))
	shoot(shooter)
	$ShootTimer.wait_time = rand_range(1.5,10.0)
##fires bullets##
func shoot(shooter):
	#creates bullet
	var newBullet = bulletBase.instance()
	#adds as child to scene
	get_parent().get_parent().get_parent().add_child(newBullet)
	#sets location,target,position,and fire angle of bullet
	newBullet.target = "Ally"
	newBullet.position.x = $PathFollow2D.get_child(shooter).position.x+$PathFollow2D.offset+32
	newBullet.position.y = get_parent().get_parent().position.y+position.y
	newBullet.angle = 0.0
	newBullet.velocity = 512
	
	#says who fired the bullet
	newBullet.id = 3
	pass
