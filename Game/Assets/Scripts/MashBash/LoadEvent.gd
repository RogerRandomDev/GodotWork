extends VisibilityNotifier2D

export var eventType:String

export var eventID:int
func _on_EventTrigger_screen_entered():
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
