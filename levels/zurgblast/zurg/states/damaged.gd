extends CharacterState

var next_state: CharacterState = null
@export var wander: CharacterState

func on_enter_state(zurg: Zurg):
	next_state = null
	zurg.damage.invincibility_stop.connect(
		func(): set_parameters(zurg, 0.0, 0.0),
		CONNECT_ONE_SHOT
	)
	get_tree().create_timer(zurg.damage.invincible_duration/3).timeout.connect(
		func(): next_state=wander, CONNECT_ONE_SHOT
	)
	zurg.sprite.play("damage")
	set_parameters(zurg, 30, 0.4)

func set_parameters(zurg: Zurg, ossilations, intensity):
	zurg.sprite.material.set_shader_parameter("ossilation_factor", ossilations)
	zurg.sprite.material.set_shader_parameter("min_intensity", intensity)

func process(_dt: float, _zurg: Zurg):
	return next_state
