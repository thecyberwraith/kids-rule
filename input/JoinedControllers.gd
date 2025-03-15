extends Node

## Dictionary from input key to object
var stored_controller_info = Dictionary()

var AvailableInputs: Array[PlayerInput]:
	get:
		var inputs: Array[PlayerInput] = [
		KeyboardInput.new(1),
		KeyboardInput.new(2)
		]
		
		for i in Input.get_connected_joypads():
			inputs.append(JoystickInput.new(i))
		
		return inputs

## Called when the list of controllers has changed.
signal controller_information_changed

var controllers: Array[PlayerInput] = []:
	set(value):
		for i in range(controllers.size()):
			if controllers[i].to_string() != value[i].to_string():
				controllers = value
				controller_information_changed.emit()
		
		controllers = value

func find(input: PlayerInput):
	for controller_idx in controllers.size():
		if controllers[controller_idx].to_string() == input.to_string():
			return controller_idx
	
	return -1

func _process(_dt):
	var joypads := Input.get_connected_joypads()
	var bad_joypads: Array[PlayerInput] = []
	
	for controller in controllers:
		if not is_instance_of(controller, JoystickInput):
			continue
		if not controller.index in joypads:
			bad_joypads.append(controller)
	
	if not bad_joypads:
		return
	
	var new_controllers = controllers.duplicate()
	for bad_joypad in bad_joypads:
		new_controllers.erase(bad_joypad)
	
	controllers = new_controllers
