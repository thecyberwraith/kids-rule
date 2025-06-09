class_name JoystickInput extends PlayerInput

@export var index: int = 0
@export var deadzone: float = 0.09

func _init(_index: int=0):
	index = _index

	accept_name = 'joystick_%s_accept' % index
	cancel_name = 'joystick_%s_cancel' % index
	menu_name = 'joystick_%s_menu' % index
	
	create_action(accept_name, JOY_BUTTON_A)
	create_action(cancel_name, JOY_BUTTON_B)
	create_action(menu_name, JOY_BUTTON_START)
	
func create_action(action_name: String, button: JoyButton):
	if InputMap.has_action(action_name):
		return
	InputMap.add_action(action_name)
	var evt := InputEventJoypadButton.new()
	evt.device = index
	evt.button_index = button
	InputMap.action_add_event(action_name, evt)

func _to_string() -> String:
	return "Joystick Input %s [%s]" % [index, Input.get_joy_name(index)]

func _apply_deadzone(value: float) -> float:
	if abs(value) < deadzone:
		value = 0.0
	return value

func get_move_direction() -> Vector2:
	var result := Vector2(get_horizontal(), get_vertical())
	return _apply_deadzone(result.length()) * result

func get_horizontal() -> float:
	return _apply_deadzone(Input.get_joy_axis(index, JOY_AXIS_LEFT_X))

func get_vertical() -> float:
	return _apply_deadzone(Input.get_joy_axis(index, JOY_AXIS_LEFT_Y))
