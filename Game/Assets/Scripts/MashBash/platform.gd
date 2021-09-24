extends StaticBody2D


export var direction:Vector2
export var time = 0.0
export var moveDistance:int
export var color:int
var startpos
func _ready():
	startpos = position
	$Sprite.region_rect=Rect2(1+(color%4)*2,16+(color-(color%4))/4,1,1)
	if time > 0:
		$Timer.wait_time = time
	
	set_constant_linear_velocity(direction)
func _physics_process(delta):
	if $Timer.time_left==0:
		position+=constant_linear_velocity*delta
		if position.distance_to(startpos)>moveDistance*sign(moveDistance) or position.distance_to(startpos) <= 0.125:
			if time != 0:
				$Timer.start()
			else:
				set_constant_linear_velocity(-constant_linear_velocity)
			if position.distance_to(startpos) < 0.0625:
				position = startpos



func _on_Timer_timeout():
	set_constant_linear_velocity(-constant_linear_velocity)
	$Timer.stop()
