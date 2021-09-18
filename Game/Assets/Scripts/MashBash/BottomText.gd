extends Label

var currentset = 0
var currenttext = 0
export var currenttextset = 0
var file = File.new()

func _ready():
	file.open("res://Assets/Scripts/MashBash/AItext.tres",File.READ)
	text = file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset]


func loadText():
	currenttext = 0
	$Timer.start()


func _on_Timer_timeout():
	currenttext +=1
	visible_characters = currenttext
	if visible_characters == get_total_character_count():
		$doneload.start()


func _on_doneload_timeout():
	currenttextset +=1
	visible_characters = 0
	loadText()
	var newtext =file.get_as_text().split("newset")[currentset].split("(newline)")[currenttextset]
	text = newtext
	if newtext.find('......ended') != -1:
		$Timer.stop()
