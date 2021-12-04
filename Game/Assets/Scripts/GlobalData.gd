extends Node

##allows you to disable the shader
var shaderOFF = false


########change this variable when not testing game so you cant close while in mashbash############333333
var testing = true
var hastalked = false
var cur_mashbash_text = 0
##sets currentgame##
var currentgame = 0
var unpausable = true
var inVR = false
##stores score and HighScore##

var Score = [[0,0],[0,0],[0,0],[0,0],[0,0]]
var HighScore = [0,0,0,0,0]
var scoreBoard = [[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0]]
var PlayerCount = 1
var gamename = ["Frog","Space","Tapp","Gnop","MashBash"]
var health = [3,3]
var pauser = "P1"
##Coins in at the moment##
var coinCount = 0
##allows you to survive for 5 seconds after respawing##
var canDie = true
var cancontinue = true
var timerleft = 0
var canaddCoins = true
##limits bullet count to 2##
var currentbullets = [0,0]
##converts player ID to the label for the score##
const pID = {"P1":0,"P2":1,"CPU":1}
var ingame = false
##Modulation colors to allow for more variety by just changing pallette essentially between the values##
const ColorValues = [Color8(136,0,0,255),
Color8(48,32,152,255),
Color8(120,0,92,255),
Color8(208,208,80,255),
Color8(15,155,15,255)]
##to prevent errors##
var placeholder
var havedied = false
##Randomizes random function##
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	loadsave()

##Allows you to insert more coins during the game as wanted##
func _input(event):
	if str(event) == "0":
		pass
	if Input.is_action_just_pressed("insertcoin") and canaddCoins:
	##increments coins by 1 and sets text of coin count to it and a space with COINS after it
		coinCount+=1
	##plays coin sound when coins are less then 100 when you insert one##
		if coinCount < 100:
			$CoinSound.play(0.0)
	##sets max to 99, because I specifically remember this from these kinds of games
		coinCount = min(coinCount,99)
		if currentgame == 4:
			coinCount = 99
	##sets visible coins on normal game level##
		if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
			get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(coinCount)
	
	##Lets you disable the shaders
	if Input.is_key_pressed(KEY_TAB) and currentgame != 4:
		GlobalScene.shaderOFF = !GlobalScene.shaderOFF
		get_tree().get_nodes_in_group("SHADER")[0].visible = !GlobalScene.shaderOFF
	##lets you restart so long as coins are in the game##
	if Input.is_action_just_pressed("enter") && get_tree().paused && unpausable:
		health[0] = 3
		health[1] = 3
		if coinCount > 0 && cancontinue:
			if  currentgame != 4:
				coinCount-=1
				canDie = false
			if get_tree().get_nodes_in_group("Spills").size() != 0:
				get_tree().get_nodes_in_group("Spills")[0].text = "SPILLED GLASSES:"+str(3-GlobalScene.health[0])+"/3"
			$CoinSound.play(0.0)
			if get_tree().get_nodes_in_group("pHealth").size() != 0:
				get_tree().get_nodes_in_group("pHealth")[pID[pauser]].text = "LIVES: "+str(health[pID[pauser]])
			get_tree().get_nodes_in_group("ENDSCREEN")[0].hide()
			get_tree().paused=false
			$RespawnTimer.start()
			$EndTimer.stop()
		if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
			get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(coinCount)
		if PlayerCount == 2:
			canDie = true
			PlayerCount = 1
			get_tree().paused=false
			setScoreBoard(HighScore[currentgame])
			if inVR:
				get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene("res://Assets/Scenes/"+gamename[currentgame]+"/Title.tscn")
				ingame = true
			else:
				placeholder = get_tree().change_scene("res://Assets/Scenes/"+gamename[currentgame]+"/Title.tscn")
				ingame = true
			$EndTimer.stop()
	if Input.is_action_just_pressed("escape") and currentgame != 4:
		canDie = true
		health = [3,3]
		get_tree().paused = false
		$EndTimer.stop()
		$Music.playing = false
		PlayerCount = 1
		setScoreBoard(HighScore[currentgame])
		if inVR:
				get_tree().get_nodes_in_group("VIEWPORT")[0].get_child(0).setfree()
				get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene("res://Assets/Scenes/MainTitle.tscn")
				ingame = false
		if !inVR:
			placeholder = get_tree().change_scene("res://Assets/Scenes/MainTitle.tscn")
			ingame = false
	if Input.is_action_just_pressed("escape") and currentgame == 4 and get_tree().get_nodes_in_group("BottomText").size() > 0:
			if get_tree().get_nodes_in_group("BottomText")[0].canchange:
				get_tree().get_nodes_in_group("BottomText")[0].currentset = 7
				get_tree().get_nodes_in_group("BottomText")[0].currenttextset = 0
				get_tree().get_nodes_in_group("BottomText")[0].prepText()
				get_tree().get_nodes_in_group("BottomText")[0].loadText()
				hastalked = true
