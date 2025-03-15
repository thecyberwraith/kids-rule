extends PanelContainer
class_name PlayerSelection

@onready var container = $MarginContainer/VBoxContainer
var RowTemplate = preload("res://ui/player_information_row.tscn")

static var AvailableCharacters: Array[PlayerData.CharacterInfo] = [
	PlayerData.CharacterInfo.new("Ellie", "res://players/ellie.tscn"),
	PlayerData.CharacterInfo.new("Sam", "res://players/sam.tscn"),
]

signal player_details_ready(PlayerSelection)

func _ready():
	var valid_infos := 0
	for i in JoinedControllers.controllers.size():
		var controller := JoinedControllers.controllers[i]
		var info := JoinedControllers.stored_controller_info.get(
			controller.to_string(),
			null
		) as PlayerData.CharacterInfo
		if info != null:
			valid_infos += 1
			print("Recovering player info.")

		_add_child_row(controller, info)
	
	if valid_infos > 0:
		print("Emitting player creations")
		player_details_ready.emit(self)

func _add_child_row(input: PlayerInput, info: PlayerData.CharacterInfo):
	var new_row: PlayerInformationRow = RowTemplate.instantiate()
	container.add_child(new_row)
	new_row.player = container.get_child_count()
	new_row.input = input
	if info in AvailableCharacters:
		new_row.character_idx = AvailableCharacters.find(info)

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

	else:
		visible = false
		for input in active_inputs:
			if input.get_cancel_pressed():
				get_tree().paused = true
				print("Pausing scene.")

func get_inactive_and_active_controllers() -> Array:
	var available_inputs: Array[PlayerInput] = JoinedControllers.AvailableInputs.duplicate()
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
			_add_child_row(input, null)

func detect_close_dialog_request(taken_inputs: Array[PlayerInput]):
	for input in taken_inputs:
		if input.get_accept_pressed():
			get_tree().paused = false
			print("Resuming scene.")
			store_player_details()
			player_details_ready.emit(self)
			return

func store_player_details():
	var controllers_map: Dictionary[String,PlayerData.CharacterInfo] = {}
	var controllers: Array[PlayerInput] = []
	for child in container.get_children():
		var row := child as PlayerInformationRow
		controllers.append(row.input)
		controllers_map[row.input.to_string()] = AvailableCharacters[row.character_idx]
	
	JoinedControllers.controllers = controllers
	JoinedControllers.stored_controller_info = controllers_map

func get_visuals_for(input: PlayerInput) -> String:
	for child in container.get_children():
		if child.input == input:
			return AvailableCharacters[child.character_idx].path
	
	return ""
