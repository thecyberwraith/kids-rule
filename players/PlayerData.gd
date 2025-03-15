extends Node
class_name PlayerData

class CharacterInfo:
	var name: String
	var path: String
	
	func _init(a_name: String, a_path: String):
		name = a_name
		path = a_path

class PlayerInfo:
	var character: CharacterInfo
	var input: PlayerInput
	
	func _init(an_input: PlayerInput, a_character: CharacterInfo):
		input = an_input
		character = a_character
