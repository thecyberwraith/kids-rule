extends CharacterState

@export var idle: CharacterState

func on_enter_state(data: StateMachine.Dependencies):
	data.animations.play("laser")

func process(_dt: float, data: StateMachine.Dependencies):
	if not data.input.get_accept_held():
		return idle
	
	return null
