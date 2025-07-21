class_name SettingsPanelItemSeparator extends HBoxContainer

var label: String:
	set(value):
		$Label.text = value.capitalize()
