extends PlayerManager

func update_player_for_level_details(input: PlayerInput):
	print("Adding player to \"players\" group")
	var player := player_map[input.to_string()] as Player
	player.add_to_group("players")
