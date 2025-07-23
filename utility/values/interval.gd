## Handles logic for an interval between two floating numbers. These are closed
## intervals (not that it matters much in this class).
class_name Interval extends Resource

## The lower bound of the interval.
@export var a: float = 0.0:
	set(value):
		if value > b:
			value = b
		a = value
		bounds_changed.emit()


@export var b: float = 1.0:
	set(value):
		if value < a:
			value = a
		b = value
		bounds_changed.emit()

var length: float:
	get:
		return b - a

signal bounds_changed


func _init(x: float = 0.0, y: float=1.0):
	if x <= y:
		a = x
		b = y
	else:
		push_warning("Interval corrected %s > %s error." % [x,y])
		a = y
		b = x


func clamp(value: float) -> float:
	return clampf(value, a, b)


func _to_string() -> String:
	return "[%s, %s]" % [a,b]
