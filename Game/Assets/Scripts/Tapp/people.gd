extends Node2D



var item = preload("res://Assets/Scenes/Tapp/Item.tscn")
var persons = preload("res://Assets/Scenes/Tapp/person.tscn")
var score = 0
func _ready():
	randomize()
##places item down##
func placeItem():
	var newItem = item.instance()
	$Bar/SlidePath.add_child(newItem)
	newItem.position = Vector2.ZERO

##places people down as time goes on##
#i plan on using score to decide ratherdd than a set value#
func _on_personsTimer_timeout():

	if rand_range(0.0,1.0) > 0.8:
		var canplace = true
		for child in $Persons.get_children():
			if child.unit_offset < 0.0575:
				canplace = false
		if canplace:
			var newPerson = persons.instance()
			$Persons.add_child(newPerson)
			#i should change the person angertimer as score goes up#
			newPerson.get_child(2).wait_time = 5
			newPerson.position = Vector2.ZERO
			newPerson.unit_offset = 0.05
	$personsTimer.wait_time = min(max(0.25,1.0/(sqrt(GlobalScene.Score[2][0]/5000)+0.1)),2.5)


func _on_BarrelArea_body_entered(body):
	if body.name =="Player":
		body.currentLine = self.get_path()
