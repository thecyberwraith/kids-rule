class_name PlayerSelection extends PanelContainer

@export var game_info_key: String = ""
@export var player_manager: PlayerManager

@onready var container = $MarginContainer/VBoxContainer

var RowTemplate = preload("res://ui/player_information_row.tscn")

signal player_details_ready(PlayerSelection)

func _ready():
	var all_inputs_valid = true

	for input in ActiveInputs.active_inputs:
		_add_child_row(input)
		player_manager.create_player_for_input(input)
		
		var prefs := ActiveInputs.preferences.get_for(input)
		if prefs.character == null:
			all_inputs_valid = false
			continue
		
		player_manager.update_player_for_template(input)
		
		if game_info_key.length() > 0 and prefs.extra[game_info_key] == null:
			all_inputs_valid = false
			continue
		
		player_manager.update_player_for_level_details(input)

	if all_inputs_valid:
		print("Emitting player creations")
		player_details_ready.emit(self)

func _add_child_row(input: PlayerInput):
	var info := ActiveInputs.preferences.get_for(input)
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
	player_manager.remove_player_for_input(input)

func _process(_delta):
	var input_arrays: Array = get_inactive_and_active_controllers()
	var inactive_inputs: Array[PlayerInput] = input_arrays[0]
	var active_inputs: Array[PlayerInput] = input_arrays[1]
	
	if active_inputs.is_empty():
		get_tree().paused = true
		
	if get_tree().paused:
		visible = true
		add_new_controllers(inactive_inputs)
		detect_close_dialog_request(active_inputs)
		remove_cancelled_controllers(active_inputs)

	else:
		visible = false
		for input in active_inputs:
			if input.get_menu_pressed():
				get_tree().paused = true
				print("Pausing scene.")

func get_inactive_and_active_controllers() -> Array:
	var available_inputs: Array[PlayerInput] = ActiveInputs.AvailableInputs.duplicate()
	var active_inputs: Array[PlayerInput] = []
	var inactive_inputs: Array[PlayerInput] = []
	
	var active_keys : Array[String] = []
	
	for child in container.get_children():
		active_keys.append((child as PlayerInformationRow).input.to_string())
	
	for input in available_inputs:
		if input.to_string() in active_keys:
			active_inputs.append(input)
		else:
			inactive_inputs.append(input)
	
	return [inactive_inputs, active_inputs]

func add_new_controllers(available_inputs: Array[PlayerInput]):
	for input in available_inputs:
		if input.get_accept_pressed():
			ActiveInputs.activate_input(input)
			_add_child_row(input)

func remove_cancelled_controllers(active_inputs: Array[PlayerInput]):
	for input in active_inputs:
		if input.get_cancel_pressed():
			_remove_child_row(input)
			ActiveInputs.deactivate_input(input)

func detect_close_dialog_request(taken_inputs: Array[PlayerInput]):
	for input in taken_inputs:
		if input.get_accept_pressed():
			get_tree().paused = false
			print("Resuming scene.")
			store_player_details()
			player_details_ready.emit(self)
			return

func store_player_details():
	for child in container.get_children():
		var row := child as PlayerInformationRow
		var new_character := Characters.all[row.character_idx]
		var new_game_info := row.get_game_info()
		var info := ActiveInputs.preferences.get_for(row.input)
		var update_needed := false

		if not new_character.equals(info.character):
			info.character = new_character
			update_needed = true
		
		if game_info_key.length() > 0 and not new_game_info.equals(info.extra[game_info_key]):
			info.extra[game_info_key] = new_game_info
			update_needed = true
		
		if row.input.to_string() not in player_manager.player_map:
			player_manager.create_player_for_input(row.input)
			update_needed = true
		if update_needed:
			player_manager.on_player_details_updated(row.input)
