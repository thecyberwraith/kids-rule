extends AnimatedState

@export var idle: CharacterState
@onready var timer: Timer = $Timer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var next_state = null


func on_enter_state(data: StateMachine.Dependencies):
	super.on_enter_state(data)
	print("Healing allies!")
	
	audio.play()
	
	var ranger := data.character as RangerPlayer
	ranger.healing_burst_level.value = 0.0
	
	var particles: CPUParticles3D = data.visuals.get_node("HealingParticles")
	particles.emitting = true
	
	next_state = null
	
	timer.start(particles.lifetime / 3)
	timer.timeout.connect(transition, CONNECT_ONE_SHOT)
	
	for area in ranger.healing_area.get_overlapping_areas():
		var other_ranger := area.get_parent() as RangerPlayer
		other_ranger.damage.heal(1)


func transition():
	print("All done healing.")
	next_state = idle


func process(_d, _data):
	return next_state


func on_exit_state(_data: StateMachine.Dependencies):
	if timer.timeout.is_connected(transition):
		timer.timeout.disconnect(transition)
