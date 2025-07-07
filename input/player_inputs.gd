extends Node
## Handles listed of available inputs and active inputs. For active inputs, this
## class handles any extra game metadata.

## Called when an available joystick is disconnected.
signal input_disconnected(input: PlayerInput)

## Called when an available input is activated.
signal input_activated(input: PlayerInput)

## Called when an active input is deactivated.
signal input_deactivated(input: PlayerInput)

## Called when a character for an input, or other game data, is changed.
signal input_updated(input: PlayerInput, info: ControllerPreference)

class ControllerPreference:
	## Records all configuration data for games for a specific player. Each
	## player must have a character. Further, each game can record a
	## [GameInfo] datum for the player such as color or player class.
	var character: CharacterInfo
	var extra: Dictionary[String, GameInfo]  = {}

	func equals(other) -> bool:
		if not is_instance_of(other, ControllerPreference):
			return false
		elif not character == null:
			return character.equals(other.character) and extra.recursive_equal(other.extra, 2)
		elif not other.character == null:
			return false
		else:
			# In this case, character AND other.character is null
			return extra.recursive_equal(other.extra, 2)
		
## Maps a controller to that player's configuration data.
var preference_dictionary: Dictionary[String, ControllerPreference] = {}
	
func get_prefs_for(input: PlayerInput) -> ControllerPreference:
	if not preference_dictionary.has(input.to_string()):
		preference_dictionary[input.to_string()] = ControllerPreference.new()
	
	return preference_dictionary.get(input.to_string())

func set_prefs_for(input: PlayerInput, prefs: ControllerPreference):
	var need_update = not get_prefs_for(input).equals(prefs)
	
	preference_dictionary[input.to_string()] = prefs
	
	if need_update:
		input_updated.emit(input, prefs)

## Dictionary from input key to the preferences
var preferences: Dictionary[String, ControllerPreference] = {}

## Provides a list of all connected input options (keyboard and joysticks)
var available: Array[PlayerInput]:
	get:
		var inputs: Array[PlayerInput] = [
			KeyboardInput.new(1),
			KeyboardInput.new(2),
		]
		
		for i in Input.get_connected_joypads():
			inputs.append(JoystickInput.new(i))
		
		return inputs

## Provides all inputs that are available, but not active.
var inactive: Array[PlayerInput]:
	get:
		var result: Array[PlayerInput] = []
		var keys = active.map(func (i): i.to_string())
		
		for input in available:
			if input.to_string() not in keys:
				result.append(input)
		
		return result

## A list of PlayerInput objects that have been activated for play.
var active: Array[PlayerInput] = []

## Transition the given input from inactive to active.
func activate_input(input: PlayerInput):
	for active_input in active:
		if input.equals(active_input):
			return
	
	active.append(input)
	input_activated.emit(input)

## Transition the given input from active to inactive.
func deactivate_input(input: PlayerInput):
	var found_it : PlayerInput = null
	for other_input in active:
		if other_input.equals(input):
			found_it = other_input
			break
	
	if found_it == null:
		push_warning("Tried to deactivate non-activated input ", input)
		
	active.erase(found_it)
	input_deactivated.emit(input)

## Continuously check if any joysticks have disconnected
func _process(_dt):
	var joypads := Input.get_connected_joypads()
	var bad_joypads: Array[PlayerInput] = []
	
	for input in active:
		if not is_instance_of(input, JoystickInput):
			continue
		if not input.index in joypads:
			bad_joypads.append(input)
	
	for input in bad_joypads:
		input_disconnected.emit(input)
		deactivate_input(input)
