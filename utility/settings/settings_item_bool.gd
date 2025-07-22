class_name SettingsItemBool
extends SettingsItemBuiltin


func _init(a_section: String, a_key: String, a_default: bool):
	super._init(a_section, a_key, a_default, TYPE_BOOL)


func get_editor_control() -> CheckButton:
	var button := CheckButton.new()
	button.button_pressed = get_value()
	button.toggled.connect(set_value)
	return button
