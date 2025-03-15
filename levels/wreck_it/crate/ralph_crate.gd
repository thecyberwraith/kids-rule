extends Node3D
class_name RalphCrate

const MAX_DAMAGE = 3

@onready var anim :AnimatedSprite3D = $AnimatedSprite3D
@export var broken_crate : PackedScene

signal on_damage_change(int)

var damage: int = 0:
	set(value):
		var diff := value - damage
		if value > MAX_DAMAGE:
			damage = MAX_DAMAGE
			diff = 1
			var new_crate: Node3D = broken_crate.instantiate()
			get_tree().current_scene.add_child(new_crate)
			new_crate.global_position = global_position
			queue_free()
		elif value < 0:
			value = 0
			diff = 0
		
		damage = value
		anim.frame = damage
		on_damage_change.emit(diff)

func get_wrecked(is_terminal):
	if !is_terminal:
		return
	damage += 1

func get_fixed():
	damage -= 1
