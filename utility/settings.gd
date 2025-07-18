## Enables access and saving/loading of game data for the local user. It checks
## if requested and stored configurations match the default keys, otherwise
## errors are shown. In most regards, acts as ConfigFile.
extends Node

## How difficulty for mini games should scale.
enum Difficulty {EASY, NORMAL, HARD}

## The path to the settings file stored on disk
const FILE_PATH := "user://settings.cfg"

## When not specified, these values are automatically assumed. Keys set and
## requested will be compared to this dictionary.
const DEFAULT_VALUES := {
	"root": {
		"version": 1
	},
	"game": {
		"difficulty": Difficulty.NORMAL,
	},
	"video": {
		"fullscreen": false
	}
}

var _data: ConfigFile = null

func _ready():
	if not _data == null:
		return

	_data = ConfigFile.new()
	
	if FileAccess.file_exists(FILE_PATH):
		if not _data.load(FILE_PATH) == OK:
			push_error("Settings file not successfully loaded. Starting new settings file.")
		else:
			print("Loaded settings file successfully.")
	
	print("Added default values to settings.")
	
	for section in DEFAULT_VALUES:
		for key in DEFAULT_VALUES[section]:
			if not _data.has_section_key(section, key):
				_data.set_value(section, key, DEFAULT_VALUES[section][key])


func _check_for_default_keys(section: String, key: String):
	if not DEFAULT_VALUES.has(section):
		push_warning("Settings has no default section for ", section)
	
	if not DEFAULT_VALUES.get(section, Dictionary()).has(key):
		push_warning("Settings default section %s has no value %s" % [section, key])


func get_value(section: String, key: String) -> Variant:
	_check_for_default_keys(section, key)
	return _data.get_value(section, key)


func set_value(section: String, key: String, value: Variant):
	_check_for_default_keys(section, key)
	_data.set_value(section, key, value)
	_data.save(FILE_PATH)
