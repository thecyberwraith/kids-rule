extends CharacterState
class_name WalkState

@export var idle_state: CharacterState
@export var fall_state: CharacterState

@export_range(0.0, 50) var max_speed: float = 20
@export_range(0.1, 20) var flip_speed: float = 10

var last_direction = 1

func on_enter_state(data: StateMachine.Dependencies):
	data.animations.play("walk")

func process(delta: float, data: StateMachine.Dependencies) -> CharacterState:
	var direction := data.input.get_xz_direction()

	if not data.character.is_on_floor():
		return fall_state

	if direction == Vector3.ZERO:
		return idle_state
	
	if direction.x != 0.0:
		last_direction = direction.x / abs(direction.x)
	
	data.visuals.scale.x = lerpf(data.visuals.scale.x, last_direction, flip_speed*delta)

	data.character.velocity = max_speed * direction
	data.character.move_and_slide()
	return null

func on_exit_state(data: StateMachine.Dependencies):
	data.visuals.scale.x = last_direction
