class_name Ralph
extends CharacterBody3D

@onready var machine: RalphStateMachine = $StateMachine
@onready var wreck_area: Area3D = $Area3D

@export var anger: int

@warning_ignore("unused_signal")
signal game_over

var crate_container: Node3D:
	set(value):
		crate_container = value
		machine.crate_container = crate_container

var crate_targets: Node3D:
	set(value):
		crate_container = value

class Target:
	var object: Node3D
	var position
	
	func _init(obj: Node3D, pos=null):
		object = obj
		position = pos
	
	func get_position() -> Vector3:
		if position != null:
			return position
		return object.position

var target
@onready var smash_area: Area3D

func _ready():
	target = null

func start():
	var start_state := machine.get_node("Idle")
	machine.transition_to_state(start_state)
