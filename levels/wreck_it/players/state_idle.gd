extends AnimatedState

@export var walk: CharacterState
@export var swing: CharacterState

func process(_dt: float, data: StateMachine.Dependencies):
	var direction := data.input.get_move_direction()

	if data.input.get_accept_pressed():
		return swing

	if direction != Vector2.ZERO:
		return walk
	
	data.character.velocity = Vector3(0,-20,0)
	data.character.move_and_slide()
	return null
"res://levels/wreck_it/players/ralph_player_state_machine.tscn"
