extends PauseMenuPanel

@onready var container: VBoxContainer = $VBoxContainer

var settings_item: PackedScene = preload("res://ui/pause/settings_panel_item.tscn")
var settings_sep: PackedScene = preload("res://ui/pause/settings_panel_item_separator.tscn")

var controls: Array[Control] = []

func _ready():
	_populate_settings()
	focus_entered.connect(func(): controls[0].grab_focus())


func _populate_settings():
	var last_section: String = ""

	for setting in Settings.DEFAULTS:
		if last_section != setting._section:
			var new_sep: SettingsPanelItemSeparator = settings_sep.instantiate()
			new_sep.label = setting._section
			container.add_child(new_sep)
			last_section = setting._section

		var new_control: SettingsPanelItem = settings_item.instantiate()
		container.add_child(new_control)
		new_control.setting = setting
		controls.append(new_control.control)
