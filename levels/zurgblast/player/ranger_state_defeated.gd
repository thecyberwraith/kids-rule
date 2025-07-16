extends AnimatedState

func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	data.character.shader.set_shader_parameter("ossilation_rate", 0.5)
	data.character.shader.set_shader_parameter("min_intensity", 0.5)

func process(_delta, data: StateMachine.Dependencies):
	data.character.velocity = Vector3.ZERO
	data.character.move_and_slide()
