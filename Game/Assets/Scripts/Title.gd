extends Node2D


##Does all title screen functions
##lets you switch between gamemodes
var gamename = ["Frog","Space","test2","test3","test4"]
##sets game mode
var GameType = 0
##Little Neat thing, i made the max 99, to keep with the feel of old arcade games a bit better.
var currentcoins = 0
##sets music##
func _ready():
	#GlobalScene.playmusic("res://Assets/Audio/Frog/GameSong.mp3")
	if GlobalScene.coinCount != 0:
		currentcoins = GlobalScene.coinCount
				
		##shows that the player can now start the game##
		$ViewportContainer/Viewport/Labels/Play.show()
		##puts zero before the text when the number is less than 10
		if currentcoins < 10:
			$ViewportContainer/Viewport/Labels/CoinCount.text = "0"
		else:
			$ViewportContainer/Viewport/Labels/CoinCount.text = ""
		$ViewportContainer/Viewport/Labels/CoinCount.text += str(currentcoins) +" COINS"
		##Makes coincount visible
		$ViewportContainer/Viewport/Labels/CoinCount.visible = true
		##Resets the flashing to keep it smoother
		$CoinFlash.stop()
		$CoinFlash.start()
	pass
##Flips between the Current Coin count to make it flash
func _on_CoinFlash_timeout():
	$ViewportContainer/Viewport/Labels/CoinCount.visible = !$ViewportContainer/Viewport/Labels/CoinCount.visible
func _unhandled_key_input(event):
	if str(event) == "0":
		pass
	if Input.is_key_pressed(KEY_E):
		
		##shows that the player can now start the game##
		$ViewportContainer/Viewport/Labels/Play.show()
		currentcoins = min(GlobalScene.coinCount+1,99)
		
		##puts zero before the text when the number is less than 10
		if currentcoins < 10:
			$ViewportContainer/Viewport/Labels/CoinCount.text = "0"
		else:
			$ViewportContainer/Viewport/Labels/CoinCount.text = ""
		$ViewportContainer/Viewport/Labels/CoinCount.text += str(currentcoins) +" COINS"
		##Makes coincount visible
		$ViewportContainer/Viewport/Labels/CoinCount.visible = true
		##Resets the flashing to keep it smoother
		$CoinFlash.stop()
		$CoinFlash.start()
	if Input.is_key_pressed(KEY_ENTER) && currentcoins > 0:
		##removes 1 coin and starts game
		GlobalScene.coinCount -= 1
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Assets/Scenes/"+gamename[GlobalScene.currentgame]+"/BaseGame.tscn")
	##changes player mode##
	if Input.is_action_just_pressed("leftP1") or Input.is_action_just_pressed("rightP1"):
		GameType = abs(GameType-1)
		GlobalScene.PlayerCount = GameType+1
		updateMode()
#updates gamemode text
func updateMode():
	if GameType == 0:
		$ViewportContainer/Viewport/Labels/PlayerCount.text = "<ONE PLAYER>\nTWO PLAYERS\nA<->D"
	if GameType == 1:
		$ViewportContainer/Viewport/Labels/PlayerCount.text = "<TWO PLAYERS>\nONE PLAYER\nA<->D"
