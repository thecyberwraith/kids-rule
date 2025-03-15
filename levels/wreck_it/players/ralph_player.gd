extends Player

func get_wrecked(_is_terminal: bool):
	state_machine.transition_to_state(state_machine.get_node("stun"))
