extends CharacterState

var move_direction = 1.0
var need_updated_pose: bool = false

@export var attack: CharacterState

@export var wander_length = 4
@export var wander_speed = 3

@onready var pose_timer: Timer = $PoseTimer
@onready var attack_timer: Timer = $AttackTimer

func on_enter_state(zurg: Zurg):
	zurg.sprite.play("standing")
	zurg.sprite.stop()
	need_updated_pose = true
	pose_timer.timeout.connect(update_pose)
	attack_timer.start()

func update_pose():
	need_updated_pose = true

func process(dt: float, zurg: Zurg):
	if need_updated_pose:
		zurg.sprite.frame = wrapi(zurg.sprite.frame+randi_range(1,2), 0, 3)
		need_updated_pose = false
	
	if zurg.position.z > wander_length:
		move_direction = -1
	elif zurg.position.z < -wander_length:
		move_direction = 1
	
	zurg.position.z += move_direction * wander_speed * dt
	
	if attack_timer.time_left == 0:
		return attack
	
	return null

func on_exit_state(_zurg: Zurg):
	pose_timer.timeout.disconnect(update_pose)
