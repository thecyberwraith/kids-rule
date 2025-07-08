extends PlayerInput
class_name KeyboardInput

@export var index: int = 1

func _init(_index: int = 1):
	index = _index
	
	if index < 1 or index > 2:
		push_error("Keyboard input %s requested, but must be 1 or 2" % _index)
		index = 1
	
	_create_action_names("key_%s" % index)

func _to_string() -> String:
	return "Keyboard Input %s" % index
