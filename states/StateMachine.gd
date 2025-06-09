class_name StateMachine
extends GenericStateMachine

@export var input: PlayerInput
@export var visuals: Node
@export var character: CharacterBody3D

class Dependencies:
	var input: PlayerInput
	var visuals: Object
	var character: CharacterBody3D
	var animations: AnimationPlayer

	## The Object c is the visuals that can be scaled with an x value.
	func _init(b: PlayerInput, object_visuals: Object, d: CharacterBody3D, a: AnimationPlayer):
		input = b
		visuals = object_visuals
		character = d
		animations = a

func _get_data():
	return Dependencies.new(input, visuals, character, visuals.animation)
