extends Node3D

@onready var camera: ScrollingCamera = $Camera3D
@onready var zurg: Zurg = $Zurg
@onready var players = $Players
@onready var zurg_bar: ProgressBar = $CanvasLayer/ZurgHealth/ProgressBar
@onready var overlay: TextOverlayPanel = $CanvasLayer/Overlay
@onready var pause: PauseMenu = $CanvasLayer/PauseMenu


func _ready():
	pause.game_resumed.connect(players.on_game_resume)
	
	zurg.damage.death.connect(game_won)
	zurg.damage.health.connect_to_progress_bar(zurg_bar)

	players.all_health_drained.connect(game_lost)

	overlay.text_display_over.connect(func(): 
		players.prepare_unload()
		get_tree().change_scene_to_file("res://levels/home/home.tscn")
	)


func game_won():
	camera.move_speed = 0.0
	print("Do Game Success")
	overlay.display_text(["You Defeated Zurg!", "Well done ranger!", "Let's Go Home"], 2.0)

func game_lost():
	camera.move_speed = 0.0
	print("Do Game Over")
	overlay.display_text(["You have all fallen!", "Try again later!"], 3.0)
