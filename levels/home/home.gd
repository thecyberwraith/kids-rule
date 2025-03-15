extends Node3D

@onready var players: PlayerManager = $Players
@onready var selection: PlayerSelection = $CanvasLayer/PlayerSelection
@onready var camera: SharedCamera = $Camera3D

func _ready():
	selection.player_details_ready.connect(func (_x): players.sync_inputs_to_players())
	players.player_update_complete.connect(func (): camera.assign_from_node(players))

	players.sync_inputs_to_players()
