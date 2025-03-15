extends PlayerInput
class_name KeyboardInput

var index: int = 1

var left: String
var right: String
var up: String
var down: String

func _init(_index: int):
	index = _index
	
	if index < 1 or index > 2:
		push_error("Keyboard input %s requested, but must be 1 or 2" % _index)
		index = 1
	
	left = "key_%s_left" % index
	right = "key_%s_right" % index
	up = "key_%s_up" % index
	down = "key_%s_down" % index
	accept_name = "key_%s_accept" % index
	cancel_name = "key_%s_cancel" % index
	menu_name = "key_%s_menu" % index

func _to_string() -> String:
	return "Keyboard Input %s" % index

func get_horizontal() -> float:
	return Input.get_axis(left, right)

func get_vertical() -> float:
	return Input.get_axis(down, up)
