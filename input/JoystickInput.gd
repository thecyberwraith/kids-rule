extends PlayerInput
class_name JoystickInput

var index: int = 0

func _init(_index: int):
	index = _index

	accept_name = 'joystick_%s_accept' % index
	cancel_name = 'joystick_%s_cancel' % index
	menu_name = 'joystick_%s_menu' % index
	
	create_action(accept_name, JOY_BUTTON_A)
	create_action(cancel_name, JOY_BUTTON_B)
	create_action(menu_name, JOY_BUTTON_START)
	
func create_action(action_name: String, button: JoyButton):
	InputMap.add_action(action_name)
	var evt := InputEventJoypadButton.new()
	evt.device = index
	evt.button_index = button
	InputMap.action_add_event(action_name, evt)

func _to_string() -> String:
	return "Joystick Input %s [%s]" % [index, Input.get_joy_name(index)]

func get_horizontal() -> float:
	return Input.get_joy_axis(index, JOY_AXIS_LEFT_X)

func get_vertical() -> float:
	return Input.get_joy_axis(index, JOY_AXIS_LEFT_Y)
