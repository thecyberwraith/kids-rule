extends Player

const DAMAGE_NODE = "DamageHandler"

func on_level_manager_prep_done():
	if not get_node_or_null(DAMAGE_NODE):
		var node := DamageHandler.new()
		node.damaged.connect(func(x): print("Damage ", x))
		node.death.connect(func(): print("Death!!!"))
		node.healed.connect(func(x): print("Healed", x))
		add_child(node)
		node.name = DAMAGE_NODE
