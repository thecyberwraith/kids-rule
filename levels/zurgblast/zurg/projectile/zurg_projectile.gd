class_name ZurgProjectile extends RigidBody3D

@export var damage: float = 1.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	body_entered.connect(_on_hit_something)

func _on_hit_something(body: Node):
	var damage_handler: DamageHandler = body.get_node_or_null("DamageHandler")
	if damage_handler:
		damage_handler.damage(damage)

	queue_free()
