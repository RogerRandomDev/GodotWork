extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var shader:NodePath
var rot
# Called when the node enters the scene tree for the first time.
func _ready():
	rot = get_node(shader).material_override.get_shader_param("WRotation")


func _on_HSlider_value_changed(value):
	rot.x = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider2_value_changed(value):
	rot.y = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider3_value_changed(value):
	rot.z = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider4_value_changed(value):
	get_node(shader).material_override.set_shader_param("CurrentW",value)
