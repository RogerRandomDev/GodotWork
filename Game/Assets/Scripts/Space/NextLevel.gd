extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentlevel = 1

##pauses and shows the level complete, then waits till it does the next part
func nextLevel():
	get_tree().paused=true
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
		get_tree().paused = false
