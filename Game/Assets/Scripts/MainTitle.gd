extends Node2D


##Does all title screen functions
##sets game mode
var GameType = 0
var gamename = ["Frog","Space","Tapp","Gnop","MashBash"]
##Little Neat thing, i made the max 99, to keep with the feel of old arcade games a bit better.
var currentcoins = 0
##sets up start##
func _ready():
	GlobalScene.currentgame = 0
	GlobalScene.scoreBoard[GlobalScene.currentgame].sort()
	var highscore = 0
	for score in GlobalScene.scoreBoard[GlobalScene.currentgame]:
		if score > highscore:
			highscore=score
	$ViewportContainer/Viewport/Labels/HighScore.text = "HighScore:\n"+str(highscore)
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
	if Input.is_key_pressed(KEY_ENTER):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Assets/Scenes/"+gamename[GameType]+"/Title.tscn")
	##changes player mode##
	if Input.is_action_just_pressed("leftP1"):
		GameType = GameType-1
		if GameType < 0:
			GameType = 4
		updatemode()
	if Input.is_action_just_pressed("rightP1"):
		GameType = GameType+1
		if GameType > 4:
			GameType = 0
		updatemode()
	GlobalScene.currentgame = GameType
#updates gamemode text
func updatemode():
	$ViewportContainer/Viewport/Labels/CurrentGame.text = gamename[GameType]
	$ViewportContainer/Viewport/Labels/HighScore.text = "HighScore:\n"+str(GlobalScene.HighScore[GameType])
	pass
