extends AnimatedState

@export var idle: CharacterState

var animation_complete: bool = false

func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	animation_complete = false
	data.visuals.animation.animation_finished.connect(
		func(_x): animation_complete=true,
		CONNECT_ONE_SHOT
	)

func process(_dt, _data):
	if animation_complete:
		return idle
	
	return null
