extends Spatial

tool
export (Array,float) var Size=[1.0,1.0,1.0,1.0] setget usize
export var wRotation=Vector3.ZERO setget urot
export var Boolean=0 setget ubool
export var type=0 setget utype
func ubool(boole):
	Boolean = boole
	update()
func usize(size):
	if size.size() == 4:
		Size = size
	update()
func urot(rot):
	if abs(rot.x) > 360:rot.x-=360*sign(rot.x)
	if abs(rot.y) > 360:rot.y-=360*sign(rot.y)
	if abs(rot.z) > 360:rot.z-=360*sign(rot.z)
	wRotation = rot
	update()
func utype(ntype):
	type=ntype
	update()

func update():
	if Engine.editor_hint:
		get_tree().get_nodes_in_group("Loader")[0].start(false)
func _get(property):
	if Engine.editor_hint:
		if property == "rotation_degrees":
			update()
