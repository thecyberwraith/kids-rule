## Automates switch statements on which value to used based on the difficulty
## setting of the game.
## Warning: Requires the Settings to be ready before calling the value's getter.
class_name DifficultyBasedInt extends Resource

@export var default : int = 0
@export var difficulty_map: Dictionary[Settings.Difficulty, int] = {}

## The actual value, after checking the settings.
var value: int:
	get:
		if not Settings.is_node_ready() or not Settings.get_setting("game", "difficulty") in difficulty_map:
			return default
		else:
			return difficulty_map[Settings.get_setting("game", "difficulty")]


func _init(default_value: int=0):
	default = default_value


func _to_string():
	return "%s" % value
