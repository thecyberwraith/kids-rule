class_name PlayerInput
extends Resource
## Allows dyamic allocation of multiple controllers by decentralizing input
## logic. Registration of individual inputs is handled by the [PlayerInputs]
## class.

const UI_ACTIONS = [
		["accept_name", "ui_accept"],
		["cancel_name", "ui_cancel"],
		["left_name", "ui_left"],
		["right_name", "ui_right"],
		["up_name", "ui_up"],
		["down_name", "ui_down"],
]

var accept_name := "accept"
var cancel_name := "cancel"
var menu_name := "menu"
var left_name := "left"
var right_name := "right"
var up_name := "up"
var down_name := "down"


func _create_action_names(prefix := "action"):
	accept_name = "%s_accept" % prefix
	cancel_name = "%s_cancel" % prefix
	menu_name = "%s_menu" % prefix
	left_name = "%s_left" % prefix
	right_name = "%s_right" % prefix
	up_name = "%s_up" % prefix
	down_name = "%s_down" % prefix


## Creates a new action and populates it with the given events. If the action
## already exists, do nothing.
func _conditionally_add_events(action: String, events):
	if InputMap.has_action(action):
		return

	InputMap.add_action(action)
	
	if is_instance_of(events, InputEvent):
		events = [events]
	
	if not typeof(events) == TYPE_ARRAY:
		push_error("Tried to add non events \"%s\" to \"%s\"" % [events, action])
		return
	
	for evt in events:
		if not is_instance_of(evt, InputEvent):
			push_warning("%s is not an event." % evt)
			continue

		InputMap.action_add_event(action, evt)

func get_horizontal() -> float:
	return Input.get_axis(left_name, right_name)

func get_vertical() -> float:
	return Input.get_axis(down_name, up_name)

func get_move_direction() -> Vector2:
	return Vector2(get_horizontal(), -get_vertical()).normalized()

func get_xz_direction() -> Vector3:
	var vec_2d := get_move_direction()
	return Vector3(vec_2d.x, 0, vec_2d.y)

func get_accept_pressed() -> bool:
	return Input.is_action_just_pressed(accept_name)

func get_accept_held() -> bool:
	return Input.is_action_pressed(accept_name)

func get_cancel_pressed() -> bool:
	return Input.is_action_just_pressed(cancel_name)

func get_menu_pressed() -> bool:
	return Input.is_action_just_pressed(menu_name)

func equals(other: PlayerInput) -> bool:
	return other.to_string() == to_string()

## Bind this particular input to the following ui actions:
## - ui_accept
## - ui_cancel
## - ui_left
## - ui_right
## - ui_up
## - ui_down
## By default, the named actions of the class are copied over to the ui actions
func attach_to_ui():
	print("Attaching input %s to the UI" % self)
	
	for from_to in UI_ACTIONS:
		var from = self[from_to[0]]
		_copy_action_events(from, from_to[1])


static func clear_ui_attachments():
	print("Detaching all input from UI")
	for actions in UI_ACTIONS:
		InputMap.action_erase_events(actions[1])


## Replaces events in the `to` action with those of the `from` action.
func _copy_action_events(from: String, to: String):
	InputMap.action_erase_events(to)
	for evt in InputMap.action_get_events(from):
		InputMap.action_add_event(to, evt)
