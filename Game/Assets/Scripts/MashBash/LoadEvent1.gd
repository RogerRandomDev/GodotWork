extends Area2D
export var eventType:String

export var eventID:int

func _on_Area2D_body_entered(body):
	if body.name =="Player":
		trigger()

func trigger():
	if get_tree().get_nodes_in_group("BottomText")[0].canchange:
		if eventType=="AI.TEXT":
			get_tree().get_nodes_in_group("BottomText")[0].currentset = eventID
			get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
			get_tree().get_nodes_in_group("BottomText")[0].prepText()
			get_tree().get_nodes_in_group("BottomText")[0].loadText()
			queue_free()
	else:
		$Timer.start()


func _on_Timer_timeout():
	trigger()



