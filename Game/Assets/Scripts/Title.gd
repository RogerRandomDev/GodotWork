extends Node2D


##Does all title screen functions
##lets you switch between gamemodes
var gamename = ["Frog","Space","Tapp","Gnop","MashBash"]
##sets game mode
var GameType = 0
var multiplay = [0,1,4]
var cango = true
##Little Neat thing, i made the max 99, to keep with the feel of old arcade games a bit better.
var currentcoins = 0
export var volume=0
export var curgame = 0
##sets music##
func _ready():
	Input.action_release("enter")
	GlobalScene.HighScore[GlobalScene.currentgame] = 0
	##sets scoreboard##
	GlobalScene.scoreBoard[GlobalScene.currentgame].sort()
	for score in GlobalScene.scoreBoard[GlobalScene.currentgame].size():
		$ViewportContainer/Viewport/Labels/HighScores.text += "\n"+str(GlobalScene.scoreBoard[GlobalScene.currentgame][9-score])
	if !multiplay.has(GlobalScene.currentgame):
		$ViewportContainer/Viewport/Labels/PlayerCount.hide()
		GlobalScene.PlayerCount = 1
	GlobalScene.playmusic("res://Assets/Audio/"+gamename[GlobalScene.currentgame]+"/GameSong.mp3")
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
	if volume != 0:
		GlobalScene.setvolume(volume)
	if GlobalScene.inVR:
		GlobalScene.setvolume(10)
		GlobalScene.setnoise(0)
##Flips between the Current Coin count to make it flash
func _on_CoinFlash_timeout():
	$ViewportContainer/Viewport/Labels/CoinCount.visible = !$ViewportContainer/Viewport/Labels/CoinCount.visible
func _input(event):
	if str(event) == "0":
		pass
	if Input.is_action_just_pressed("insertcoin") and GlobalScene.canaddCoins:
		
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
	if Input.is_action_just_pressed("enter") && GlobalScene.coinCount > 0:
		Input.action_release("enter")
		##removes 1 coin and starts game
		GlobalScene.coinCount -= 1
		if GlobalScene.currentgame == 4:
			GlobalScene.canaddCoins = false
		##resets current score for this game##
		GlobalScene.setScore(0,"P1")
		GlobalScene.setScore(0,"P2")
# warning-ignore:return_value_discarded
		if GlobalScene.inVR:
			self.hide()
			get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene("res://Assets/Scenes/"+gamename[GlobalScene.currentgame]+"/BaseGame.tscn","no")
			GlobalScene.ingame = true
			self.queue_free()
		else:
			get_tree().change_scene("res://Assets/Scenes/"+gamename[GlobalScene.currentgame]+"/BaseGame.tscn")
			GlobalScene.ingame = true
	##changes player mode##
	if Input.is_action_just_pressed("leftP1") or Input.is_action_just_pressed("rightP1"):
		GameType = abs(GameType-1)
		GlobalScene.PlayerCount = GameType+1
		updateMode()
	Input.action_release("enter")
#updates gamemode text
func updateMode():
	if multiplay.has(GlobalScene.currentgame) and !GlobalScene.inVR:
		if GameType == 0:
			$ViewportContainer/Viewport/Labels/PlayerCount.text = "<ONE PLAYER>\nTWO PLAYERS\nA<->D"
		if GameType == 1:
			$ViewportContainer/Viewport/Labels/PlayerCount.text = "<TWO PLAYERS>\nONE PLAYER\nA<->D"
	else:
		GameType = 0
		GlobalScene.PlayerCount = 1
func start():
	cango = true
func setfree():
	self.queue_free()
