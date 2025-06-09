extends IdleState

@export var laser: CharacterState

func process(delta, data: StateMachine.Dependencies):
	if data.input.get_accept_pressed():
		return laser
	
	return super.process(delta, data)
