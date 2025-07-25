extends CharacterState

@export var wander: CharacterState
@export var mines_template: PackedScene
## How much quicker he drops mines (animations-wise) when damaged.
@export var damage_speed_factor := DifficultyBasedFloat.new(2)
## Low end of how many mines he drops.
@export var minimum_mines := DifficultyBasedInt.new(4)
## High end of how many mines he drops.
@export var maximum_mines := DifficultyBasedInt.new(6)

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

enum SUBSTATE {ANIMATING, DROP_NEEDED, WAIT_FOR_SOUND, DONE}

var sub_state: SUBSTATE = SUBSTATE.ANIMATING
var mines_left: int = 0
var move_direction = 1

func on_enter_state(zurg: Zurg):
	mines_left = lerp(maximum_mines.value, minimum_mines.value, zurg.damage.health.percentage)

	prep_drop(zurg)


func on_exit_state(zurg: Zurg):
	zurg.sprite.speed_scale = 1


func prep_drop(zurg: Zurg):
	zurg.sprite.play("hand2")
	zurg.sprite.speed_scale = lerpf(damage_speed_factor.value, 1, zurg.damage.health.percentage)
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
