extends FallState

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var sound_stop: AudioStreamPlayer = $AudioStreamPlayerEnd

func on_enter_state(data):
	super.on_enter_state(data)
	sound.play()

func on_exit_state(data):
	super.on_exit_state(data)
	sound.stop()
