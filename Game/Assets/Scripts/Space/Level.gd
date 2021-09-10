extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lines = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for child in get_children():
		var color = GlobalScene.randColor()
		if child.get_child_count() > 0:
			child.id = get_parent().get_parent().get_child(2).PlayerID
			for sprites in child.get_child(0).get_children():
				sprites.self_modulate = color


func updateMovers():
	call_deferred("updateMoversReal")
func updateMoversReal():
	lines -= 1
	if lines == 0:
		get_tree().get_nodes_in_group("NextLevel")[0].nextLevel()
		get_tree().get_nodes_in_group("NextLevel")[0].sceneload = get_parent().get_path()
		
		queue_free()


func _on_SpawnCharger_timeout():
	if rand_range(0.0,1.0)> 0.75:
		var charger = load("res://Assets/Scenes/Space/Enemies/Charger.tscn").instance()
		add_child(charger)
		charger.position = Vector2.ZERO
		charger.position.x = rand_range(0.0,1024.0)
		charger.update()
		charger.setUp()
