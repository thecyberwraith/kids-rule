extends CharacterState

@export var wander: CharacterState
@export var mines_template: PackedScene

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

enum SUBSTATE {ANIMATING, DROP_NEEDED, WAIT_FOR_SOUND, DONE}

var sub_state: SUBSTATE = SUBSTATE.ANIMATING
var mines_left: int = 0
var move_direction = 1

func on_enter_state(zurg: Zurg):
	if zurg.damage.health.percentage < 0.4:
		mines_left = 5
	else:
		mines_left = 3

	prep_drop(zurg)

func prep_drop(zurg: Zurg):
	zurg.sprite.play("hand2")
	zurg.sprite.animation_finished.connect(func(): sub_state = SUBSTATE.DROP_NEEDED, CONNECT_ONE_SHOT)
	sub_state = SUBSTATE.ANIMATING

func mine_drop(zurg: Zurg):
	var mine: Node3D = mines_template.instantiate()
	get_tree().root.add_child(mine)
	mine.global_position = zurg.get_node("MineSpawnPoint").global_position
	mines_left -= 1
	
	sound.play()
	
	if mines_left == 0:
		sub_state = SUBSTATE.DONE
	else:
		prep_drop(zurg)

func process(dt: float, zurg: Zurg):
	if sub_state == SUBSTATE.DROP_NEEDED:
		mine_drop(zurg)
	elif sub_state == SUBSTATE.DONE:
		return wander
	
	if zurg.position.z > wander.wander_length:
		move_direction = -1
	elif zurg.position.z < -wander.wander_length:
		move_direction = 1
	
	zurg.position.z += move_direction * wander.get_speed(zurg) * dt * 1.5
	return null
