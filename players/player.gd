class_name Player
extends CharacterBody3D

@onready var viewport: SubViewport:
	get():
		if _viewport == null:
			_viewport = get_node("SubViewport")
		return _viewport

@onready var sprite_3d: Sprite3D:
	get():
		if _sprite == null:
			_sprite = get_node("Sprite3D")
		return _sprite

@onready var visuals_container: Node2D:
	get():
		if _vis_cont == null:
			_vis_cont = get_node("SubViewport/Offset")
		return _vis_cont

@onready var state_machine: StateMachine:
	get():
		if _machine == null:
			_machine = get_node("StateMachine")
		return _machine

var _sprite: Sprite3D
var _viewport: SubViewport
var _vis_cont: Node2D
var _machine: StateMachine

var equipment: Array[Equipment] = []

@export var input: PlayerInput = PlayerInput.new():
	set(value):
		input = value
		if state_machine != null:
			state_machine.input = input
		print("Setting %s input to %s" % [name, input])

var _visuals: PlayerVisuals

var visuals: PlayerVisuals:
	set(value):
		print("Overwriting visuals")
		var old_visuals := visuals
		var old_equipment := equipment.duplicate()
		
		if old_visuals != null:
			print("Unequipping from old visuals")
			for item in old_equipment:
				unequip(item.key)
				
		visuals = value
		_visuals = value
		
		if viewport == null or state_machine == null:
			return
			
		if visuals_container.get_child_count() > 0:
			visuals_container.remove_child(visuals_container.get_child(0))
		
		state_machine.visuals = visuals
		
		if visuals != null:
			visuals_container.add_child(visuals)
			print("Reequipping to new visuals")
			for item in old_equipment:
				equip(item)

	get():
		if _visuals == null:
			_visuals = visuals_container.get_child(0)
		
		return _visuals

func _ready():
	visuals = visuals # Connect things only when ready
	input = input

## Convenience hook for connected signals outside of the ready function.
func on_level_manager_prep_done():
	pass

func equip(item: Equipment):
	if equipment.any(func(x): return x.key == item.key):
		print("Tried re-equipping item ", item)
		return
		
	item.on_equip(self)
	equipment.append(item)
	print("%s equipped %s" % [self.name, item.key])

func unequip(key: String):
	for item in equipment:
		if item.key == key:
			item.on_unpequip(self)
			equipment.erase(item)
			return
