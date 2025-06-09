class_name GenericStateMachine
extends Node

@export var state: CharacterState

func _ready():
	if state != null:
		state.on_enter_state(_get_data())

func _process(delta):
	if state == null:
		return
	
	var next_state := state.process(delta, _get_data())
	
	if next_state != null:
		transition_to_state(next_state)

func transition_to_state(new_state: CharacterState):
	if state != null:
		state.on_exit_state(_get_data())
	state = new_state
	if state != null:
		state.on_enter_state(_get_data())

func _get_data():
	return null

## Given a node with children of CharacterState types, remove all current children,
## move children from node to self, and set the first node as the current state.
func replace_states(new_states: Node):
	for _i in get_child_count():
		remove_child(get_child(0))

	for _i in new_states.get_child_count():
		var new_state = new_states.get_child(0)
		new_state.owner = null
		new_states.remove_child(new_state)
		add_child(new_state)
	
	transition_to_state(TransitionState.new(get_child(0)))
