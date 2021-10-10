extends ARVRController


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var havemoved = false
# warning-ignore:unused_argument
func _on_RController_button_pressed(button):
	if button == 7:
		Input.action_press("upP1")
	if button == 1:
		Input.action_press("downP1")
	pass


# warning-ignore:unused_argument
func _on_RController_button_release(button):
	if button == 7:
		Input.action_release("upP1")
	if button == 1:
		Input.action_release("downP1")
	pass
