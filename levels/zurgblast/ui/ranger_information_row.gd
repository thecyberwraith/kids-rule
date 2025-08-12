extends PlayerInformationRow

@onready var color: Panel = $HBoxContainer/VBoxContainer3/Color

var color_idx = 0

func _ready():
	super._ready()
	set_color(color_idx)


func after_input_changed():
	if (input != null
		and PlayerInputs.get_prefs_for(input).extra.has("ZURG")
		):
		set_color(RangerInfo.COLORS.find(
			PlayerInputs.get_prefs_for(input).extra["ZURG"]
		))


## Wraps and sets the color based on the RangerInfo.COLORS array.
func set_color(idx: int):
	color_idx = wrapi(idx, 0, RangerInfo.COLORS.size())
	color.get_theme_stylebox("panel").bg_color = RangerInfo.COLORS[color_idx]


func handle_player_input():
	if abs(input.get_vertical()) > 0.5:
		set_color(color_idx + input.get_vertical()/abs(input.get_vertical()))
		return true
	
	return super.handle_player_input()


func get_game_info() -> GameInfo:
	return RangerInfo.new(RangerInfo.COLORS[color_idx])
