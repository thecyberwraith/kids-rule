class_name IdleState
extends CharacterState

@export var walk: CharacterState
@export var fall: CharacterState

func on_enter_state(data: StateMachine.Dependencies):
	data.animations.play("idle")

func process(_delta: float, data: StateMachine.Dependencies) -> CharacterState:
	var direction := data.input.get_move_direction()
	
	if not data.character.is_on_floor():
		return fall

	if direction != Vector2.ZERO:
		return walk

	return null
