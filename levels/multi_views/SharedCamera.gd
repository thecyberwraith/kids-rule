extends Camera3D
class_name SharedCamera

@export var players: Array[Player] = []
var offset: Vector3

func _ready():
	offset = position

func _process(_delta):
	if players.size() == 0:
		return

	var center := Vector3.ZERO
	for player in players:
		center += player.position
	
	position = center/(players.size() as float) + offset

func assign_from_node(a_node: Node3D):
	var new_players: Array[Player] = []
	
	for child in a_node.get_children():
		if not is_instance_of(child, Player):
			push_error("We have a non-player node in a shared Camera!")
		new_players.append(child)
	
	players = new_players
