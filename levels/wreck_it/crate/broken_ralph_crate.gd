extends Node3D

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	audio.finished.connect(queue_free)
	audio.play()
