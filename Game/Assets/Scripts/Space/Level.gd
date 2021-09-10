extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lines = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.id = get_parent().get_parent().get_child(2).PlayerID


func updateMovers():
	call_deferred("updateMoversReal")
func updateMoversReal():
	lines -= 1
	if lines == 0:
		get_tree().get_nodes_in_group("NextLevel")[0].nextLevel()
		get_tree().get_nodes_in_group("NextLevel")[0].sceneload = get_parent().get_path()
		
		queue_free()
