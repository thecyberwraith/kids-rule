extends AnimatedState

@export var idle: CharacterState


func process(_dt: float, data: StateMachine.Dependencies):
	if not data.input.get_accept_held():
		return idle
	
	data.character.velocity = Vector3.ZERO
	data.character.move_and_slide()
	
	return null
