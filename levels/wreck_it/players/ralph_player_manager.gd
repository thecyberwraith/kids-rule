extends PlayerManager

@export var RalphPlayerMachineTemplate: PackedScene
@export var RalphPlayerScript: Script

@export var spawn_locations: Node3D
@export var selection: PlayerSelection

func create_player(input: PlayerInput):
	super.create_player_for_input(input)
	var player := player_map[input.to_string()] as Player
	
	player.global_position = spawn_locations.get_child(
		ActiveInputs.active_inputs.find(input)
	).global_position

func update_player_for_level_details(input: PlayerInput):
	var player := player_map[input.to_string()] as Player
	print("Preparing player for Wreck Level")
	player.set_script(RalphPlayerScript)
	player.collision_mask |= 4
	player.state_machine.replace_states(RalphPlayerMachineTemplate.instantiate())
	player.equip(RepairHammer.new())
	print("Player ready")
