class_name ScrollingAnimatableBody
extends AnimatableBody3D

@export var camera: ScrollingCamera = null

func _process(delta):
	if camera != null:
		position.x += delta * camera.move_speed
