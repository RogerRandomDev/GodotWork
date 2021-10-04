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
func _process(delta):
	var rot = $ImmediateGeometry2.material_override.get_shader_param("WRotation")
	if rot.x > PI*2:rot.x = -rot.x
	if rot.y > PI*2:rot.y = -rot.y
	if rot.z > PI*2:rot.z = -rot.z
	$ImmediateGeometry2.material_override.set_shader_param("WRotation",rot)
	$ImmediateGeometry2.material_override.set_shader_param("WRotation",
	$ImmediateGeometry2.material_override.get_shader_param("WRotation")+Vector3(PI*delta*canchange[0],PI*delta*canchange[1],PI*delta*canchange[2]))
	
	get_parent().get_parent().get_parent().get_parent().get_child(1).value = $ImmediateGeometry2.material_override.get_shader_param("WRotation").x
	get_parent().get_parent().get_parent().get_parent().get_child(2).value = $ImmediateGeometry2.material_override.get_shader_param("WRotation").y
	get_parent().get_parent().get_parent().get_parent().get_child(3).value = $ImmediateGeometry2.material_override.get_shader_param("WRotation").z
