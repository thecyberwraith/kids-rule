## Automates switch statements on which value to used based on the difficulty
## setting of the game.
## Warning: Requires the Settings to be ready before calling the value's getter.
class_name DifficultyBasedFloat extends Resource

@export var default: float = 0.0
@export var difficulty_map: Dictionary[Settings.Difficulty, float] = {}

var value: float:
	get:
		if not Settings.is_node_ready() or not Settings.get_setting("game", "difficulty") in difficulty_map:
			return default
		else:
			return difficulty_map[Settings.get_setting("game", "difficulty")]


func _init(default_value: float=0.0):
	default = default_value


func _to_string():
	return "%s" % value
