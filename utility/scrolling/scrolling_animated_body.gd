class_name ScrollingAnimatableBody
extends AnimatableBody3D

@export var camera: ScrollingCamera

func _process(delta):
	position.x += delta * camera.move_speed
