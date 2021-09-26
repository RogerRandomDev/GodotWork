extends KinematicBody2D

var run_speed = 256
var jump_speed = -544
var decelrate = 10
var acelrate = 20
var gravity = 768
var angle = 0
var velocity = Vector2.ZERO
var jumping = false
var anglemult = 1
var linepuzzle = false
export var hpbar:NodePath
export var played = false
var doublejump = false
var lastwall = -1
var offFloor = false
var airparticles = preload("res://Assets/Scenes/MashBash/airparticles.tscn")
export var camera:NodePath
var checkpoint= Vector2.ZERO
func get_input():
	if Input.is_action_just_pressed("downP1") and $dash.time_left == 0 and $dashdelay.time_left == 0:
		$dash.start()
		$dashdelay.start()
	var justjumped = false
	jumping =  Input.is_action_just_pressed("upP1")
	if jumping and !offFloor or jumping and !doublejump:
		doublejump = true
		lastwall = -1
		velocity.y = jump_speed
		justjumped = true
		if !offFloor:
			doublejump = false
		offFloor = true
		$jumpleeway.stop()
		GlobalScene.playSound0("res://Assets/Audio/MashBash/jump.wav")
		air()
	if jumping and not justjumped:
		if $left.is_colliding():
			velocity.y = jump_speed*0.975
			lastwall = 0
			velocity.x = run_speed
			GlobalScene.playSound0("res://Assets/Audio/MashBash/jump.wav")
			air()
		if $right.is_colliding():
			velocity.y = jump_speed*0.975
			lastwall = 1
			velocity.x = -run_speed
			GlobalScene.playSound0("res://Assets/Audio/MashBash/jump.wav")
			air()
	if lastwall == -1:
		velocity.x += (int(Input.is_action_pressed("rightP1"))-int(Input.is_action_pressed("leftP1")))*run_speed*acelrate*get_physics_process_delta_time()/max((0.75-$dash.time_left),0.125)
	else:
		velocity.x += (int(Input.is_action_pressed("rightP1"))-int(Input.is_action_pressed("leftP1")))*run_speed*acelrate*get_physics_process_delta_time()*0.0675
	if $dash.time_left>0:
		velocity.x = min(abs(velocity.x),run_speed/max((0.75-$dash.time_left),0.25))*sign(velocity.x)
		
	else:
		velocity.x = min(abs(velocity.x),run_speed)*sign(velocity.x)
	if is_on_floor():
		lastwall = -1
		doublejump = false

func _physics_process(delta):
	if played:
		if is_on_floor():
			if Input.is_action_pressed("leftP1") or Input.is_action_pressed("rightP1"):
				$walkparticles.emitting = true
			else:
				$walkparticles.emitting = false
			velocity.x -= velocity.x*delta*decelrate
			offFloor = false
		else:
			$walkparticles.emitting = false
			if not offFloor and $jumpleeway.is_stopped():
				$jumpleeway.start()
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
##loads air particles:
func air():
	var newair = airparticles.instance()
	add_child(newair)
	newair.position = Vector2(0,16)


func _on_jumpleeway_timeout():
	offFloor = true
func _ready():
	checkpoint = position
func rtc():
	if $Timer.is_stopped():
		visible = false
		played = false
		GlobalScene.health[0] -= 1
		get_node(hpbar).value = GlobalScene.health[0]
		if GlobalScene.health[0] == 0:
			GlobalScene.gameover("P1")
		var death = load("res://Assets/Scenes/MashBash/entities/deathparticles.tscn").instance()
		get_parent().add_child(death)
		death.position = position
		$Timer.start()


func _on_Timer_timeout():
	visible = true
	played = true
	position = checkpoint
	get_node(hpbar).value = GlobalScene.health[0]
	velocity = Vector2.ZERO
