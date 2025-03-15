extends CharacterState
class_name WalkState

@export var idle_state: CharacterState
@export var fall_state: CharacterState

@export_range(0.0, 200) var max_speed: float = 20
var last_direction = 1

func on_enter_state(data: StateMachine.Dependencies):
	data.visuals.play("walk")

func process(delta: float, data: StateMachine.Dependencies) -> CharacterState:
	var direction := data.input.get_xz_direction()

	if not data.character.is_on_floor():
		return fall_state

	if direction == Vector3.ZERO:
		return idle_state
	
	if direction.x != 0.0:
		last_direction = direction.x / abs(direction.x)
	
	data.visuals.scale.x = lerpf(data.visuals.scale.x, last_direction, 8*delta)

	data.character.velocity = max_speed * direction
	data.character.move_and_slide()
	return null
	
func on_exit_state(data: StateMachine.Dependencies):
	data.visuals.scale.x = last_direction
