extends Path2D



var currentCars = [0,0,0,0,0]
export var movespeed = 0.25
## movement variables to store car positions and direction of motion
var moving = true
var carprogress = [0,0,0,0,0]
export var carDir = 0
export var carLength = [1,1]

###
##placeholder to set texture position and size for now##
##no longer placeholder, has been modified to suit its purpose permanently,
##or until better method is though of.
###
var carData = [
[[0,0,8,7],[9,0,8,7],[0,8,8,7],[9,8,8,7]],
[[1,1,32,7]],
]
var carCounts = [3,0]
##sets speed of motion
func _ready():
	$Carmotion.wait_time = movespeed
	if carDir == 0:
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
###
##Leaving last comment aside, I set up my own textures in the style, and am using it in the same manner
##as before, since it has proved to be rather effective at what it is meant to do.
###
			get_child(carpos).get_child(0).region_rect = Rect2(carData[carSize-1][currentCar][0],
carData[carSize-1][currentCar][1],
carData[carSize-1][currentCar][2],
carData[carSize-1][currentCar][3])
##sets color to one of the colors in the GlobalScene color pallette i've set up##
			get_child(carpos).get_child(0).modulate = GlobalScene.randColor()

func _on_Area2D_body_entered(body):
	if body.name =="Player":
		GlobalScene.gameover()
