class_name ScrollingCharacter extends CharacterBody3D

@export var camera: ScrollingCamera

func _process(_dt):
	velocity = Vector3.RIGHT * camera.move_speed
	move_and_slide()
