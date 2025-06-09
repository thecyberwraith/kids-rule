extends Node

func _ready():
	print("Debuggy is loaded.")
	set_process_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	for joypad in Input.get_connected_joypads():
		print(Input.get_joy_name(joypad))
		for button in 20:
			if Input.is_joy_button_pressed(joypad, button):
				print(button, "It's down!")

func _input(event):
	print(event)

func _unhandled_input(event):
	print("unhandled:", event)
