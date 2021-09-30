extends StaticBody2D


export var direction:Vector2
export var time = 0.0
export var moveDistance:int
export var color:int
var startpos
var newdir
export var toggle=false
export var toggled = false
export var stationary=false
func _ready():
	startpos = position
# warning-ignore:integer_division
	$Sprite.region_rect=Rect2(1+(color%4)*2,16+(color-(color%4))/4,1,1)
	if time > 0:
		$Timer.wait_time = time
	set_constant_linear_velocity(direction)
	if stationary:
		set_process_internal(false)
		set_process(false)
func _physics_process(delta):
	if !stationary:
		if toggle and $Timer.time_left ==0:
			if toggled and position.distance_to(startpos)<moveDistance:
				position+=constant_linear_velocity*delta
			elif not toggled and position.distance_to(startpos)>0.0625:
				position-=constant_linear_velocity*delta
			else:
				$Timer.start()
			pass
		elif $Timer.time_left==0:
			position+=constant_linear_velocity*delta
			if position.distance_to(startpos)>moveDistance*sign(moveDistance) or position.distance_to(startpos) <= 0.125:
				if time != 0:
					newdir = -constant_linear_velocity
					set_constant_linear_velocity(Vector2.ZERO)
					$Timer.start()
				else:
					set_constant_linear_velocity(-constant_linear_velocity)
				if position.distance_to(startpos) < 0.0625:
					position = startpos



func _on_Timer_timeout():
	if !toggle:
		set_constant_linear_velocity(newdir)
	$Timer.stop()
