extends KinematicBody2D

var run_speed = 256
var jump_speed = -544
var decelrate = 5
var acelrate = 15
var gravity = 768
var angle = 0
var velocity = Vector2.ZERO
var jumping = false
var anglemult = 1
export var played = false
var doublejump = false
var lastwall = -1
export var camera:NodePath
func get_input():
	var justjumped = false
	jumping =  Input.is_action_just_pressed("upP1") 
	if jumping and is_on_floor() or jumping and !doublejump:
		doublejump = true
		lastwall = -1
		velocity.y = jump_speed
		justjumped = true
	if jumping and not justjumped:
		if $left.is_colliding():
			velocity.y = jump_speed*0.975
			lastwall = 0
			velocity.x = run_speed
		if $right.is_colliding():
			velocity.y = jump_speed*0.975
			lastwall = 1
			velocity.x = -run_speed
	if lastwall == -1:
		velocity.x += (int(Input.is_action_pressed("rightP1"))-int(Input.is_action_pressed("leftP1")))*run_speed*acelrate*get_physics_process_delta_time()
	else:
		velocity.x += (int(Input.is_action_pressed("rightP1"))-int(Input.is_action_pressed("leftP1")))*run_speed*acelrate*get_physics_process_delta_time()*0.1
	velocity.x = min(abs(velocity.x),run_speed)*sign(velocity.x)
	if is_on_floor():
		lastwall = -1
		doublejump = false

func _physics_process(delta):
	if played:
		if is_on_floor():
			velocity.x -= velocity.x*delta*decelrate
		get_input()
		velocity.y += gravity * delta
		if jumping and is_on_floor():
			jumping = false
		velocity = move_and_slide(velocity, Vector2(0, -1))
		angle += (velocity.x/128)*anglemult
		if abs(angle) > 25 or abs(angle) < -25:
			anglemult = -anglemult
			angle = min(angle,25)
			angle = max(angle,-25)
		$Sprite.rotation_degrees = angle
		get_node(camera).position = position
