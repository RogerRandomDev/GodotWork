extends Area2D

export var startpoint = false
export var final = false
export var start:NodePath
var cando = true
export (Array,Array) var finalevent
func _on_LinePuzzle_body_entered(body):
	if body.name == "Player":
		if !body.linepuzzle and startpoint and cando:
			body.linepuzzle = true
			var line = load("res://Assets/Scenes/MashBash/line.tscn").instance()
			get_parent().add_child(line)
			line.player = body.get_path()
			line.position = position
			line.points[0] = Vector2(-56*sin(-rotation),-56*cos(-rotation))
			line.prevpoints.append(get_path())
		elif body.linepuzzle:
			if final and get_tree().get_nodes_in_group("LinePuzzle")[0].default_color != Color.red:
				var line = get_tree().get_nodes_in_group("LinePuzzle")[0].get_path()
				body.linepuzzle = false
				get_node(line).addpoint(position-Vector2(56*sin(-rotation),56*cos(-rotation)))
				get_node(line).done=true
				get_node(start).cando = false
				trigger()
			elif !get_tree().get_nodes_in_group("LinePuzzle")[0].prevpoints.has(get_path()) and !startpoint and get_tree().get_nodes_in_group("LinePuzzle")[0].default_color != Color.red:
				var line = get_tree().get_nodes_in_group("LinePuzzle")[0].get_path()
				get_node(line).addpoint(position-Vector2(56*sin(-rotation),56*cos(-rotation)))
				get_node(line).prevpoints.append(get_path())
func trigger():
	var havedone = true
	for event in finalevent:
		if get_tree().get_nodes_in_group("BottomText")[0].canchange and event[0]=="AI.TEXT":
				get_tree().get_nodes_in_group("BottomText")[0].currentset = event[1]
				get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
				get_tree().get_nodes_in_group("BottomText")[0].prepText()
				get_tree().get_nodes_in_group("BottomText")[0].loadText()
				if event.size() > 2:
					finalevent.remove(finalevent.find(event))
					
		elif event[0]=="AI.TEXT":
			havedone = false
			if event.size() <= 2:
				$Timer.start()
		#Tile change events##
		if event[0]=="REMOVE.TILE" and havedone:
			for pos in event[1]:
				get_tree().get_nodes_in_group("map")[0].set_cellv(pos,-1)
		if event[0]=="CHANGE.TILE" and havedone:
			get_tree().get_nodes_in_group("BottomText")[0].removeCellLine = event[2]
			get_tree().get_nodes_in_group("BottomText")[0].removeCells = event[1]
		if event[0]=="CHANGE.TILE.NOW":
			for pos in event[1]:
				get_tree().get_nodes_in_group("map")[0].set_cellv(Vector2(pos.x,pos.y),pos.z)
		#remove other events#
		if event[0]=="REMOVE.EVENT":
			get_node(event[1]).queue_free()
	if havedone:
		$Timer.stop()
		set_process(false)
		set_process_internal(false)
		disconnect("body_entered",self,"_on_LinePuzzle_body_entered")


func _on_Timer_timeout():
	trigger()
