extends StateMachine

@export var animations: AnimationPlayer

func _get_data():
	return StateMachine.Dependencies.new(
		character.input,
		visuals,
		character,
		animations
	)
