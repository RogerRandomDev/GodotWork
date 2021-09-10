extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hp = 5
func hurt():
	hp -= 1
	if hp != 0:
		get_parent().modulate = Color8(255/hp*5,255/hp*5,255/hp*5)
	if hp <= 0:
		get_parent().queue_free()
