extends Node2D


##Does all title screen functions
##sets game mode
var GameType = 0
var gamename = ["Frog","Space","Tapp","Gnop","MashBash"]
##Little Neat thing, i made the max 99, to keep with the feel of old arcade games a bit better.
var currentcoins = 0
##sets up start##
func _ready():
	GlobalScene.ingame = false
	Input.action_release("escape")
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
func _input(event):
	if str(event) == "0":
		pass
	if Input.is_action_pressed("insertcoin"):
		
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
	if Input.is_action_just_pressed("enter"):
# warning-ignore:return_value_discarded
		Input.action_release("enter")
		if GlobalScene.inVR:
			get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene("res://Assets/Scenes/"+gamename[GameType]+"/Title.tscn")
			GlobalScene.ingame = true
			self.queue_free()
			pass
		if not GlobalScene.inVR:
			get_tree().change_scene("res://Assets/Scenes/"+gamename[GameType]+"/Title.tscn")
			GlobalScene.ingame = true
	##changes player mode##
	if Input.is_action_just_pressed("leftP1"):
		GameType = GameType-1
		if GameType < 0:
			GameType = 4
		updatemode()
		Input.action_release("leftP1")
	if Input.is_action_just_pressed("rightP1"):
		GameType = GameType+1
		if GameType > 4:
			GameType = 0
		Input.action_release("rightP1")
		updatemode()
	GlobalScene.currentgame = GameType

#updates gamemode text
func updatemode():
	$ViewportContainer/Viewport/Labels/CurrentGame.text = gamename[GameType]
	$ViewportContainer/Viewport/Labels/HighScore.text = "HighScore:\n"+str(GlobalScene.HighScore[GameType])
	if GameType == 4:
		$ViewportContainer/Viewport/Labels/MashBash.show()
	else:
		$ViewportContainer/Viewport/Labels/MashBash.hide()
func setfree():
	self.queue_free()
