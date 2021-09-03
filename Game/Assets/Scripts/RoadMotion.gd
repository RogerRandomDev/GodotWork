extends Path2D



var currentCars = [0,0,0,0,0]
export var movespeed = 0.25
## movement variables to store car positions and direction of motion
var moving = true
var carprogress = [0,0,0,0,0]
export var carDir = 0
export var carLength = [1,1]
##sets speed of motion
func _ready():
	$Carmotion.wait_time = movespeed
	if carDir == 1:
		for car in get_children():
			if car.get_child_count() != 0:
				car.get_child(0).flip_h = true
			pass
	randomize()
func _process(delta):
	for car in currentCars.size():
		if currentCars[car]==1:
			carprogress[car] += delta*movespeed
			if carprogress[car] >= 1:
				currentCars[car] = 0
				carprogress[car] = 0
			get_child(car).unit_offset=abs(carDir-carprogress[car])
	pass

var carpos = 0
func _on_Carmotion_timeout():
	$Carmotion.wait_time = rand_range(1/movespeed/2,1/movespeed+0.5)
	$Carmotion.start()
	carpos = currentCars.find(0)
	if carpos != -1:
			currentCars[carpos] = 1
			get_child(carpos).scale.x = round(rand_range(carLength[0],carLength[1]))


func _on_Area2D_body_entered(body):
	if body.name =="Player":
		GlobalData.gameover()
