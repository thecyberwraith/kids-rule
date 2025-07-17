extends IdleState

@export var laser: CharacterState
@export var heal: CharacterState

func process(delta, data: StateMachine.Dependencies):
	if data.input.get_accept_pressed():
		return laser
	
	var ranger := data.character as RangerPlayer
	if data.input.get_cancel_pressed() and ranger.healing_burst_level.percentage == 1.0 :
		return heal
	
	return super.process(delta, data)
