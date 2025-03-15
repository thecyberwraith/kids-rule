extends AnimatedState

@export var idle: CharacterState
@export var stun_time: float = 1.5

var time_in_state: float = 0.0

func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	data.character.sprite_3d.material_override.set_shader_parameter("flash", 0.5)
	get_node("AudioStreamPlayer").play()
	time_in_state = 0.0

func process(delta, _data: StateMachine.Dependencies):
	time_in_state += delta
	if time_in_state >= stun_time:
		return idle
	
func on_exit_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	data.character.sprite_3d.material_override.set_shader_parameter("flash", 0.0)
