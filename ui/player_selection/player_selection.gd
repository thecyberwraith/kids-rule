class_name PlayerSelection extends PauseMenuPanel

@export var game_info_key: String = ""

@onready var container = $MarginContainer/VBoxContainer

var RowTemplate = preload("res://ui/player_selection/player_information_row.tscn")

func _ready():
	focus_entered.connect(func(): set_process(true))
	
	visibility_changed.connect(func():
		if is_visible_in_tree():
			_update_input_list()
	)
	
	PlayerInputs.input_activated.connect(_add_child_row)
	PlayerInputs.input_deactivated.connect(_remove_child_row)

	set_process(false)

func _update_input_list():
	for child in container.get_children():
		child.queue_free()

	for input in PlayerInputs.active:
		_add_child_row(input)


func _add_child_row(input: PlayerInput):
	var info := PlayerInputs.get_prefs_for(input)
	var new_row: PlayerInformationRow = RowTemplate.instantiate()
	
	container.add_child(new_row)
	
	new_row.player = container.get_child_count()
	new_row.input = input
	
	for character in Characters.all:
		if character.equals(info.character):
			new_row.character_idx = Characters.all.find(character)


func _remove_child_row(input: PlayerInput):
	var row: PlayerInformationRow = null
	for child in container.get_children():
		if (child as PlayerInformationRow).input.equals(input):
			row = child as PlayerInformationRow
			break
	
	if row == null:
		push_error("Cannot remove input ", input)
		return
	
	row.queue_free()


func _process(_delta):
	detect_close_dialog_request()
	add_new_controllers()
	remove_cancelled_controllers()


func add_new_controllers():
	for input in PlayerInputs.inactive:
		if input.get_accept_pressed():
			PlayerInputs.activate_input(input)

func remove_cancelled_controllers():
	if PlayerInputs.active.size() < 2:
		return

	for input in PlayerInputs.active:
		if input.get_cancel_pressed():
			PlayerInputs.deactivate_input(input)


func detect_close_dialog_request():
	if PlayerInputs.active.any(func (x): return x.get_menu_pressed()):
		print("Input requested exit player selection.")
		for row in container.get_children():
			var info:= PlayerInputs.ControllerPreference.new()
			info.character = Characters.all[row.character_idx]
			if game_info_key.length() > 0:
				info.extra[game_info_key] = row.get_game_info()
			PlayerInputs.set_prefs_for(row.input, info)
		set_process(false)
		return_focus()
