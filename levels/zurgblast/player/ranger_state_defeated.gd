extends CharacterState

func on_enter_state(data: StateMachine.Dependencies):
	data.character.shader.set_shader_parameter("ossilation_rate", 0.5)
	data.character.shader.set_shader_parameter("min_intensity", 0.5)
	data.animations.play("defeat")
