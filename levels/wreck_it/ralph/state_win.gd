extends CharacterState

func on_enter_state(data: RalphStateMachine.RalphState):
	data.anim.play("win")
	data.ralph.game_over.emit()
