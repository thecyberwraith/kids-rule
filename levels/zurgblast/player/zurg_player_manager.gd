extends PlayerManager

@export var spawn_ray: RayCast3D
@export var zurg_player_script: Script

signal all_health_drained


func create_player_for_input(input: PlayerInput):
	super.create_player_for_input(input)
	
	var player: RangerPlayer = player_map[input.to_string()]
	
	if spawn_ray.is_colliding():
		player.global_position = spawn_ray.get_collision_point()
	else:
		player.global_position = Vector3.ZERO

	var player_order = player_map.keys()
	player_order.sort()
	
	var index = player_order.find(input.to_string())
	
	player.global_position.z = (-1)**(index+1)*ceili(index / 2.0)
	
	player.add_to_group("rangers")


func update_player_for_template(input: PlayerInput):
	var player := player_map[input.to_string()] as RangerPlayer
	player.character = PlayerInputs.get_prefs_for(input).character
	player.input = input
	player.body.modulate = PlayerInputs.get_prefs_for(input).extra["ZURG"].color


var healths: Array[DamageHandler] = []

func _ready():
	super._ready()
	child_order_changed.connect(_on_child_order_changed)
	_on_child_order_changed()

## Should be called right before the scene is changed.
func prepare_unload():
	child_order_changed.disconnect(_on_child_order_changed)

func _on_child_order_changed():
	for handler in healths:
		if handler.damaged.is_connected(_on_node_health_change):
			handler.damaged.disconnect(_on_node_health_change)

	healths = _get_damage_handlers()

	for handler in healths:
		if not handler.damaged.is_connected(_on_node_health_change):
			handler.damaged.connect(_on_node_health_change)

func _get_damage_handlers() -> Array[DamageHandler]:
	var arr: Array[DamageHandler] =[]
	for child in get_children():
		var damage: DamageHandler = child.get_node_or_null("DamageHandler")
		if not damage:
			push_warning("Child does not have a damage handler: ", child)
			continue
		arr.append(damage)
	
	return arr

func _on_node_health_change(_diff):
	for handler in healths:
		if handler.is_alive:
			return
	all_health_drained.emit()
