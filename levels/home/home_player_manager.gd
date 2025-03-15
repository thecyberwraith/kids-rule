extends PlayerManager

func prepare_player_for_level(input: PlayerInput, player: Player):
	player.input = input
	player.add_to_group("players")
	var data = JoinedControllers.stored_controller_info[input.to_string()]
	if is_instance_of(data, PlayerData.CharacterInfo):
		player.visuals = load((data as PlayerData.CharacterInfo).path).instantiate()
