class_name CharacterResource extends Resource

@export var name := "HEALTH"
@export var min_value: float = 0.0:
	set(val):
		if val > max_value:
			val = max_value
		min_value = val

		if value < min_value:
			value = min_value

@export var max_value: float = 10.0:
	set(val):
		if val < min_value:
			val = min_value
		max_value = val
		
		if value > max_value:
			value = max_value
		
@export var value: float = 5.0:
	set(val):
		if val > max_value:
			val = max_value
		elif val < min_value:
			val = min_value

		var diff: = val - value
		value = val
		if diff != 0:
			value_changed.emit(self, diff)

var percentage: float:
	get():
		return (value - min_value) / (max_value - min_value)

signal value_changed(resource: CharacterResource, difference: float)

func _init(a_name: String = "Health", a_min: float = 0.0, a_max: float = 10.0 , a_value: float = 5.0):
	name = a_name
	min_value = a_min
	max_value = a_max
	value = a_value

func _to_string():
	return "Value[%s]=%s in [%s,%s]" % [name, value, min_value, max_value]
