class_name RangerPlayer extends CharacterBody3D

@export var input : PlayerInput = PlayerInput.new()
@export var healing_burst_level : ResourceValue = ResourceValue.new(
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
@onready var body: Sprite3D = $Visuals/ranger

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
	damage.revived.connect(
		func():
			$StateMachine.transition_to_state($StateMachine/IdleState)
	)
	damage.health.connect_to_progress_bar(health_bar)
	healing_burst_level.connect_to_progress_bar(healing_burst_bar)

func _process(delta):
	healing_burst_level.value += delta


func fire_laser():
	launcher.fire(1)
