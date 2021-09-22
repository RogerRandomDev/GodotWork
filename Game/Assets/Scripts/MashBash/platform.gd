extends StaticBody2D


export var direction:Vector2
export var time:float
export var color:int
var startpos
func _ready():
	startpos = position
	$Sprite.region_rect=Rect2((color%4)*2,16+color-(color%4),1,1)
	$Timer.wait_time = time
	$Timer.start()
	set_constant_linear_velocity(direction)
func _physics_process(delta):
	position+=constant_linear_velocity*delta

func _on_Timer_timeout():
	set_constant_linear_velocity(-constant_linear_velocity)
	if position.distance_to(startpos) < 0.125:
		position = startpos
