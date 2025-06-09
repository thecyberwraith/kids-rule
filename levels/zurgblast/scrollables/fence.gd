extends Node3D

@onready var fence: AnimatedSprite3D = $Sprite
@onready var visibility: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@export var width:int = 2
@export var number:int = 7

func _ready():
	_randomize_animation()
	visibility.screen_exited.connect(shift)

func _randomize_animation():
	fence.speed_scale = randf_range(0.75, 2)
	if randf() < 0.5:
		fence.play("default")
	else:
		fence.play_backwards("default")

func shift():
	position.x += width * number
	_randomize_animation()
