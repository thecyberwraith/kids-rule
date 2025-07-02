extends CharacterState

@export var idle: CharacterState
@export var laser: CharacterState
@export var fall: CharacterState

@export var move_speed = 10

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

func on_enter_state(data: StateMachine.Dependencies):
	data.animations.play("walk")
	sound.play()

func on_exit_state(_data):
	sound.stop()

func process(_delta, data: StateMachine.Dependencies):
	if not data.character.is_on_floor():
		return fall
	
	var direction = data.input.get_xz_direction()
	if direction == Vector3.ZERO:
		return idle
	if data.input.get_accept_pressed():
		return laser
	
	data.character.velocity = move_speed * direction
	data.character.move_and_slide()
	
	return null
