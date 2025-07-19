## A settings item that simply verifies the value has a specific typeof value.
class_name SettingsItemBuiltin
extends SettingsItem

var _type: Variant.Type


func _init(section: String, key: String, default: Variant, type: Variant.Type):
	_type = type
	super._init(section, key, default)
	

func _validate_settings_value(value: Variant):
	return typeof(value) == _type
