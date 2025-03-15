## Assuming the _data has a player attribute
class_name AnimatedState
extends CharacterState

@export var animation: String = ""
@export var stop_on_exit: bool = false
## What property on the _data for the state to press play on
@export var animation_property: StringName = "visuals"

func on_enter_state(_data):
	_data.get(animation_property).play(animation)

func on_exit_state(_data):
	if stop_on_exit:
		_data.get(animation_property).stop()
