## A single setting which is type enforced. This class should not be used 
## directly, and should instead be subclasses with a custom
## [method SettingsItem._validate_settings_value] method.
class_name SettingsItem
extends Resource

## The section (like an ini file) to group the setting under.
var _section: String
## The key, which should be unique within a section.
var _key: String
## The default value which is loaded when not already specified in the settings.
var _default: Variant


func _init(section: String, key: String, default: Variant):
	_section = section
	_key = key
	_default = default

	if not _validate_settings_value(_default):
		push_error("Settings %s/%s does not pass type check for default %s" % [
			_section,
			_key,
			_default,
		])


## Must override. Verifies that the value for the setting is legitimate.
func _validate_settings_value(_value: Variant) -> bool:
	return false


## Checks if the value is of the correct type. If value is null, then we
## check the value already stored in the settings.
func validate(value: Variant = null):
	if value == null:
		value = Settings.get_value(_section, _key)
	else:
		return _validate_settings_value(value)
