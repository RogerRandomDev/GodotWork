extends Node2D

####################################################################################
#  ___ ___   _______   _______   ___ ___   _______    _______   _______   ___ ___  #
# |   Y   | |   _   | |   _   | |   Y   | |   _   \  |   _   | |   _   | |   Y   | #
# |.      | |.  1   | |   1___| |.  1   | |.  1   /  |.  1   | |   1___| |.  1   | #
# |. \_/  | |.  _   | |____   | |.  _   | |.  _   \  |.  _   | |____   | |.  _   | #
# |:  |   | |:  |   | |:  1   | |:  |   | |:  1    \ |:  |   | |:  1   | |:  |   | #
# |::.|:. | |::.|:. | |::.. . | |::.|:. | |::.. .  / |::.|:. | |::.. . | |::.|:. | #
# `--- ---' `--- ---' `-------' `--- ---' `-------'  `--- ---' `-------' `--- ---' #
####################################################################################

##number of active players##
export var PlayerCount = 1
const changegame = [0,1]
const alwaysmult = [3]
export var mashbash:NodePath
export var newSong:String
export var havemash = false
var reset = false
##sets up player view based on player count##
func _ready():
	Input.action_release("enter")
	GlobalScene.currentgame = 4
	GlobalScene.coinCount = 99999
	if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
		get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(GlobalScene.coinCount)
	##sets BIOS text##
	var file = File.new()
	if get_node_or_null(mashbash) != null:
		file.open("res://Assets/Scripts/MashBash/MashBash.tres",File.READ)
		$MashBash/Viewport/RichTextLabel.text=file.get_as_text()
		
	else:
		#allows the text to be changed
		$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.canchange = true
	if GlobalScene.inVR:
		#vr mode
		$MashBash.rect_scale = Vector2(1,1)
	if havemash:
		#plays the boot animation
		$MashBashAnim.play("MASHBASH boot")
	var Map = get_tree().get_nodes_in_group("map")[0].get_parent()
	#moves map to viewport, kept out otherwise so i can actually make it
	remove_child(Map)
	$P1/Viewport.add_child(Map)
	#plays the music for the game
	if newSong != "":
		GlobalScene.playmusic(newSong)
		GlobalScene.stopmusic()
	else:
		GlobalScene.playmusic("res://Assets/Audio/MashBash/WellHello.mp3")
	GlobalScene.setvolume(5)
	GlobalScene.setnoise(0)
	if get_node_or_null(mashbash) != null:
		GlobalScene.stopmusic()

func resetmusic():
	if newSong != "":
		setmusic(newSong)
		
	else:
		GlobalScene.playmusic("res://Assets/Audio/MashBash/WellHello.mp3")
func setmusic(music):
	GlobalScene.playmusic(music)
	GlobalScene.stopmusic()
func stop():
	GlobalScene.stopmusic()
func _process(_delta):
	if havemash:
		if $MashBashAnim.is_playing():
			stop()
		elif !reset:
			GlobalScene.playmusic("res://Assets/Audio/MashBash/WellHello.mp3")
			reset = true

# warning-ignore:unused_argument
func _on_MashBashAnim_animation_finished(anim_name):
	$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.currenttextset = 0
	$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.prepText()
	$P1.visible=true
	$MashBash.visible = false
	resetmusic()


# warning-ignore:unused_argument
func _on_MashBashAnim_animation_started(anim_name):
	stop()

#text on the final level has more options so we can give a bit more creativity
#a few too many for normal, so i put them here to make it easier to add endings
func final_level_text():
	var set = [24,25,26,27]
	if GlobalScene.time_in_game>1800:
		get_tree().get_nodes_in_group("BottomText")[0].currentset = set[0]
	else:
		get_tree().get_nodes_in_group("BottomText")[0].currentset = set[1]
	
	if GlobalScene.triggered_annoyances >=3:
		get_tree().get_nodes_in_group("BottomText")[0].currentset = set[2]
		if GlobalScene.cake:
			get_tree().get_nodes_in_group("BottomText")[0].currentset = set[3]
	get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
	get_tree().get_nodes_in_group("BottomText")[0].prepText()
	get_tree().get_nodes_in_group("BottomText")[0].loadText()
