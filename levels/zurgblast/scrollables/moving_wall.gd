extends ScrollingAnimatableBody

@onready var damage_area: Area3D = $Area3D

func _ready():
	damage_area.body_entered.connect(func(body):
		var damage: DamageHandler = body.get_node_or_null("DamageHandler")
		
		if damage:
			damage.damage(1)
	)

func _process(dt):
	super._process(dt)
	for body in damage_area.get_overlapping_bodies():		
		var damage: DamageHandler = body.get_node_or_null("DamageHandler")
		
		if damage:
			damage.damage(1)
