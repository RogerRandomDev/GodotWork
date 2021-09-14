extends Node2D

##number of active players##
export var PlayerCount = 1
const changegame = [0,1]
##sets up player view based on player count##
func _ready():
	if GlobalScene.PlayerCount == 1:
		$P2.queue_free()
		$Scores/Score1.queue_free()
		if changegame.has(GlobalScene.currentgame):
			$P1.rect_position.x = 352
			$Scores/HighScore.rect_position.x = 1024 - 128
			$Scores/Score0.rect_position.x = 356
	$EndScreen/Coins.text = "COINS:\n"+str(GlobalScene.coinCount)
	##allows you to disable the shader##
	if GlobalScene.shaderOFF:
		$Shader.hide()
