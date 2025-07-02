extends CharacterState

@export var volley: CharacterState
@export var mines: CharacterState

var next_state: CharacterState

func on_enter_state(_zurg: Zurg):
	if randf() < 0.6:
		next_state = volley
	else:
		next_state = mines

func process(_dt, _zurg):
	return next_state
