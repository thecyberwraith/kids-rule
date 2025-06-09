extends Camera3D
class_name SharedCamera

@export var players_node: Node

var offset: Vector3

func _ready():
	offset = position

func _process(_delta):
	if players_node.get_child_count() == 0:
		return

	var center := Vector3.ZERO
	for player in players_node.get_children():
		center += player.position
	
	position = center/(players_node.get_child_count() as float) + offset
