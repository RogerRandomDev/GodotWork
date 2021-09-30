extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var follow:NodePath

var hoverDir=Vector2.ZERO
var hoverForce = 48
var hoverTime=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	hoverDir = (position-get_node(follow).position+Vector2(0,48))*5
	hoverDir.y += hoverForce*sin(hoverTime*PI)
	if hoverTime >= 1: hoverTime = 0
	hoverTime+=delta
# warning-ignore:return_value_discarded
	move_and_collide(-hoverDir*delta)
