extends CharacterState

@export var idle: CharacterState
@onready var timer: Timer = $Timer

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

var next_state: CharacterState

func set_shader_parameters(data, values):
	var node = data.character.get_node("SubViewport/AnimatedSprite2D")
	var keys = ["ossilation_rate", "min_intensity"]
	for i in keys.size():
		node.material.set_shader_parameter(keys[i], values[i])

func on_enter_state(data: StateMachine.Dependencies):
	next_state = null
	sound.play()
	set_shader_parameters(data, [16, 0.4])
	timer.timeout.connect(func():
		next_state = idle
	)
	timer.start(data.character.damage.invincible_duration / 2)
	var ranger := data.character as RangerPlayer
	
	ranger.damage.invincibility_stop.connect( func():
		set_shader_parameters(data, [0, 0.0]),
		CONNECT_ONE_SHOT
	)
	ranger.animation.play("damaged")

func process(_dt, _data):
	return next_state
