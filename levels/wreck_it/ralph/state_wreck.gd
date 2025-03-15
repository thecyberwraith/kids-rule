extends CharacterState

@export var idle: CharacterState

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var is_done: bool = false

func on_enter_state(data: RalphStateMachine.RalphState):
	data.anim.play("wreck")
	data.ralph.get_node("CPUParticles3D").emitting = true
	data.ralph.get_node("Area3D").body_entered.connect(_on_enter_wreck_area)
	is_done = false
	data.anim.animation_finished.connect(func():is_done=true)
	audio.play()
	search_for_wrecks(false, data.ralph.wreck_area)

func on_exit_state(data: RalphStateMachine.RalphState):
	data.ralph.get_node("CPUParticles3D").emitting = false
	data.ralph.wreck_area.body_entered.disconnect(_on_enter_wreck_area)
	audio.stop()

func process(_delta, data: RalphStateMachine.RalphState):
	if is_done:
		search_for_wrecks(true, data.ralph.wreck_area)
		data.ralph.anger += 1
		return idle

func search_for_wrecks(is_terminal: bool, area: Area3D):
	for body in area.get_overlapping_bodies():
		emit_wreck(body, is_terminal)

func emit_wreck(body: Node, is_terminal: bool):
	if body.has_method("get_wrecked"):
		body.get_wrecked(is_terminal)

func _on_enter_wreck_area(body):
	emit_wreck(body, false)
