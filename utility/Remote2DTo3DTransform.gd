extends Node2D
## A node in 2D space which can calculate the appropriate location/transform
## in 3D space.
class_name Remote2DTo3DTransform

@export var remote: Node3D
@export var root_3d: Sprite3D
@export var tmp_offset: float = 0.0

func _process(_delta):
	if remote == null or root_3d == null:
		return
	
	
	var offset := root_3d.pixel_size * Vector3(global_position.x,root_3d.texture.get_size()[1]-global_position.y,0)
	remote.global_transform = root_3d.global_transform.translated(offset)
