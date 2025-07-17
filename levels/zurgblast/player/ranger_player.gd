class_name RangerPlayer extends CharacterBody3D

@export var input : PlayerInput = PlayerInput.new()
@export var healing_burst_level : CharacterResource = CharacterResource.new(
	"Healing Burst",
	0.0,
	10.0,
	0.0
)

@onready var health_bar: ProgressBar = $Sprite3D/SubViewport/VBoxContainer/Health
@onready var healing_burst_bar: ProgressBar = $Sprite3D/SubViewport/VBoxContainer/HealingBurst

@onready var damage: DamageHandler = $DamageHandler
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var head: Sprite3D = $Visuals/head

@onready var healing_area: Area3D = $HealAffectArea

@onready var visuals : Node3D = $Visuals
@onready var character: CharacterInfo:
	set(value):
		character = value
		if head != null:
			var texture := load(character.head)
			head.texture = texture

@onready var launcher = $Visuals/LaserSpawn
@onready var shader: ShaderMaterial:
	get:
		return get_node("SubViewport/AnimatedSprite2D").material

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

	healing_burst_level.value_changed.connect(func(val: CharacterResource, _diff: float):
		healing_burst_bar.max_value = val.max_value
		healing_burst_bar.value = val.value
	)
	
	healing_burst_bar.max_value = healing_burst_level.max_value
	healing_burst_bar.value = healing_burst_level.value

func _process(delta):
	healing_burst_level.value += delta


func fire_laser():
	launcher.fire(1)
