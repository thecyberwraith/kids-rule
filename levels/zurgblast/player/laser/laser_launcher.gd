extends Marker3D

@export var laser_beam: PackedScene
@export var laser_beam_velocity: float = 9

func fire(damage):
	var laser: RigidBody3D = laser_beam.instantiate()
	get_tree().root.add_child(laser)
	laser.damage = damage
	laser.global_position = global_position
	laser.linear_velocity = (to_global(Vector3.RIGHT) - global_position) * laser_beam_velocity
