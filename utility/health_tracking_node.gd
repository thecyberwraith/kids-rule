## Report when all children nodes have zero health, assuming
## that each child node has a DamageHandler
class_name HealthTrackingNode extends Node

signal all_health_drained

var healths: Array[CharacterResource] = []
func _ready():
	child_order_changed.connect(func():
		for handler in healths:
			if handler.value_changed.is_connected(_on_node_health_change):
				handler.health.value_changed.disconnect(_on_node_health_change)
		healths = _get_damage_handlers()
		for handler in healths:
			if not handler.value_changed.is_connected(_on_node_health_change):
				handler.value_changed.connect(_on_node_health_change)
	)

func _get_damage_handlers() -> Array[CharacterResource]:
	var arr: Array[CharacterResource] =[]
	for child in get_children():
		var damage: DamageHandler = child.get_node_or_null("DamageHandler")
		if not damage:
			push_warning("Child does not have a damage handler: ", child)
			continue
		arr.append(damage.health)
	
	return arr

func _on_node_health_change(_health, _diff):
	for handler in healths:
		if handler.min_value < handler.value:
			return
	all_health_drained.emit()
