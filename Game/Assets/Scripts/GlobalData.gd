extends Node


##allows you to disable the shader
var shaderOFF = false

##stores score and HighScore##
var Score = [0,0]
var HighScore = 0
var PlayerCount = 1
##Coins in at the moment##
var coinCount = 0
##converts player ID to the label for the score##
const pID = {"P1":0,"P2":1,"CPU":1}
##Modulation colors to allow for more variety by just changing pallette essentially between the values##
const ColorValues = [Color8(136,0,0,255),Color8(48,32,152,255),Color8(120,0,92,255),Color8(208,208,80,255)]

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
		
	##sets max to 99, because I specifically remember this from these kinds of games
		coinCount = min(coinCount,99)
	##sets visible coins on normal game level##
		if get_tree().get_nodes_in_group("COINDISPLAY").size()!=0:
			get_tree().get_nodes_in_group("COINDISPLAY")[0].text = "COINS:\n"+str(coinCount)
	
	##Lets you disable the shaders
	if Input.is_key_pressed(KEY_TAB):
		GlobalData.shaderOFF = !GlobalData.shaderOFF
		get_tree().get_nodes_in_group("SHADER")[0].visible = !GlobalData.shaderOFF
##sets scoreboard and highscore##
func setScore(value,ID):
	Score[pID[ID]]=value
##gets the scoreboard node, and then gets the scoreboard label for the current ID##
	for ScoreList in get_tree().get_nodes_in_group("ScoreBoard")[0].get_children():
		if ScoreList.name=="Score"+str(pID[ID]):
			ScoreList.text = "Score:" + str(value)
##highscore setter##
###currently hidden and not visible, will work on where to place high score later##
	if value > HighScore:
		HighScore = Score[pID[ID]]
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(PlayerCount).text = "HighScore:\n" + str(value)

###Need to add functionality here, preferrable a screen prompting you to continue for 1 Coin##
##Best if it provides high score here as well to give them a sense of progression##
###
func gameover():
	print("hit")
	pass
##randomly selects color to return from pallette above##
func randColor():
	return ColorValues[round(rand_range(0,ColorValues.size()-1))]
