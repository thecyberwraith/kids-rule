extends Area3D

@export var scene: String
@export var color_gradient: Gradient
@export var confirm_duration: float = .0

@onready var particles: CPUParticles3D = $CPUParticles3D

var confirmation_time: float = 0.0
var everyone_is_here: bool = false
var sample_value: float = 0.0

func _ready():
	body_entered.connect(_check_player_count)
	body_exited.connect(_check_player_count)

func _process(delta):
	if !everyone_is_here:
		confirmation_time = 0
	else:
		if confirmation_time < confirm_duration:
			confirmation_time += delta
		else:
			print("Switching to scene!")
			get_tree().change_scene_to_file(scene)
	
	sample_value = lerpf(
		sample_value,
		clampf(confirmation_time/confirm_duration, 0.0, 1.0),
		delta*0.5
	)
	
	particles.color = color_gradient.sample(sample_value)

func _check_player_count(_body):
	var player_count := get_overlapping_bodies().filter(func(x): return is_instance_of(x, Player)).size()
	
	particles.emitting = player_count > 0
	var players := get_tree().get_node_count_in_group("players")
	everyone_is_here = (players > 0) and (player_count >= players)
