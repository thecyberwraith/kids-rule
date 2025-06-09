class_name Zurg extends ScrollingCharacter

@export var sprite: AnimatedSprite2D

@onready var launcher: ZurgLauncher = $LaunchRays
@onready var damage: DamageHandler = $DamageHandler
@onready var machine: GenericStateMachine = $GenericStateMachine
@onready var damage_state: CharacterState = $GenericStateMachine/damaged

func _ready():
	damage.damaged.connect(func(change):
		print("Zurg damaged ", change)
		machine.transition_to_state(damage_state))

	damage.death.connect(func():
		machine.transition_to_state(null)
		sprite.play("defeat")
	)
