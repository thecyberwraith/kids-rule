extends Node3D

@onready var players: PlayerManager = $Players
@onready var pause: PauseMenu = $CanvasLayer/PauseMenu
@onready var camera: SharedCamera = $Camera3D

func _ready():
	pause.game_resumed.connect(players.on_game_resume)
