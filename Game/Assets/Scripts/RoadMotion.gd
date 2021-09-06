extends Path2D



var currentCars = [0,0,0,0,0]
export var movespeed = 0.25
## movement variables to store car positions and direction of motion
var moving = true
var carprogress = [0,0,0,0,0]
export var carDir = 0
export var carLength = [1,2]
##placeholder to set texture position and size for now##
var carData = [
[[38,1,16,7],[59,1,16,7],[80,1,16,7],[101,1,16,7]],
[[1,1,32,7]],
]
var carCounts = [3,0]
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
	carpos = currentCars.find(0)
	if carpos != -1:
			currentCars[carpos] = 1
##car size setter as of now
			var carSize = round(rand_range(carLength[0],carLength[1]))
			var currentCar = round(rand_range(0,carCounts[carSize-1]-1))
			get_child(carpos).get_child(1).scale.x = carSize
##sets extents(TEMPORARY) this is being used while using the frogger textures i got from the atari 2600
			get_child(carpos).get_child(0).region_rect = Rect2(carData[carSize-1][currentCar][0],
carData[carSize-1][currentCar][1],
carData[carSize-1][currentCar][2],
carData[carSize-1][currentCar][3])


func _on_Area2D_body_entered(body):
	if body.name =="Player":
		GlobalData.gameover()
