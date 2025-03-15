extends CharacterState

@export var idle: CharacterState
@export var wreck: CharacterState

@export_range(0.5,10) var speed: float = 0.5
@export_range(0.01, 5) var close_distance: float = 0.3

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func on_enter_state(data: RalphStateMachine.RalphState):
	data.anim.play("walk_side")
	audio.play()

func on_exit_state(_data: RalphStateMachine.RalphState):
	audio.stop()

func process(_delta: float, data: RalphStateMachine.RalphState):
	if data.ralph.target == null:
		return idle
	
	var direction = data.ralph.target.get_position() - data.ralph.position
	
	if direction.length() < close_distance:
		return wreck

	var v: Vector3 = speed * (1+data.ralph.anger/4) * direction.normalized()
	
	if abs(v.x) > abs(v.z):
		data.anim.play("walk_side")
		data.anim.scale.x = v.x / abs(v.x)
	elif v.z < 0:
		data.anim.play("walk_back")
		data.anim.scale.x = 1
	else:
		data.anim.play("walk_forward")
		data.anim.scale.x = 1
	
	data.ralph.velocity = v
	data.ralph.move_and_slide()
