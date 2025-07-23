## Here we track a given value that exists within a certain range. Can be used
## for things like mana, health, skill cooldowns, etc.
class_name ResourceValue extends Resource

@export var name := "Resource"
@export var interval := Interval.new()
@export var value: float = 5.0:
	set(val):
		val = interval.clamp(val)

		var diff: = val - value
		value = val
		if diff != 0:
			value_changed.emit(self, diff)

var percentage: float:
	get():
		return (value - interval.minimum) / interval.length

signal value_changed(resource: ResourceValue, difference: float)


func _init(a_name: String = "Resource", a_min: float = 0.0, a_max: float = 10.0 , a_value: float = 5.0):
	name = a_name
	interval = Interval.new(a_min, a_max)
	value = a_value


func _to_string():
	return "Value[%s]=%s in %s" % [name, value, interval]


## Takes a progress bar and attaches the resource's [signal value_changed] to
## an anonmymous lambda which updates the bar accordingly.
func connect_to_progress_bar(bar: ProgressBar):
	var callback := func(_resource, _difference):
		bar.value = value
		bar.max_value = interval.maximum
		bar.min_value = interval.minimum
	
	callback.call(null, null)
	value_changed.connect(callback)
