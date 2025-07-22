## A single setting which is type enforced. This class should not be used 
## directly, and should instead be subclasses with a custom
## [method SettingsItem._validate_settings_value] method.
class_name SettingsItem
extends Resource

var _section: String
var _key: String
var _default: Variant


var section: String:
	get:
		return _section

var key: String:
	get:
		return _key

signal setting_changed(new_value)

## Creates a new, immutable setting:
## - [param section]: The section (like an ini file) to group the setting under.
## - [param key]: The key, which should be unique within a section.
## - [param default]: The default value which is loaded when not already specified in the settings.
@warning_ignore("shadowed_variable")
func _init(section: String, key: String, default: Variant):
	_section = section
	_key = key
	_default = default

	if not _validate_settings_value(_default):
		push_error("Settings %s/%s does not pass type check for default %s" % [
			section,
			key,
			_default,
		])


## Must override. Verifies that the value for the setting is legitimate.
func _validate_settings_value(_value: Variant) -> bool:
	return false


## Checks if the value is of the correct type. If value is null, then we
## check the value already stored in the settings.
func validate(value: Variant = null):
	if value == null:
		value = Settings.get_value(section, key)
	else:
		return _validate_settings_value(value)


## Sets the value using the Settings global node.
func set_value(value: Variant):
	if not validate(value):
		push_error("Setting %s/%s cannot support value %s" % [section, key, value])
	else:
		Settings.write_setting(section, key, value)
		setting_changed.emit(value)


## Gets the value using the Settings global node.
func get_value() -> Variant:
	return Settings.read_setting(section, key)


## Returns an editor Control to represent this value. Ideally, this control
## handles setting the setting value based on this control automatically.
func get_editor_control() -> Control:
	return Control.new()
