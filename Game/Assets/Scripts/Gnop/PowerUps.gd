extends Node2D



var pBase = preload("res://Assets/Scenes/Gnop/PowerUp.tscn")
const powerups = []


func _ready():
	pass


func _on_Timer_timeout():
	if rand_range(0.0,1.0) > 0.9 and get_child_count()<7:
		var pUP = pBase.instance()
		add_child(pUP)
		pUP.position = Vector2(round(rand_range(-512,512)),round(rand_range(256,512)))
		var power = round(rand_range(0.0,2.0))
		pUP.Powerup = power
		pUP.region_rect = Rect2(power*8,0,8,8)
		
