extends Node

##allows you to disable the shader
var shaderOFF = false
##sets currentgame##
var currentgame = 0
##stores score and HighScore##
var Score = [[0,0],[0,0],[0,0],[0,0],[0,0]]
var HighScore = [0,0,0,0,0]
var PlayerCount = 1
##Coins in at the moment##
var coinCount = 0
##allows you to survive for 5 seconds after respawing##
var canDie = true
var cancontinue = true
var timerleft = 0
##converts player ID to the label for the score##
const pID = {"P1":0,"P2":1,"CPU":1}
##Modulation colors to allow for more variety by just changing pallette essentially between the values##
const ColorValues = [Color8(136,0,0,255),Color8(48,32,152,255),Color8(120,0,92,255),Color8(208,208,80,255)]
##to prevent errors##
var placeholder
##Randomizes random function##
func _ready():
	randomize()

##Allows you to insert more coins during the game as wanted##
func _unhandled_key_input(event):
	if str(event) == "0":
		pass
	if Input.is_key_pressed(KEY_E):
	##increments coins by 1 and sets text of coin count to it and a space with COINS after it
		coinCount+=1
	##plays coin sound when coins are less then 100 when you insert one##
		if coinCount != 100:
			$CoinSound.play(0.0)
	##sets max to 99, because I specifically remember this from these kinds of games
		coinCount = min(coinCount,99)
	##sets visible coins on normal game level##
		if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
			get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(coinCount)
	
	##Lets you disable the shaders
	if Input.is_key_pressed(KEY_TAB):
		GlobalScene.shaderOFF = !GlobalScene.shaderOFF
		get_tree().get_nodes_in_group("SHADER")[0].visible = !GlobalScene.shaderOFF
	##lets you restart so long as coins are in the game##
	if Input.is_key_pressed(KEY_ENTER) && get_tree().paused:
		if coinCount > 0 && cancontinue:
			coinCount-=1
			$CoinSound.play(0.0)
			get_tree().get_nodes_in_group("ENDSCREEN")[0].hide()
			get_tree().paused=false
			$RespawnTimer.start()
			canDie = false
		if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
			get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(coinCount)
		$EndTimer.stop()
		if PlayerCount == 2:
			canDie = true
			PlayerCount = 1
			placeholder = get_tree().change_scene("res://Assets/Scenes/Frog/Title.tscn")
	if Input.is_key_pressed(KEY_ESCAPE):
		canDie = true
		get_tree().paused = false
		$EndTimer.stop()
		$Music.playing = false
		PlayerCount = 1
		get_tree().change_scene("res://Assets/Scenes/MainTitle.tscn")
##sets scoreboard and highscore##
func setScore(value,ID):
	Score[currentgame][pID[ID]]=value
##gets the scoreboard node, and then gets the scoreboard label for the current ID##
	for ScoreList in get_tree().get_nodes_in_group("ScoreBoard")[0].get_children():
		if ScoreList.name=="Score"+str(pID[ID]):
			ScoreList.text = "Score:" + str(value)
##highscore setter##
###currently hidden and not visible, will work on where to place high score later##
	if value > HighScore[currentgame]:
		HighScore[currentgame] = Score[currentgame][pID[ID]]
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(PlayerCount).text = "HighScore:\n" + str(value)

###
##Need to add functionality here, preferrable a screen prompting you to continue for 1 Coin
##Best if it provides high score here as well to give them a sense of progression##

##Choice rejected for now, no high score to be shown, but there is an end screen
##That prompts you to continue on single player, on two player, it just says who won
##and lets you return to the menu##
###
func gameover(x):
	##only allows death if you can die, and decides if it is single or double player##
	if canDie && PlayerCount!=2:
		get_tree().get_nodes_in_group("ENDSCREEN")[0].show()
		$EndTimer.start()
		get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(2).text = str(10)
		timerleft = 10
		get_tree().paused = true
		canDie = false
	elif PlayerCount==2:
		get_tree().paused = true
		get_tree().get_nodes_in_group("WINSCREEN")[0].show()
		get_tree().get_nodes_in_group("WINSCREEN")[0].get_child(0).text = "-----------\nGAME OVER\n-----------\nPLAYER "+str(abs(1-pID[x])+1)+"\nWINS"
##gameover where you cant continue##
func trueover(x):
	if PlayerCount!=2:
		get_tree().get_nodes_in_group("ENDSCREEN")[0].show()
		$EndTimer.start()
		get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(2).text = str(10)
		get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(0).text = "-----------\nGAME OVER\n-----------\n"
		timerleft = 10
		cancontinue = false
		get_tree().paused = true
		canDie = false
	elif PlayerCount==2:
		get_tree().paused = true
		get_tree().get_nodes_in_group("WINSCREEN")[0].show()
		get_tree().get_nodes_in_group("WINSCREEN")[0].get_child(0).text = "-----------\nGAME OVER\n-----------\nPLAYER "+str(abs(1-pID[x])+1)+"\nWINS"
	pass
##randomly selects color to return from pallette above##
func randColor():
	return ColorValues[round(rand_range(0,ColorValues.size()-1))]

##plays movement sound##
func playmove():
	$MoveSound.play(0.0)

##ends invulnerability time##
func _on_RespawnTimer_timeout():
	canDie = true

##Updates timer on endscreen for the time left
func _on_EndTimer_timeout():
	if timerleft != 0:
		timerleft-=1
		$EndTimer.start()
		get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(2).text = str(timerleft)
	else:
		get_tree().paused=false
		canDie=true
		PlayerCount = 1
		placeholder = get_tree().change_scene("res://Assets/Scenes/Frog/Title.tscn")
##sets music to play##
func playmusic(music):
	$Music.stream = load(music)
	$Music.play(0.0)
func stopmusic():
	$Music.stop()
