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
		$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.canchange = true
	if GlobalScene.inVR:
		$MashBash.rect_scale = Vector2(1,1)
	if havemash:
		$MashBashAnim.play("MASHBASH boot")
	var Map = get_tree().get_nodes_in_group("map")[0].get_parent()
	remove_child(Map)
	$P1/Viewport.add_child(Map)
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
		
		GlobalScene.stopmusic()
	else:
		GlobalScene.playmusic("res://Assets/Audio/MashBash/MashBashSong0.mp3")
func setmusic(music):
	GlobalScene.playmusic(music)
	GlobalScene.stopmusic()
func stop():
	GlobalScene.stopmusic()


# warning-ignore:unused_argument
func _on_MashBashAnim_animation_finished(anim_name):
	$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.currenttextset = 0
	$P1/Viewport/Camera2D/Node2D/TextBox/BottomText.prepText()
	$P1.visible=true
	$MashBash.visible = false
	resetmusic()


func _on_MashBashAnim_animation_started(anim_name):
	stop()
