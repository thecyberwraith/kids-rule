class_name PlayerInput
extends Resource
## Allows dyamic allocation of multiple controllers by decentralizing input
## logic. Registration of individual inputs is handled by the [PlayerInputs]
## class.

var accept_name := "accept"
var cancel_name := "cancel"
var menu_name := "menu"
	
func get_horizontal() -> float:
	return 0

func get_vertical() -> float:
	return 0

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
