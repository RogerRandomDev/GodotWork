extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var boid_count = 0
const boids = preload("res://boid.tscn")
var move_to = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	for boid in boid_count:
		var new_boid = boids.instance()
		add_child(new_boid)
		new_boid.position = Vector2(512+rand_range(-50,50),300+rand_range(-50,50))
func _input(event):
	if Input.is_mouse_button_pressed(1):
		move_to = get_local_mouse_position()
		$Sprite.position = get_local_mouse_position()
