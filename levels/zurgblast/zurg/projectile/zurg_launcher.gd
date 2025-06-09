class_name ZurgLauncher extends Node3D

@export var projectile_scene: PackedScene
@export var sprite: AnimatedSprite2D

enum FireDirection {LOW, MED, HIGH}

class FireInfo:
	var ref: Node3D
	var animation: String
	
	func _init(_ref: Node, _anim: String):
		ref = _ref
		animation = _anim

@onready var FIRE_DATA: Dictionary[FireDirection, FireInfo] = {
	FireDirection.LOW: FireInfo.new($low, "shoot_low"),
	FireDirection.MED: FireInfo.new($med, "shoot_med"),
	FireDirection.HIGH: FireInfo.new($high, "shoot_high")
}

func fire(dir: FireDirection, speed: float, _size: float=0.1):
	var projectile: ZurgProjectile = projectile_scene.instantiate()
	var fire_info = FIRE_DATA[dir]
	var forward: Vector3 = fire_info.ref.to_global(Vector3.UP) - fire_info.ref.global_position
	get_tree().root.add_child(projectile)

	projectile.linear_velocity = forward * speed
	projectile.global_position = fire_info.ref.global_position
	
	sprite.play(fire_info.animation)
