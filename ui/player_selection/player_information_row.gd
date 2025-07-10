extends Control
class_name PlayerInformationRow

@onready var player_ui := $HBoxContainer/VBoxContainer2/Player
@onready var input_ui := $HBoxContainer/VBoxContainer2/InputKind
@onready var character_ui := $HBoxContainer/VBoxContainer/Character
@onready var character_pic := $HBoxContainer/VBoxContainer/TextureRect

var player: int=1:
	set(value):
		player = value
		player_ui.text = "Player %s" % player

var input: PlayerInput:
	set(value):
		input = value
		input_ui.text = input.to_string()

#var visuals: PlayerData.CharacterInfo
var character_idx: int = -1:
	set(value):
		if value != character_idx:
			character_ui.text =  Characters.all[value].name
			character_pic.texture = load(Characters.all[value].head)
			print("Changing player %s to character %s." % [player, value])
		character_idx = value


func _ready():
	if character_idx == -1:
		character_idx = 0

var input_delay = 0.0
var max_delay = 0.5


func _process(delta):
	if input_delay > 0.0:
		input_delay -= delta
		return
	
	var horiz := input.get_horizontal()
	
	if abs(horiz) > 0.5:
		character_idx = wrapi(character_idx+(horiz/abs(horiz)), 0, Characters.all.size())
		input_delay = max_delay


func get_game_info() -> GameInfo:
	return null
