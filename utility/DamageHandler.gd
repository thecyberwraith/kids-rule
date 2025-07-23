## Automatics traditional handling of health. It handles:
## - Invincibility
## - Checking if alive
## - Common signals on types of health changes
class_name DamageHandler extends Node


@export var health := DifficultyBasedResource.new("Health", 0.0, 10.0, 5.0)
@export var full_health_on_ready := true

@export_category("Invincibility")
@export var invincible_duration: float = 1.5
@export var invincible_when_revived: bool = true

var is_alive: bool:
	get:
		return true if health.value > 0 else false

var is_invincible: bool:
	get:
		return _invincible_time > 0.0

var _invincible_time = 0.0

signal damaged(amount: float)
signal healed(amount: float)

signal invincibility_start
signal invincibility_stop
signal death
signal revived


func _ready():
	if full_health_on_ready:
		health.value = health.range.b
	
	health.value_changed.connect(_handle_new_health_value)


## Takes a positive amount of damage and applies it to the health, assuming
## the player is not invincible.
func damage(amount: float):
	if is_invincible or amount < 0:
		return
	
	health.value -= amount


## Takes a positive amount of healing and applies it to the health
func heal(amount: float):
	if amount < 0:
		return

	health.value += amount


func _start_invincibility():
	_invincible_time = invincible_duration
	invincibility_start.emit()


func _handle_new_health_value(_res: DifficultyBasedResource, diff: float):
	if diff < 0:
		damaged.emit(-diff)
		if health.value == 0:
			death.emit()
		else:
			_start_invincibility()
	if diff > 0:
		healed.emit(diff)
		if diff == health.value:
			revived.emit()
			if invincible_when_revived:
				_start_invincibility()


func _process(dt):
	if not is_invincible:
		return
	
	_invincible_time -= dt
	
	if not is_invincible:
		invincibility_stop.emit()
