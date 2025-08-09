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
	

	var direction: Vector3:
		get: 
			return ref.to_global(Vector3.UP) - ref.global_position
	
	var position: Vector3:
		get:
			return ref.global_position


	## Calculated the required velocity for the given path data (fixed angle and
	## and start position) to hit the current target when projected onto the plane
	## of the parabolic path. 
	## @return A tuple of floats [time, velocity]:
	##   the time till impact
	##   the velocity required
	## If impossible, returns [-1.0, -1.0].
	func find_velocity_required(target: Vector3) -> Array[float]:
		var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector").normalized()
		gravity *= ProjectSettings.get_setting("physics/3d/default_gravity")
		
		var velocity_direction := direction.normalized()
		
		# Project velocity orthogonally to gravity
		var orthogonal_to_gravity := get_orthogonal(velocity_direction, gravity)
		
		var plane_normal := gravity.cross(orthogonal_to_gravity).normalized()
		
		var p := target - position
		var projection := Plane(plane_normal, position).project(p)
		
		return find_needed_velocity_for_parabola(
			velocity_direction,
			gravity,
			projection
		)
		

	## Returns a unit vector orthogonal to b in a similar direction to a.
	func get_orthogonal(a: Vector3, b: Vector3) -> Vector3:
		return (a - a.project(b)).normalized()

	## A parabola in two dimension is launched with initial direction a and
	## acceleration of g (g does not require a negative sign). Find the scalar v
	## such that there exists a t where
	## p = t*v*a + t**2/2 * g
	## We assume that p is in the path of this parabola (otherwise, project first)
	## Returns -1.0 if no such v exists. Also returns the time in the first slot, or
	## -1 if no such time is possible.
	func find_needed_velocity_for_parabola(a: Vector3, g: Vector3, p: Vector3) -> Array[float]:
		var u := get_orthogonal(a, g)
		var k := p.dot(u)/a.dot(u)
		
		var discriminant := (2*g.dot(p-k*a))/g.dot(g)
		
		if discriminant < 0:
			return [-1.0, -1.0]
		
		var t := sqrt(discriminant)
		var v := k / t
		return [t, v]


@onready var FIRE_DATA: Dictionary[FireDirection, FireInfo] = {
	FireDirection.LOW: FireInfo.new($low, "shoot_low"),
	FireDirection.MED: FireInfo.new($med, "shoot_med"),
	FireDirection.HIGH: FireInfo.new($high, "shoot_high")
}

func fire(target: Vector3, _size: float=0.1):
	var time := 100000.0
	var velocity := -1.0
	var data: FireInfo = null
	
	for a_data in FIRE_DATA.values():
		var result: Array[float] = a_data.find_velocity_required(target)
		if result[0] < time and result[1] > 0:
			time = result[0]
			velocity = result[1]
			data = a_data
	
	if data == null:
		return
	
	var projectile: ZurgProjectile = projectile_scene.instantiate()

	get_tree().root.add_child(projectile)

	projectile.linear_velocity = data.direction * velocity
	projectile.global_position = data.position
	
	sprite.play(data.animation)
