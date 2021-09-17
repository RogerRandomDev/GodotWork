extends KinematicBody2D

var run_speed = 256
var jump_speed = -512
var decelrate = 5
var acelrate = 15
var gravity = 512
var angle = 0
var velocity = Vector2.ZERO
var jumping = false
var anglemult = 1
export var played = false
export var camera:NodePath
func get_input():

	if Input.is_action_just_pressed("upP1") and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	velocity.x += (int(Input.is_action_pressed("rightP1"))-int(Input.is_action_pressed("leftP1")))*run_speed*acelrate*get_physics_process_delta_time()
	velocity.x = min(abs(velocity.x),run_speed)*sign(velocity.x)
	print(velocity.x)

func _physics_process(delta):
	if played:
		velocity.x -= velocity.x*delta*decelrate
		get_input()
		velocity.y += gravity * delta
		if jumping and is_on_floor():
			jumping = false
		velocity = move_and_slide(velocity, Vector2(0, -1))
		angle += (velocity.x/128)*anglemult
		if abs(angle) > 15 or abs(angle) < -15:
			anglemult = -anglemult
		rotation_degrees = angle
		get_node(camera).position = position
