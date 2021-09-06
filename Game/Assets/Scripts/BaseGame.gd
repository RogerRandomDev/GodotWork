extends Node2D

##number of active players##
export var PlayerCount = 1

##sets up player view based on player count##
func _ready():
	if GlobalData.PlayerCount == 1:
		$P2.queue_free()
		$Scores/Score1.queue_free()
		$P1.rect_position.x = 352
		$Scores/HighScore.rect_position.x = 1024 - 128
		$Scores/Score0.rect_position.x = 356
	$Scores/Coins.text = "COINS:\n"+str(GlobalData.coinCount)
	##allows you to disable the shader##
	if GlobalData.shaderOFF:
		$Shader.hide()
