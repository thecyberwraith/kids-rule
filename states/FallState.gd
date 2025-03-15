extends CharacterState
class_name FallState

@export var idle_state: CharacterState

@export_range(0,100) var air_speed: float
@export_range(1,100) var fall_speed: float

func on_enter_state(data: StateMachine.Dependencies):
	data.visuals.play("fall")

func process(_d: float, data: StateMachine.Dependencies) -> CharacterState:
	if data.character.is_on_floor():
		return idle_state
	
	var direction := data.input.get_xz_direction()
	
	data.character.velocity = air_speed * direction + fall_speed * Vector3.DOWN
	data.character.move_and_slide()
	
	return null
