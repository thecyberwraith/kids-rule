class_name RangerPlayer extends CharacterBody3D

@onready var health_bar: ProgressBar = $Sprite3D/SubViewport/ProgressBar
@onready var damage: DamageHandler = $DamageHandler
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var head: Sprite3D = $Visuals/head

var input : PlayerInput = PlayerInput.new()

@onready var visuals : Node3D = $Visuals
@onready var character: CharacterInfo:
	set(value):
		character = value
		if head != null:
			var texture := load(character.head)
			head.texture = texture

@onready var launcher = $Visuals/LaserSpawn

func _ready():
	damage.damaged.connect(
		func(_diff):
			$StateMachine.transition_to_state($StateMachine/Damage)
	)
	damage.health.value_changed.connect(func(_val: CharacterResource, _diff: float):
		health_bar.max_value = damage.health.max_value
		health_bar.value = damage.health.value
	)
	
	health_bar.value = damage.health.value
	health_bar.max_value = damage.health.max_value

func fire_laser():
	launcher.fire(1)
