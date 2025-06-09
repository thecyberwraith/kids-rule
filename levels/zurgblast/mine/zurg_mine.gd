extends RigidBody3D

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var detonation_area: Area3D = $DetonationArea
@onready var visibility_area: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var particles: CPUParticles3D = $CPUParticles3D
@onready var damage_area: Area3D = $DamageArea

var exploded: bool = false

@export_range(1,5) var mine_damage: int = 1

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(func (_body):
		print("Stopping mine ", self.name)
		freeze = true
		call_deferred("set_contact_monitor", false)
		max_contacts_reported = 0
		detonation_area.monitoring = true,
		CONNECT_ONE_SHOT
	)

	detonation_area.body_entered.connect(func (body: Node3D):
		print("Checking ", body.name)
		if not exploded and body.is_in_group("rangers"):
			print("Detonating mine ", self.name, " by ", body.name)
			exploded = true
			particles.emitting = true
			sprite.visible = false
			
			for other_body in damage_area.get_overlapping_bodies():
				print("Checking ", other_body.name)
				if other_body.is_in_group("rangers"):
					print("Damaging?...")
					var node: DamageHandler = other_body.get_node("DamageHandler") as DamageHandler
					node.damage(mine_damage)
		)
	
	particles.finished.connect(func(): queue_free(), CONNECT_ONE_SHOT)
	
	visibility_area.screen_exited.connect(func(): 
		print("mine off-screen")
		queue_free()
	)
