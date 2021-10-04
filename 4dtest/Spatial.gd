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
	rot = get_node(shader).material_override.get_shader_param("WRotation")
	rot.x = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider2_value_changed(value):
	rot = get_node(shader).material_override.get_shader_param("WRotation")
	rot.y = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider3_value_changed(value):
	rot = get_node(shader).material_override.get_shader_param("WRotation")
	rot.z = value
	get_node(shader).material_override.set_shader_param("WRotation",rot)


func _on_HSlider4_value_changed(value):
	get_node(shader).material_override.set_shader_param("CurrentW",value)


func _on_Button3_toggled(button_pressed):
	get_node(shader).get_parent().canchange[2]=int(button_pressed)


func _on_Button2_toggled(button_pressed):
	get_node(shader).get_parent().canchange[1]=int(button_pressed)


func _on_Button_toggled(button_pressed):
	get_node(shader).get_parent().canchange[0]=int(button_pressed)


func _on_OptionButton_item_selected(index):
	if index != 0:
		get_node(shader).material_override.set_shader_param("chosen",index-1)
