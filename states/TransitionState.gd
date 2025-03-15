## A State whose only job is to initiate the next state. Useful to manually change
## states while ensuring state hooks are still called.
extends CharacterState
class_name TransitionState
var next_state: CharacterState

func _init(the_next_state: CharacterState):
	next_state = the_next_state

func process(_delta, _data):
	return next_state
