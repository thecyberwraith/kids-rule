class_name ScrollingCamera extends Camera3D

@export var move_speed = 1.5

func _process(delta):
	position.x += move_speed * delta
