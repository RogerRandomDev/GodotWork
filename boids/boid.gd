extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var following = self
var direction = Vector2.ZERO
var followers = []
var move_dir = Vector2.ZERO
var followMouse = true
var move_direction = Vector2.ZERO
var target_pos = Vector2.ZERO
var can_follow = true
var leader_count = 5
var move_to = Vector2.ZERO
export var visible_angle = 60
export var ray_count = 32
func _ready():
	for rayn in ray_count:
		var ray = RayCast2D.new()
		ray.cast_to = Vector2(0,-24)
		$rays.add_child(ray)
		ray.enabled = true
		ray.rotation_degrees = visible_angle-rayn*((visible_angle*2)/ray_count)
	$Node2D.color = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1),1)
func _physics_process(delta):
	var cur_direction = Vector2.ZERO
	for ray in $rays.get_children():
		if !ray.is_colliding():continue
		var body = ray.get_collider()
		if !body.is_in_group("boid"):continue
		cur_direction -= (body.position-position)
	var prev_rot = rotation
	direction = cur_direction.normalized()
	if cur_direction.length() < 4:direction = (get_parent().move_to-position).normalized()
	rotation = lerp_angle(prev_rot,atan2(direction.y,direction.x)+PI/2,delta*3)
func _process(delta):
	move_direction = Vector2(cos(rotation-PI/2),sin(rotation-PI/2))
	position += move_direction
	if position.y < 0 or position.y > 600:
		position.y =int(position.y < 0)*600
	if position.x < 0 or position.x > 1024:
		position.x =int(position.x < 0) * 1024
