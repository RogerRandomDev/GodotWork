extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentlevel = 1
var sceneload:NodePath
##pauses and shows the level complete, then waits till it does the next part
func nextLevel():
	GlobalScene.unpausable = false
	show()
	$Label.text = "LEVEL COMPLETE"
	currentlevel += 1
	$leveltimer.start()

##shows current level you are on and then unpauses game
func _on_leveltimer_timeout():
	if $Label.text != "LEVEL "+str(currentlevel):
		$Label.text = "LEVEL "+str(currentlevel)
		$leveltimer.start()
	else:
		hide()
		GlobalScene.unpausable = true
		get_node(sceneload).add_child(load("res://Assets/Scenes/Space/Levels/level1.tscn").instance())
