extends Control
class_name RalphUI

@onready var bar: ProgressBar = $ProgressBar
@onready var score: Label = $Label

var game_time: int:
	get:
		return floori(elapsed_time)

var elapsed_time: float = 0.0
var game_running: bool = true

## How long till you settle on the value in seconds
@export var transition_time = 0.5

var transition: float = 0.0
var old_value: float = 0.0
var new_value: float = 0.0

func _on_destruction_level_change(value: float):
	old_value = new_value
	new_value = value * 100
	transition = 0.0

func _process(delta):
	if transition < 1.0:
		transition = min(transition+delta/transition_time, 1.0)
		bar.value = lerpf(old_value, new_value, transition)

	if game_running:
		elapsed_time += delta
	score.text = "%s" % floori(game_time)
