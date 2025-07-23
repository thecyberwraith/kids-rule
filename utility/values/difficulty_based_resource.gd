## Allows signals based interaction with a numerical value. In addition, the
## value is difficulty aware.
class_name DifficultyBasedResource extends Resource

@export var name := "HEALTH"

@export var default := Interval.new(0.0, 10.0)

## If a specific difficulty is set, these intervals will override the default.
@export var difficulty_map :Dictionary[Settings.Difficulty, Interval] = {}

@warning_ignore("shadowed_global_identifier")
var range: Interval:
	get:
		var difficulty: Settings.Difficulty = Settings.get_setting("game", "difficulty")
		if difficulty in difficulty_map:
			return difficulty_map[difficulty]
		else:
			return default
 
@export var value: float = 5.0:
	set(val):
		var interval := range
		val = clampf(val, interval.a, interval.b)

		var diff: = val - value
		value = val
		if diff != 0:
			value_changed.emit(self, diff)


var percentage: float:
	get():
		return (value - range.a) / (range.length)

signal value_changed(resource: DifficultyBasedResource, difference: float)


func _init(a_name: String = "Health", a_min: float = 0.0, a_max: float = 10.0 , a_value: float = 5.0):
	name = a_name
	default.a = a_min
	default.b = a_max
	value = a_value
	default.bounds_changed.connect(_bounds_update)
	for item in difficulty_map.values():
		item.bounds_changed.connect(_bounds_update)


func _to_string():
	return "%s=%s in %s" % [name, value, range]


func _bounds_update():
	value = value


func connect_to_progress_bar(bar: ProgressBar):
	var callback := func(_resource, _difference):
		bar.value = value
		bar.max_value = range.b
		bar.min_value = range.a
	
	callback.call(null, null)
	value_changed.connect(callback)
