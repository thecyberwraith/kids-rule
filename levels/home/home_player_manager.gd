extends PlayerManager

func create_player_for_input(input: PlayerInput):
	super.create_player_for_input(input)
	player_map[input.to_string()].add_to_group("players")
