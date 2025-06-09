extends Node

## Stores information for a controllers' preferences overall and for each game.
class ControllerPreference:
	var character: CharacterInfo
	var extra: Dictionary[String, GameInfo]  = {}

## Maps controller strings to their controller preference information
class ControllerPreferences:
	var preference_dictionary: Dictionary[String, ControllerPreference] = {}
	
	func get_for(input: PlayerInput) -> ControllerPreference:
		if not preference_dictionary.has(input.to_string()):
			preference_dictionary[input.to_string()] = ControllerPreference.new()
		
		return preference_dictionary.get(input.to_string())

## Dictionary from input key to the preferences
var preferences := ControllerPreferences.new()

## Provides a list of all connected input options (keyboard and joysticks)
var AvailableInputs: Array[PlayerInput]:
	get:
		var inputs: Array[PlayerInput] = [
		KeyboardInput.new(1),
		KeyboardInput.new(2)
		]
		
		for i in Input.get_connected_joypads():
			inputs.append(JoystickInput.new(i))
		
		return inputs

## Called when a controller disconnects.
signal controller_disconnected(input: PlayerInput)

var active_inputs: Array[PlayerInput] = []

func activate_input(input: PlayerInput):
	for active_input in active_inputs:
		if input.equals(active_input):
			return
	
	active_inputs.append(input)

func deactivate_input(input: PlayerInput):
	var found_it : PlayerInput = null
	for other_input in active_inputs:
		if other_input.equals(input):
			found_it = other_input
			break
	
	if found_it == null:
		push_warning("Tried to deactivate non-activated input ", input)
		
	active_inputs.erase(found_it)

## Continuously check if any joysticks have disconnected
func _process(_dt):
	var joypads := Input.get_connected_joypads()
	var bad_joypads: Array[PlayerInput] = []
	
	for input in active_inputs:
		if not is_instance_of(input, JoystickInput):
			continue
		if not input.index in joypads:
			bad_joypads.append(input)
			controller_disconnected.emit(input)
			deactivate_input(input)
