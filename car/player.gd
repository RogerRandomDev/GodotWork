extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Velocity = Vector2.ZERO
var Direction = Vector2.ZERO
export var move_speed = 192
export var max_speed = 3072
export var accel_rate = 5.0
export var decel_rate = 7.5
export var turn_speed = 60.0
func _process(delta):
	Direction = Vector2.ZERO
	check_keys()
	angular_velocity += Direction.y*delta*turn_speed*linear_velocity.length()
	angular_velocity = min(abs(angular_velocity),0.0015*linear_velocity.length())*sign(angular_velocity)
	angular_velocity = min(abs(angular_velocity),5.0)*sign(angular_velocity)
	if Direction.y == 0 || linear_velocity.length_squared() <= 64:
		angular_velocity -= angular_velocity*delta*turn_speed*0.25
	linear_velocity += Vector2(Direction.x,0).rotated(rotation-PI/2)*accel_rate*delta
	if Direction.x <= 0:
		linear_velocity -= linear_velocity*decel_rate*delta
	var offset_velocity = linear_velocity.rotated(-rotation)
	var changed_by = abs(offset_velocity.x)*0.1
	offset_velocity.x*=0.5
	offset_velocity.y+=changed_by*sign(offset_velocity.y)
	linear_velocity=offset_velocity.rotated(rotation)
	linear_velocity = Vector2(clamp(linear_velocity.x,-max_speed,max_speed),clamp(linear_velocity.y,-max_speed,max_speed))

func check_keys():
	if Input.is_action_pressed("forward"):
		Direction.x += move_speed
	if Input.is_action_pressed("backward"):
		Direction.x -= move_speed
		if Direction.x != 0:
			Direction.x = -move_speed*5.0
	if Input.is_action_pressed("left"):
		Direction.y -= 1
	if Input.is_action_pressed("right"):
		Direction.y += 1
