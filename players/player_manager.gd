extends Node3D
class_name PlayerManager

@export var PlayerTemplate := preload("res://players/Player.tscn")

signal player_update_complete

## Maps a PlayerInput string to a player instance
var player_map := Dictionary()

func prepare_player_for_level(_input: PlayerInput, _player):
	pass

func sync_inputs_to_players():
	handle_new_players()
	handle_removing_old_players()
	
	for i in get_child_count():
		prepare_player_for_level(
			JoinedControllers.controllers[i],
			get_child(i)
		)
	
	player_update_complete.emit()

func handle_removing_old_players():
	var keys_to_delete: Array[String] = []
	
	var joined_keys: Array[String] = []
	for controller in JoinedControllers.controllers:
		joined_keys.append(controller.to_string())
	
	for input in player_map.keys():
		if not input in joined_keys:
			var player = player_map[input]
			remove_child(player)
			player.queue_free()
			keys_to_delete.append(input.to_string())
	
	for key in keys_to_delete:
		player_map.erase(key)

func handle_new_players():
	for input in JoinedControllers.controllers:
		if not input.to_string() in player_map:
			var new_player := PlayerTemplate.instantiate()
			player_map[input.to_string()] = new_player
			add_child(new_player)
