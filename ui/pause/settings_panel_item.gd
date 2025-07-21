class_name SettingsPanelItem
extends HBoxContainer

@onready var label: Label = $Label


var setting: SettingsItem:
	set(value):
		setting = value
		label.text = setting._key.capitalize()
		if get_child_count() > 1:
			for i in range(1, get_child_count()):
				get_child(i).queue_free()
		
		add_child(setting.get_editor_control())

var control: Control:
	get:
		if get_child_count() > 1:
			return get_child(1)
		else:
			return null
