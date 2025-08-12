extends Node3D
class_name PlayerManager

@export var PlayerTemplate := preload("res://players/Player.tscn")

## Maps a PlayerInput string to a player instance
var player_map: Dictionary[String, Node]

func _ready():
	print("Creating players based on current active inputs.")
	for input in PlayerInputs.active:
		create_player_for_input(input)
		
		var prefs := PlayerInputs.get_prefs_for(input)
		if prefs.character == null:
			continue
		
		on_player_details_updated(input)


func on_game_resume():
	for input in PlayerInputs.active:
		on_player_details_updated(input)


## Called anytime that the player's details, whether level specific or not, have
## changed.
func on_player_details_updated(input: PlayerInput):
	if not player_map.has(input.to_string()):
		create_player_for_input(input)
	
	update_player_preferences(input)


## Called when the player's preferences have changed. By default, this
## instantiates the appropriate player visuals on a Player class and attached
## the input to it. If the PlayerTemplate is not a Player subclass, this
## method must be overridden.
func update_player_preferences(input: PlayerInput):
	var player := player_map[input.to_string()] as Player
	var character := PlayerInputs.get_prefs_for(input).character
	
	player.visuals = load(character.path).instantiate()
	player.input = input


func handle_removing_old_players():
	var keys_to_delete: Array[String] = []
	
	var joined_keys: Array[String] = []
	for controller in PlayerInputs.active_inputs:
		joined_keys.append(controller.to_string())
	
	for input in player_map.keys():
		if not input in joined_keys:
			var player = player_map[input]
			remove_child(player)
			player.queue_free()
			keys_to_delete.append(input.to_string())
	
	for key in keys_to_delete:
		player_map.erase(key)


## Instantiates the specified template and adds it as a child to this node.
func create_player_for_input(input: PlayerInput):
	if input.to_string() in player_map:
		push_warning("Tried to create new player for input ", input)
		return
	var new_player := PlayerTemplate.instantiate()
	player_map[input.to_string()] = new_player
	add_child(new_player)

func remove_player_for_input(input: PlayerInput):
	if input.to_string() not in player_map:
		push_warning("Tried to remove non-existant player for input ", input)
		return
	
	var player := player_map[input.to_string()]
	remove_child(player)
	player_map.erase(input.to_string())
	player.queue_free()
