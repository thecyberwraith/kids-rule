extends FallState

func on_enter_state(ranger):
	super.on_enter_state(StateMachine.Dependencies.new(
		ranger.input,
		ranger.visuals,
		ranger,
		ranger.animation
	))

func process(delta, ranger):
	super.process(delta, StateMachine.Dependencies.new(
		ranger.input,
		ranger.visuals,
		ranger,
		ranger.animation
	))
