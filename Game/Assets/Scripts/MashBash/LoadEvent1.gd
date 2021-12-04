extends Area2D

export (Array,Array) var eventDATA
var player:NodePath
func _on_Area2D_body_entered(body):
	if body.name =="Player":
		player = body.get_path()
		trigger()
func trigger():
	var havedone = true
	for event in eventDATA:
		if get_tree().get_nodes_in_group("BottomText")[0].canchange and event[0]=="AI.TEXT":
			get_tree().get_nodes_in_group("BottomText")[0].currentset = event[1]
			get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
			get_tree().get_nodes_in_group("BottomText")[0].prepText()
			get_tree().get_nodes_in_group("BottomText")[0].loadText()
			if event.size() > 2:eventDATA.remove(eventDATA.find(event))
		elif event[0]=="AI.TEXT":
			havedone = false
			if event.size() <= 2:$Timer.start()
		#Tile change events##
		match event[0]:
			"REMOVE.TILE":
				if havedone:
					for pos in event[1]:
						get_tree().get_nodes_in_group("map")[0].set_cellv(pos,-1)
			"CHANGE.TILE":
				if havedone:
					get_tree().get_nodes_in_group("BottomText")[0].removeCellLine = event[2]
					get_tree().get_nodes_in_group("BottomText")[0].removeCells = event[1]
			"CHANGE.TILE.NOW":
				for pos in event[1]:
					get_tree().get_nodes_in_group("map")[0].set_cellv(Vector2(pos.x,pos.y),pos.z)
			##level change##
			"CHANGE.LEVEL":
# warning-ignore:return_value_discarded
				if GlobalScene.inVR:
					get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene(event[1])
					self.queue_free()
				if not GlobalScene.inVR:
					get_tree().change_scene(event[1])
		#checkpoint and return to checkpoint##
			"CHECKPOINT":
				get_node(player).checkpoint = get_node(player).position
			"R.T.C":
				get_node(player).rtc()
				if !GlobalScene.havedied:
					deathmessage()
				havedone = false
		#remove other events#
			"REMOVE.EVENT":
				get_node(event[1]).queue_free()
		#toggle#
			"TOGGLE":
				get_node(event[1]).toggled = !get_node(event[1]).toggled
				havedone = false
	if havedone:
		queue_free()
func _on_Timer_timeout():
	trigger()


func deathmessage():
	if get_tree().get_nodes_in_group("BottomText")[0].canchange:
		get_tree().get_nodes_in_group("BottomText")[0].currentset = 13
		get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
		get_tree().get_nodes_in_group("BottomText")[0].prepText()
		get_tree().get_nodes_in_group("BottomText")[0].loadText()
		GlobalScene.havedied = true


func _on_LoadEvent_body_exited(body):
	if body.name =="Player":
		player = body.get_path()
		for event in eventDATA:if event[0]=="TOGGLE":
			get_node(event[1]).toggled = !get_node(event[1]).toggled
