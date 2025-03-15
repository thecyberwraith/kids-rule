extends AnimatedState

@export var max_speed: float = 10.0

@export var idle_state: CharacterState
@export var swing: CharacterState

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var last_direction: float

func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	last_direction = data.visuals.scale.x / abs(data.visuals.scale.x)
	audio.play()

func process(dt: float, data: StateMachine.Dependencies):
	var direction := data.input.get_xz_direction()

	if direction == Vector3.ZERO:
		return idle_state
	
	if data.input.get_accept_pressed():
		return swing

	if direction.x != 0.0:
		last_direction = direction.x / abs(direction.x)
	
	data.visuals.scale.x = lerpf(data.visuals.scale.x, last_direction, 8*dt)

	data.character.velocity = max_speed * direction +  Vector3(0,-20,0)
	data.character.move_and_slide()
	return null

func on_exit_state(data: StateMachine.Dependencies):
	super.on_exit_state(data)
	data.visuals.scale.x = last_direction
	audio.stop()
