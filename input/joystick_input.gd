class_name JoystickInput extends PlayerInput

@export var index: int = 0
@export var deadzone: float = 0.09

func _init(_index: int=0):
	index = _index

	_create_action_names("joystick_%s" % index)
	
	var button_mappings = [
		[accept_name, JOY_BUTTON_A],
		[cancel_name, JOY_BUTTON_B],
		[menu_name, JOY_BUTTON_START],
	]
	
	var axis_mappings = [
		[left_name, JOY_AXIS_LEFT_X, -1.0, JOY_BUTTON_DPAD_LEFT],
		[right_name, JOY_AXIS_LEFT_X, 1.0, JOY_BUTTON_DPAD_RIGHT],
		[up_name, JOY_AXIS_LEFT_Y, -1.0, JOY_BUTTON_DPAD_UP],
		[down_name, JOY_AXIS_LEFT_Y, 1.0, JOY_BUTTON_DPAD_DOWN],
	]
	
	for name_button in button_mappings:
		create_button_action(name_button[0], name_button[1])
	
	for vals in axis_mappings:
		create_axis_action(vals[0], vals[1], vals[2], vals[3])


func create_button_action(action_name: String, button: JoyButton):
	var evt := InputEventJoypadButton.new()
	evt.device = index
	evt.button_index = button
	_conditionally_add_events(action_name, evt)


func create_axis_action(action: String, axis: JoyAxis, direction: float, button: JoyButton):
	var ax_evt := InputEventJoypadMotion.new()
	ax_evt.axis = axis
	ax_evt.axis_value = direction
	ax_evt.device = index
	
	var but_evt := InputEventJoypadButton.new()
	but_evt.device = index
	but_evt.button_index = button
	
	_conditionally_add_events(action, [ax_evt, but_evt])


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
