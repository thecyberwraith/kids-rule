extends AnimatedState

@export var idle: CharacterState
@export var defeat: CharacterState

@onready var timer: Timer = $Timer

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

var next_state: CharacterState


func set_shader_parameters(data, values):
	var node = data.character.get_node("SubViewport/AnimatedSprite2D")
	var keys = ["ossilation_rate", "min_intensity"]
	for i in keys.size():
		node.material.set_shader_parameter(keys[i], values[i])


func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	next_state = null
	sound.play()
	set_shader_parameters(data, [16, 0.4])
	timer.timeout.connect(func():
		var state = data.character.get_node("DamageHandler").state
		if state == DamageHandler.State.ALIVE:
			next_state = idle
		else:
			next_state = defeat,
		CONNECT_ONE_SHOT
	)
	timer.start(data.character.damage.invincible_duration / 2)
	var ranger := data.character as RangerPlayer
	
	ranger.damage.invincibility_stop.connect( func():
		set_shader_parameters(data, [0, 0.0]),
		CONNECT_ONE_SHOT
	)


func process(_dt, data: StateMachine.Dependencies):
	data.character.velocity = Vector3.ZERO
	data.character.move_and_slide()

	return next_state
