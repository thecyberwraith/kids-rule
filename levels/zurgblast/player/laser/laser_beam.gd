extends RigidBody3D

var damage = 1
@onready var timer: Timer = $Timer

func _ready():
	timer.timeout.connect(queue_free)
	body_entered.connect(on_hit)
	contact_monitor = true
	max_contacts_reported = 1

func on_hit(body: Node):
	var damage_handler = body.get_node_or_null("DamageHandler")
	if damage_handler:
		(damage_handler as DamageHandler).damage(damage)

	queue_free()
