extends ARVRController


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const checkbenefit = [3,4]
const checkmoved = [0,2,3]
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
		if GlobalScene.ingame and checkmoved.has(GlobalScene.currentgame):
			if !checkmoved.has(GlobalScene.currentgame):
				Input.action_release("leftP1")
				Input.action_release("rightP1")
			if !checkbenefit.has(GlobalScene.currentgame):
				Input.action_release("upP1")
				Input.action_release("downP1")
		if joystick_vector.length() > 0.125 and !havemoved:
			if abs(joystick_vector.x) > 0.125:
				if joystick_vector.x < 0:
					Input.action_press("rightP1")
				else:
					Input.action_press("leftP1")
				if checkmoved.has(GlobalScene.currentgame):
					havemoved = true
			if abs(joystick_vector.y) > 0.125 and !checkbenefit.has(GlobalScene.currentgame) and GlobalScene.ingame:
				if joystick_vector.y < -0.25:
					Input.action_press("downP1")
				elif joystick_vector.y > 0.25:
					Input.action_press("upP1")
				if checkmoved.has(GlobalScene.currentgame):
					havemoved = true
			if !GlobalScene.ingame:
				havemoved = true
		elif joystick_vector.length() < 0.025:
			havemoved = false
		if abs(joystick_vector.x) < 0.1:
			Input.action_release("rightP1")
			Input.action_release("leftP1")
		if abs(joystick_vector.y) < 0.1:
			Input.action_release("upP1")
			Input.action_release("downP1")
func _on_LController_button_release(button):
	if button == 7:
		if abs(get_joystick_axis(1)) < 0.1:
			Input.action_release("upP1")
	if button == 1:
		if abs(get_joystick_axis(1)) < 0.1:
			Input.action_release("downP1")
	if button == 14:
		Input.action_release("escape")
	if button == 2:
		Input.action_release("enter")
