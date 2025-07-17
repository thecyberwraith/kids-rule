class_name PauseMenu
extends Control
## Orchestrates transfer of focus between tab selection and tabs, and gives
## access to parent menu to tabs.

@onready var tabs: TabContainer = $PanelContainer/MarginContainer/HBoxContainer/TabContainer
@onready var buttons: VBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer
@onready var input_label: Label = $PanelContainer/MarginContainer/Label

@export var include_resume: bool = true
@export var include_home: bool = true
@export var player_selection_scene: PackedScene = null
@export var additional_tabs: Array[PauseMenuPanel] = []

signal game_resumed

var pausing_input: PlayerInput = null:
	set(value):
		pausing_input = value
		
		if pausing_input != null:
			input_label.text = "Paused by %s" % pausing_input.to_string()
			pausing_input.attach_to_ui()
		else:
			input_label.text = ""

var tabs_insertion_index = 1
var before_quit_index = -2
var players_idx = -1

func _ready():
	if not include_resume:
		var resume: Control = tabs.find_child("Resume")
		tabs.remove_child(resume)
		resume.queue_free()
		tabs_insertion_index -= 1
	
	if not include_home:
		var home: Control = tabs.find_child("Home")
		tabs.remove_child(home)
		home.queue_free()
		before_quit_index += 1
	
	if not player_selection_scene == null:
		tabs.find_child("Players").queue_free()
		additional_tabs.insert(0, player_selection_scene.instantiate())

	for tab in additional_tabs:
		tabs.add_child(tab)
		tabs.move_child(tab, before_quit_index)

	players_idx = tabs.get_children().find_custom(func(x): return x.name == "Players")
	
	_create_buttons()
	_check_for_emtpy_inputs()

	PlayerInputs.input_disconnected.connect(_check_for_emtpy_inputs)


func _check_for_emtpy_inputs():
	if PlayerInputs.active.size() == 0:
		switch_to_player_panel()


func _create_buttons():
	for child in tabs.get_children():
		var button = Button.new()
		button.text = child.name
		buttons.add_child(button)

	if buttons.get_child_count() > 0:
		for button_idx in buttons.get_child_count():
			var button: Button = buttons.get_child(button_idx)
			button.focus_next = buttons.get_child(wrapi(button_idx+1, 0, buttons.get_child_count())).get_path()
			button.focus_neighbor_bottom = button.focus_next
			button.focus_neighbor_right = button.focus_next
			button.focus_previous = buttons.get_child(wrapi(button_idx-1, 0, buttons.get_child_count())).get_path()
			button.focus_neighbor_top = button.focus_previous
			button.focus_neighbor_left = button.focus_previous
			button.pressed.connect(func(): _select_panel(button_idx))
			button.focus_entered.connect(func(): tabs.current_tab = button_idx)
		print("Giving focus to button on new menu ", buttons.get_child(0).text)
		buttons.get_child(0).call_deferred("grab_focus")


## Handle the action of a pause menu button. For regular panels, the focus will
## be given to the panel. The other actions are as follows:
## - Resume: unpause the menu
## - Home: Change scenes to the home level
## - Quit: Well... it quits.
func _select_panel(panel: int):
	var panel_name: String = tabs.get_child(panel).name
	
	if panel_name == "Resume":
		unpause()
	elif panel_name == "Home":
		print("Going home from menu.")
		get_tree().paused = false
		get_tree().change_scene_to_file("res://levels/home/home.tscn")
	elif panel_name == "Quit":
		print("Quitting game from the menu.")
		get_tree().quit()
	else:
		print("Selecting generic panel.")
		var pause_panel: PauseMenuPanel = tabs.get_child(panel)
		tabs.current_tab = panel
		pause_panel.previous_focus = buttons.get_child(panel)
		pause_panel.pause_menu = self
		pause_panel.call_deferred("grab_focus")


## Pauses the game, shows the Players panel, and gives the focus to that Panel
func switch_to_player_panel():
	print("Performing switch to player panel.")
	pause(null, "Players")
	_select_panel(players_idx)


## Pause the game and select a button (by button text) to have highlighted. The
## default is to show the first button.
func pause(input: PlayerInput, highlight: String = ""):
	get_tree().paused = true
	visible = true
	pausing_input = input
	print("Pausing scene by ", input)
	
	var button_idx := 0
	
	if highlight.length() > 0:
		button_idx = buttons.get_children().find_custom(func(x): return x.text == highlight)
		if button_idx < 0:
			button_idx = 0
	
	print("Giving focus to button ", buttons.get_child(button_idx).text)
	buttons.get_child(button_idx).call_deferred("grab_focus")


func unpause():
	print("Unpausing the menu.")
	get_tree().paused = false
	visible = false
	pausing_input = null
	game_resumed.emit()


func _process(_delta):
	if not get_tree():
		return
	
	if not get_tree().paused:
		detect_pause_request()


func detect_pause_request():
	var pausing_input_idx := PlayerInputs.active.find_custom(
			func(x): return x.get_menu_pressed())

	if pausing_input_idx > -1:
		pause(PlayerInputs.active[pausing_input_idx])
