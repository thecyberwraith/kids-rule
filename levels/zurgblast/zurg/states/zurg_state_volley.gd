extends CharacterState

@export var wander: CharacterState

@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

var target: Node3D
var amount: int = 3
var fired: int = 0

var need_fired: bool = false

func on_enter_state(zurg: Zurg):
	var distance := 10000000.0

	for player in get_tree().get_nodes_in_group("rangers"):
		var my_distance := zurg.global_position.distance_squared_to(player.global_position)
		if my_distance < distance:
			target = player
			distance = my_distance

	fired = 0
	
	if zurg.damage.health.percentage < 0.6:
		amount = 5
	else:
		amount = 3
	
	timer.start()
	need_fired = true
	timer.timeout.connect(update_needs_fired)

func update_needs_fired():
	need_fired = true

func process(_dt, zurg: Zurg):
	if amount == fired:
		return wander
	
	if target == null:
		return null
	
	var look_dir := target.global_position - zurg.global_position
	var angle := Vector2.LEFT.angle_to(Vector2(look_dir.x, -look_dir.z))
	zurg.rotation = Vector3(0,angle,0)
	
	if need_fired:
		fire(zurg)
	
	return null


func fire(zurg: Zurg):
	fired += 1

	if target != null:
		zurg.launcher.fire(target.global_position)
	
	sound.play()
	
	need_fired = false


func on_exit_state(zurg: Zurg):
	timer.timeout.disconnect(update_needs_fired)
	zurg.rotation = Vector3.ZERO
