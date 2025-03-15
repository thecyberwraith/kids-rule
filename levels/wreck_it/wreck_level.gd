extends Node3D

@onready var ralph: Ralph = $Ralph
@onready var crate_container: Node3D = $Crates
@onready var players: PlayerManager = $Players
@onready var player_selection: PlayerSelection = $CanvasLayer/PlayerSelection
@onready var camera: SharedCamera = $SharedCamera
@onready var ui: RalphUI = $CanvasLayer/RalphUI

@onready var overlay: TextOverlayPanel = $CanvasLayer/Overlay
@onready var overlay_text: Label = $CanvasLayer/Overlay/Text

var max_destruction: int = 1
var destruction_level: int = 0

signal destruction_level_changed(float)

func _ready():
	ralph.crate_targets = crate_container
	ralph.game_over.connect(_on_game_over)
	
	for crate in crate_container.get_children():
		crate.on_damage_change.connect(_on_crate_damage_change)
		
	max_destruction = crate_container.get_child_count() * (RalphCrate.MAX_DAMAGE + 1)
	destruction_level_changed.connect(ui._on_destruction_level_change)
	
	player_selection.player_details_ready.connect(func (_x): players.sync_inputs_to_players())
	players.player_update_complete.connect(_on_players_updated)

	players.sync_inputs_to_players()

	overlay.display_text(["Ready", "Set", "Go!"], 1.5)
	overlay.text_display_over.connect(
		func():
			print("Game Start!")
			ralph.start(),
		CONNECT_ONE_SHOT
	)

func _on_crate_damage_change(value: int):
	destruction_level += value
	destruction_level_changed.emit(1.0 * destruction_level / max_destruction)

func _on_players_updated():
	var players_array: Array[Player] = []
	for child in players.get_children():
		players_array.append(child as Player)
	camera.players = players_array

func _on_game_over():
	print("Game Over")
	ui.game_running = false
	overlay.display_text(
		["Game Over", "Score: %s" % ui.game_time, "Let's Head Home!"],
		2.0)
	overlay.text_display_over.connect(
		func(): get_tree().change_scene_to_file("res://levels/home/home.tscn"),
		CONNECT_ONE_SHOT
	)
