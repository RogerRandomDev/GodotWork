extends Area2D

export (Array,Array) var eventDATA

func _on_Area2D_body_entered(body):
	if body.name =="Player":
		trigger()

func trigger():
	var havedone = true
	for event in eventDATA:
		if get_tree().get_nodes_in_group("BottomText")[0].canchange and event[0]=="AI.TEXT":
				get_tree().get_nodes_in_group("BottomText")[0].currentset = event[1]
				get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
				get_tree().get_nodes_in_group("BottomText")[0].prepText()
				get_tree().get_nodes_in_group("BottomText")[0].loadText()
		elif event[0]=="AI.TEXT":
			havedone = false
			$Timer.start()
		if event[0]=="REMOVE.TILE" and havedone:
			for pos in event[1]:
				get_tree().get_nodes_in_group("map")[0].set_cellv(pos,-1)
		if event[0]=="CHANGE.TILE" and havedone:
			for pos in event[1]:
				get_tree().get_nodes_in_group("map")[0].set_cellv(Vector2(pos.x,pos.y),pos.z)
		if event[0]=="CHANGE.LEVEL":
# warning-ignore:return_value_discarded
			get_tree().change_scene(event[1])
	if havedone:
		queue_free()
func _on_Timer_timeout():
	trigger()



