extends CharacterState

@export var win_state: CharacterState
@export var move_to_target: CharacterState
@export var wait_time: float = 2.0

var current_wait_time: float

func on_enter_state(data: RalphStateMachine.RalphState):
	data.anim.play("idle")
	current_wait_time = 0.5 + 1/(1+data.ralph.anger)*wait_time

func process(delta: float, data: RalphStateMachine.RalphState):
	current_wait_time -= delta
	if current_wait_time > 0:
		return null
	
	var crates := data.crates.get_children()

	if crates.size() == 0:
		return win_state
	elif crates.size() > 1:
		var closest: RalphCrate = crates[0]
		var closest_distance := data.ralph.position.distance_squared_to(closest.position)
		for i in range(1,crates.size()):
			var new_dist = data.ralph.position.distance_squared_to(crates[i].position)
			if new_dist < closest_distance:
				closest_distance = new_dist
				closest = crates[i]
		
		crates.erase(closest)

	data.ralph.target = Ralph.Target.new(crates.pick_random())
	return move_to_target
