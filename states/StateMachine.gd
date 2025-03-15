class_name StateMachine
extends GenericStateMachine

@export var input: PlayerInput
@export var visuals: PlayerVisuals
@export var character: CharacterBody3D

class Dependencies:
	var input: PlayerInput
	var visuals: PlayerVisuals
	var character: CharacterBody3D

	func _init(b: PlayerInput, c: PlayerVisuals, d: CharacterBody3D):
		input = b
		visuals = c
		character = d

func _get_data():
	return Dependencies.new(input, visuals, character)
