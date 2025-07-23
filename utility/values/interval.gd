## Handles logic for an interval between two floating numbers. These are closed
## intervals (not that it matters much in this class).
class_name Interval extends Resource

## The lower bound of the interval.
@export var a:= DifficultyBasedFloat.new(0.0)
## Upper bound of the interval
@export var b:= DifficultyBasedFloat.new(1.0)

var minimum: float:
	get:
		return a.value
var maximum: float:
	get:
		return b.value
var length: float:
	get:
		return b.value - a.value


func _init(x: float = 0.0, y: float=1.0):
	if x <= y:
		a.value = x
		b.value = y
	else:
		push_warning("Interval corrected %s > %s error." % [x,y])
		a.value = y
		b.value = x


func clamp(value: float) -> float:
	return clampf(value, a.value, b.value)


func _to_string() -> String:
	return "[%s, %s]" % [a,b]
