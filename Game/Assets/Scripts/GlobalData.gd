extends Node



##stores score and HighScore##
var Score = [0,0]
var HighScore = 0

##converts player ID to the label for the score##
const pID = {"P1":0,"P2":1,"CPU":1}


##sets scoreboard and highscore##
func setScore(value,ID):
	Score[pID[ID]]=value
##gets the scoreboard node, and then gets the scoreboard label for the current ID##
	for ScoreList in get_tree().get_nodes_in_group("ScoreBoard")[0].get_children():
		if ScoreList.name=="Score"+str(pID[ID]):
			ScoreList.text = "Score:\n" + str(value)
##highscore setter##
	if value > HighScore:
		HighScore = Score[pID[ID]]
		get_tree().get_nodes_in_group("ScoreBoard")[0].get_child(2).text = "HighScore:\n" + str(value)
func gameover():
	print("hit")
	pass
