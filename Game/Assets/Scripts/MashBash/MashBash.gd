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
##sets up player view based on player count##
func _ready():
	##allows you to disable the shader##
	if GlobalScene.shaderOFF:
		$Shader.hide()
	##sets BIOS text##
	var file = File.new()
	file.open("res://Assets/Scripts/MashBash/MashBash.tres",File.READ)
	$MashBash/Viewport/RichTextLabel.text=file.get_as_text()
	$MashBashAnim.play("MASHBASH boot")
	GlobalScene.stopmusic()
	var Map = get_tree().get_nodes_in_group("map")[0].get_parent()
	remove_child(Map)
	$P1/Viewport.add_child(Map)
func resetmusic():
	GlobalScene.playmusic("res://Assets/Audio/MashBash/GameSong.mp3")
