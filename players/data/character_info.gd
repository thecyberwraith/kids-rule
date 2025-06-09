class_name CharacterInfo extends Resource

@export var name: String
@export var head: String
@export var path: String

func _init(a_name: String, a_path: String, a_head: String):
	name = a_name
	path = a_path
	head = a_head
	
func equals(other: Object) -> bool:
	if not is_instance_of(other, CharacterInfo):
		return false
	
	var other_char = other as CharacterInfo
	return  (other_char.name == name
		and other_char.path == path
		and other_char.head == head
	)
