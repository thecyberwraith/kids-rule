extends Node2D

@onready var b: Node2D = $Node2D
@onready var c: Node2D = $Node2D/Node2D

func _process(_d):
	var ta := transform
	var tb := b.transform
	var tc := c.transform
	
	print(position, global_position)
	print(b.position, b.global_position)
	print(c.position, c.global_position)
	
	print("Transforms")
	print(ta, global_transform)
	print(ta*tb, b.global_transform)
	print(ta*tb*tc, c.global_transform)

	print("Done")
