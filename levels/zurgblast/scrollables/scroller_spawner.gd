extends Node3D

@export var spawn_offset: float = 20
@export var camera: Camera3D

@export var ramp_scene: PackedScene

func _ready():
	for lane in range(-4,5,2):
		schedule_lane(lane)

func schedule_lane(lane):
	var delay := randf_range(2,20)
	print("Delaying spawn in lane %s is %s" % [lane, delay])
	get_tree().create_timer(delay).timeout.connect(func(): spawn(lane))

func spawn(lane: int):
	print("Spawning in lane %s" % lane)
	var ramp: ZurgRamp = ramp_scene.instantiate()
	
	add_child(ramp)
	ramp.ramp_angle = randf_range(20, 45)
	ramp.flat_length = randf_range(0.2, 3)
	ramp.height = randf_range(1,2.5)
	ramp.position.x = camera.position.x + spawn_offset
	ramp.position.z = lane

	ramp.visible_box.screen_exited.connect(func(): schedule_lane(lane))
