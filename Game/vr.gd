extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var firsttime = true

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScene.inVR = true
	$ViewportContainer/Viewport.add_child(load("res://Assets/Scenes/MainTitle.tscn").instance())
	$ViewportContainer/Viewport.get_child(0).position = Vector2(512,300)
	if GlobalScene.inVR:
		GlobalScene.setvolume(10)
		GlobalScene.setnoise(0)
func loadscene(scene,chance=null):
	if(scene=="res://Assets/Scenes/MainTitle.tscn"):
		GlobalScene.ingame = false
	Input.action_release("enter")
	$ViewportContainer/Viewport.freechildren()
	$ViewportContainer/Viewport.add_child(load(scene).instance())
	$ViewportContainer/Viewport.get_child(0).z_index = -100
	if chance == null:
		$ViewportContainer/Viewport.get_child(1).position = Vector2(512,300)
	firsttime = false
	$ViewportContainer/Viewport.get_child(1).z_index = 100
	$ViewportContainer.modulate = Color8(0,0,0,0)
	pass
func updateviewport():
	pass
