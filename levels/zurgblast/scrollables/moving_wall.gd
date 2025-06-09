extends ScrollingCharacter

@onready var gentle_push_area: Area3D = $Area3D

func _ready():
	pass

func _process(dt):
	super._process(dt)
	for body in gentle_push_area.get_overlapping_bodies():
		if not is_instance_of(body, CharacterBody3D):
			continue
		
		var character := body as CharacterBody3D
		var push_factor: float = max(body.position.x - position.x - 1.2, 0.02)
		
		character.velocity = Vector3.RIGHT * camera.move_speed /push_factor
		character.move_and_slide()
		
		var damage: DamageHandler = body.get_node_or_null("DamageHandler")
		
		if damage:
			damage.damage(1)
