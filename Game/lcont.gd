extends ARVRController


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const checkbenefit = [1,3,4]
var havemoved = false
func _on_LController_button_pressed(button):
	if button == 7:
		Input.action_press("upP1")
	if button == 1:
		Input.action_press("downP1")
	if button == 14:
		Input.action_press("escape")
	if button == 2:
		Input.action_press("enter")
		
# warning-ignore:unused_argument
func _process(delta):
	if GlobalScene.inVR:
		if get_joystick_axis(2) > 0.125:
			Input.action_press("insertcoin")
		else:
			Input.action_release("insertcoin")
		
		var joystick_vector = Vector2(-get_joystick_axis(0), get_joystick_axis(1))
		if joystick_vector.length() > 0.0625 and !havemoved:
			if GlobalScene.ingame and checkbenefit.has(GlobalScene.currentgame):
				Input.action_release("leftP1")
				Input.action_release("rightP1")
			var dir = abs(joystick_vector.x)-abs(joystick_vector.y)
			if dir >=0:
				if joystick_vector.x < 0:
					Input.action_press("rightP1")
				else:
					Input.action_press("leftP1")
			if !GlobalScene.ingame:
				havemoved = true
		elif joystick_vector.length() < 0.025:
			havemoved = false
		if abs(joystick_vector.x) < 0.0625:
			Input.action_release("rightP1")
			Input.action_release("leftP1")

func _on_LController_button_release(button):
	if button == 7:
		Input.action_release("upP1")
	if button == 1:
		Input.action_release("downP1")
	if button == 14:
		Input.action_release("escape")
	if button == 2:
		Input.action_release("enter")
