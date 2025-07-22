## A setting that must match a particular enum. It stores and retrieves only
## integers, so ensure the enum has a fixed integer map in case the enum is 
## updated later.

class_name SettingsItemEnum
extends SettingsItem

var _enum_dict: Dictionary[String, int] = {}


@warning_ignore("shadowed_variable_base_class")
func _init(section: String, key: String, default: int, enum_type: Dictionary):
	for some_key in enum_type:
		if not typeof(some_key) == TYPE_STRING:
			push_warning("Enum key %s is not a string!" % some_key)
		elif not typeof(enum_type[some_key]) == TYPE_INT:
			push_warning("Enum value %s for %s is not an integer" % [some_key, enum_type[some_key]])
		else:
			_enum_dict[some_key as String] = enum_type[some_key] as int

	super._init(section, key, default)


func _validate_settings_value(value: Variant):
	return (
		typeof(value) == TYPE_INT and value in _enum_dict.values()
	)


func get_editor_control() -> OptionButton:
	var control := OptionButton.new()
	
	for option in _enum_dict:
		control.add_item(option, _enum_dict[option])

	control.selected = get_value()
	control.item_selected.connect(func(idx):
		set_value(control.get_item_id(idx))
	)
	return control
