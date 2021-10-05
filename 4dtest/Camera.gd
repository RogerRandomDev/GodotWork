extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var canchange = [0,0,0]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
		$ImmediateGeometry2.material_override.set_shader_param("Rotation",
		$ImmediateGeometry2.material_override.get_shader_param("Rotation")+Vector3(event.relative.y,event.relative.x,0)*0.0025)
		pass
