class_name PlayerSelection extends PauseMenuPanel

@export var game_info_key: String = ""

@onready var container = $MarginContainer/VBoxContainer/VBoxContainer
@onready var instructions = $MarginContainer/VBoxContainer/Label

var RowTemplate = preload("res://ui/player_selection/player_information_row.tscn")

func _ready():
	visibility_changed.connect(func():
		if is_visible_in_tree():
			_update_input_list()
	)
	
	focus_entered.connect(func ():
		print("Enabling player selection.")
		PlayerInput.clear_ui_attachments()
		_set_all_process(true),
		CONNECT_DEFERRED
	)
	
	focus_exited.connect(func ():
		print("Disabling player selection.")
		if pause_menu and pause_menu.pausing_input:
			pause_menu.pausing_input.attach_to_ui()
		_set_all_process(false),
		CONNECT_DEFERRED
	)
	
	PlayerInputs.input_activated.connect(_add_child_row)
	PlayerInputs.input_deactivated.connect(_remove_child_row)
	
	print("Starting off with a disabled selection panel.")
	_set_all_process(false)



func _set_all_process(val: bool):
	set_process(val)
	container.get_children().map(func(x): x.set_process(val))


func _set_instructions():
	if container.get_child_count() == 0:
		instructions.text = "Press your primary button to join!"
	else:
		instructions.text = "Press your menu button when all player's are here!"

func _update_input_list():
	for child in container.get_children():
		child.queue_free()
		container.remove_child(child)

	for input in PlayerInputs.active:
		_add_child_row(input)

	_set_instructions()

func _add_child_row(input: PlayerInput):
	var info := PlayerInputs.get_prefs_for(input)
	var new_row: PlayerInformationRow = RowTemplate.instantiate()
	
	container.add_child(new_row)
	
	new_row.player = container.get_child_count()
	new_row.input = input
	
	for character in Characters.all:
		if character.equals(info.character):
			new_row.character_idx = Characters.all.find(character)
	
	new_row.set_process(has_focus())
	_set_instructions()


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
	
	_set_instructions()


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
	if not PlayerInputs.active.any(func (x): return x.get_menu_pressed()):
		return
	print("Input requested exit player selection.")
	_store_player_choices()
	_validate_pausing_input()
	return_focus()


func _store_player_choices():
	for row in container.get_children():
		var info:= PlayerInputs.ControllerPreference.new()
		info.character = Characters.all[row.character_idx]
		if game_info_key.length() > 0:
			info.extra[game_info_key] = row.get_game_info()
		PlayerInputs.set_prefs_for(row.input, info)

func _validate_pausing_input():
	var pausing_input = pause_menu.pausing_input
	
	if (pausing_input == null
		or 
		not pausing_input.to_string() in PlayerInputs.active.map(func(x): return x.to_string())
		):
		pausing_input = container.get_child(0).input
	
	pause_menu.pausing_input = pausing_input
