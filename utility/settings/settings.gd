## Enables access and saving/loading of game data for the local user. It checks
## if requested and stored configurations match the default keys, otherwise
## errors are shown. In most regards, acts as ConfigFile.
extends Node

var All: Array[SettingsItem] = [
	SettingsItemEnum.new("game", "difficulty", Difficulty.NORMAL, Difficulty),
	SettingsItemBool.new("video", "fullscreen", false),
]

## How difficulty for mini games should scale.
enum Difficulty {EASY, NORMAL, HARD}

## The path to the settings file stored on disk
const FILE_PATH := "user://settings.cfg"

var _data: ConfigFile = null

func _ready():
	if not _data == null:
		return

	_load_config_data()


## Loads the configuration from the file, if it exists. Any missing settings
## or incorrect values from DEFAULTS is replaced with its default value.
func _load_config_data():
	_data = ConfigFile.new()
	
	if FileAccess.file_exists(FILE_PATH):
		if not _data.load(FILE_PATH) == OK:
			push_error("Settings file not successfully loaded. Starting new settings file.")
		else:
			print("Loaded settings file successfully.")

	_remove_extra_settings()
	_add_missing_default_settings()
	_data.save(FILE_PATH)


## Checks each section and key in the current configuration and erases any not
## represented in the DEFAULTS array.
func _remove_extra_settings():
	for section in _data.get_sections():
		for key in _data.get_section_keys(section):
			if get_setting_item(section, key) == null:
				print("Setting %s/%s is not a setting: removing" % [section, key])
				_data.erase_section_key(section, key)


## Sets default values for any settings in the DEFAULTS array which is are not
## present in the loaded settings.
func _add_missing_default_settings():
	for item in All:
		if not _data.has_section_key(item._section, item._key):
			print("Setting default value of %s for %s/%s" % [
				item._default, item._section, item._key
			])
			_data.set_value(item._section, item._key, item._default)


## Finds the associated settings item in the DEFAULTS array and return it if
## found. If not found, returns null.
func get_setting_item(section: String, key: String) -> SettingsItem:
	var idx := All.find_custom(func(x):
		return x._section == section and x._key == key
	)
	
	if idx == -1:
		return null
	else:
		return All[idx]


## Reads the requested setting without any safety checks. Consider using
## [method get_setting_item] or [method get_setting] instead.
func read_setting(section: String, key: String) -> Variant:
	return _data.get_value(section, key)


func get_setting(section: String, key: String) -> Variant:
	var setting := get_setting_item(section, key)

	if setting == null:
		push_error("Setting %s/%s does not exist" % [section, key])
		return null

	return setting.get_value()


## Stores the requested setting without any safety checks. Consider user
## [method set_setting] or [method SettingItem.set_value] instead. Stores
## the new settings onto disk.
func write_setting(section: String, key: String, value: Variant):
	_data.set_value(section, key, value)
	_data.save(FILE_PATH)


## Retrieves the associated setting item and sets its value.
func set_setting(section: String, key: String, value: Variant):
	var setting := get_setting_item(section, key)
	
	if setting == null:
		push_error("Setting %s/%s does not exist. Not setting value." % [section, key])
	else:
		setting.set_value(value)