##sets scoreboard and highscore##
func setScore(value,ID):
	Score[currentgame][pID[ID]]=value
##gets the scoreboard node, and then gets the scoreboard label for the current ID##
	if get_tree().get_nodes_in_group("ScoreBoard").size() != 0:
		for ScoreList in get_tree().get_nodes_in_group("ScoreBoard")[0].get_children():
			if ScoreList.name=="Score"+str(pID[ID]):
				ScoreList.text = "Score:" + str(value)
##highscore setter##
###currently hidden and not visible, will work on where to place high score later##
	if value > HighScore[currentgame]:
		HighScore[currentgame] = Score[currentgame][pID[ID]]
		if get_tree().get_nodes_in_group("ScoreBoard").size() > 0:
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
	if currentgame != 4:
		if timerleft != 0:
			timerleft-=1
			$EndTimer.start()
			get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(2).text = str(timerleft)
		else:
			get_tree().paused=false
			canDie=true
			PlayerCount = 1
			setScoreBoard(HighScore[currentgame])
			if inVR:
				get_tree().get_nodes_in_group("VIEWPORT")[0].get_parent().get_parent().loadscene("res://Assets/Scenes/"+gamename[currentgame]+"/Title.tscn")
				ingame = true
			else:
				placeholder = get_tree().change_scene("res://Assets/Scenes/"+gamename[currentgame]+"/Title.tscn")
				ingame = true
	else:
		timerleft-=1
		if timerleft == -1:
			timerleft = 10
		$EndTimer.start()
		get_tree().get_nodes_in_group("ENDSCREEN")[0].get_child(2).text = str(timerleft)
##sets music to play##
func playmusic(music):
	$Music.stream = load(music)
	$Music.play(0.0)
func stopmusic():
	$Music.stop()
##adds health to player##
func addhealth(value,ID):
	if pID.has(ID):
		health[pID[ID]]+=value
		health[pID[ID]]=max(health[pID[ID]],0)
		get_tree().get_nodes_in_group("pHealth")[pID[ID]].text = "LIVES: "+str(health[pID[ID]])
		if health[pID[ID]]<=0:
			pauser = ID
			gameover(ID)
##plays sound##
func playSound0(sound):
	$sound.stream=load(sound)
	$sound.play(0.0)
func playSound1(sound):
	$sound1.stream=load(sound)
	$sound1.play(0.0)
func playSound2(sound):
	$sound2.stream=load(sound)
	$sound2.play(0.0)
	
func setScoreBoard(value):
	var canscore=false
	var currentscore = 9
	for scores in scoreBoard[currentgame]:
		if scores<value:
			currentscore-=1
			canscore = true
	scoreBoard[currentgame].sort()
	if canscore:
		scoreBoard[currentgame][currentscore]=value
	save()
##loads save files##
var file = File.new()
func loadsave():
	if file.file_exists("user://ArcadeMashUpScores.dat"):
		file.open("user://ArcadeMashUpScores.dat",File.READ_WRITE)
		var input = str2var(file.get_as_text().split("\n")[0])
		scoreBoard = input
		input = str2var(file.get_as_text().split("\n")[1])
		HighScore = input
		
	elif !file.file_exists("user://ArcadeMashUpScores.dat"):
		file.open("user://ArcadeMashUpScores.dat",File.WRITE)
		file.seek(0)
		file.store_line(var2str(scoreBoard))
		file.store_line(var2str(HighScore))
##saves scores##
func save():
	file.seek(0)
	file.store_line(var2str(scoreBoard))
	file.store_line(var2str(HighScore))
func setvolume(vol):
	$Music.volume_db = vol
func setnoise(vol):
	$sound.volume_db = vol
	$sound1.volume_db = vol
	$sound2.volume_db = vol
