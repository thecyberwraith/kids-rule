@tool
class_name ZurgRamp extends Node3D

@onready var box: CSGBox3D = $box
@onready var left: CSGPolygon3D = $left
@onready var right: CSGPolygon3D = $right
@onready var visible_box: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

@export_range(0.1,5) var flat_length: float = 1:
	set(value):
		flat_length = value
		_update_geometry()
@export_range(1,5) var height: float = 1:
	set(value):
		height = value
		_update_geometry()
@export_range(5,45) var ramp_angle: float = 30:
	set(value):
		ramp_angle = value
		_update_geometry()

func _update_geometry():
	if box == null or left == null or right == null:
		return
	var length: float = height / tan(deg_to_rad(ramp_angle))
	
	box.scale.x = flat_length
	box.position.x = length + flat_length / 2
	box.scale.y = height
	box.position.y = height/2
	
	left.scale.y = height
	left.position.x = length

	right.scale.y = height
	right.position.x = length + flat_length

	left.scale.x = length
	right.scale.x = length
	
	visible_box.aabb.position = Vector3(0, 0, -0.5)
	visible_box.aabb.size = Vector3(
		2*length + flat_length,
		height,
		1
	)

func _ready():
	visible_box.screen_exited.connect(
		func(): 
			self.queue_free()
	)
