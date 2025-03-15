extends PlayerManager

@export var RalphPlayerMachineTemplate: PackedScene
@export var RalphPlayerScript: Script

@export var spawn_locations: Node3D
@export var selection: PlayerSelection

func prepare_player_for_level(input: PlayerInput, player: Player):
	print("Preparing player for Wreck Level")
	player.visuals = load(selection.get_visuals_for(input)).instantiate() as PlayerVisuals
	player.input = input
	player.set_script(RalphPlayerScript)
	player.collision_mask |= 4
	player.state_machine.replace_states(RalphPlayerMachineTemplate.instantiate())
	player.equip(RepairHammer.new())
	print("Player ready")
	
	player.global_position = spawn_locations.get_child(
		JoinedControllers.find(input)
	).global_position
