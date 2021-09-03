extends Path2D



var currentCars = [0,0,0,0,0]
export var movespeed = 0.25
## movement variables to store car positions and direction of motion
var moving = true
var carprogress = [0,0,0,0,0]
export var carDir = 0

##sets speed of motion
func _ready():
	$Carmotion.wait_time = movespeed
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
	$Carmotion.wait_time = rand_range(movespeed+0.25,movespeed+2.5)
	$Carmotion.start()
	carpos = currentCars.find(0)
	if carpos != -1:
			currentCars[carpos] = 1
