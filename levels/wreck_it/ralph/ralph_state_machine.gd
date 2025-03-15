extends GenericStateMachine
class_name RalphStateMachine

@export var ralph: CharacterBody3D
@export var animation: AnimatedSprite3D

var crate_container: Node3D

class RalphState:
	var ralph: CharacterBody3D
	var anim: AnimatedSprite3D
	var crates: Node3D
	
	func _init(c: CharacterBody3D, a: AnimatedSprite3D, cr: Node3D):
		ralph = c
		anim = a
		crates = cr

func _get_data():
	return RalphState.new(ralph, animation, crate_container)
