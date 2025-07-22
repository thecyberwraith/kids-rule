extends Node


func _ready():
	_handle_video_settings()


func _handle_video_settings():
	var set_fullscreen := func(full: bool): 
		var mode := DisplayServer.WINDOW_MODE_WINDOWED
		if full:
			mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(mode)
	
	var setting := Settings.get_setting_item("video", "fullscreen")
	
	setting.setting_changed.connect(set_fullscreen)
	set_fullscreen.call_deferred(setting.get_value())
