class_name PauseMenuPanel
extends Control
## Handles transfer of focus between tab selector and tabs.

var previous_focus: Control
var pause_menu: PauseMenu

func return_focus():
	previous_focus.grab_focus()
