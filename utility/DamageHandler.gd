class_name DamageHandler extends Node

@export var health := CharacterResource.new("Health", 0.0, 10.0, 10.0)
@export var invincible_duration: float = 1.5

var invincible_time = 0.0

signal damaged(amount: float)
signal healed(amount: float)

signal invincibility_stop
signal death

func _ready():
	health.value_changed.connect(_handle_new_health_value)

func damage(amount: float):
	if invincible_time > 0:
		return
	
	health.value -= amount

func _handle_new_health_value(_res: CharacterResource, diff: float):
	if diff < 0:
		if health.value == 0:
			death.emit()
		else:
			invincible_time = invincible_duration
			damaged.emit(-diff)
	if diff > 0:
		healed.emit(diff)

func _process(dt):
	if invincible_time == 0.0:
		return
	
	invincible_time -= dt
	
	if invincible_time <= 0.0:
		invincibility_stop.emit()
