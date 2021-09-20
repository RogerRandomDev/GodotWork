extends Label

var currentset = 0
var currenttext = 0
export var currenttextset = 0
var file = File.new()
var canchange = false
export var faceanims:NodePath
var map
func _ready():
	file.open("res://Assets/Scripts/MashBash/AItext.tres",File.READ)
	text = file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset].split("(curface)")[0]
	get_node(faceanims).play(file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset].split("(curface)")[1])

func prepText():
	if currentset == 0:
		map = get_tree().get_nodes_in_group("map")[0].get_path()
	$doneload.stop()
	text = file.get_as_text().split("(newset)")[currentset].split("(newline)")[currenttextset].split("(curface)")[0]
	get_node(faceanims).play(file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset].split("(curface)")[1])
	canchange = false
	loadText()
func loadText():
	currenttext = 0
	$Timer.start()
	$Face.show()
	get_parent().show()


func _on_Timer_timeout():
	currenttext +=1
	visible_characters = currenttext
	if visible_characters == get_total_character_count():
		$doneload.start()
	if visible_characters <= get_total_character_count():
		GlobalScene.playSound2('res://Assets/Audio/MashBash/speech.wav')


func _on_doneload_timeout():
	currenttextset +=1
	visible_characters = 0
	loadText()
	var newtext =file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset]
	text = newtext.split("(curface)")[0]
	if newtext.find('......ended') != -1:
		$Timer.stop()
		$Face.hide()
		get_parent().hide()
		canchange = true
		if currentset == 0:
			get_node(map).set_cellv(Vector2(61,8),-1)
	else:
		get_node(faceanims).play(newtext.split("(curface)")[1])
