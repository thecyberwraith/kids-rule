@tool
class_name Ribbon3D extends Curve3D

@export_group("Ribbon Lengths")
@export var ribbon_lengths: PackedFloat32Array = []


func add_point(position: Vector3, in_vec: Vector3 = Vector3(0, 0, 0), out: Vector3 = Vector3(0, 0, 0), index: int = -1):
	super.add_point(position, in_vec, out, index)
	ribbon_lengths.append(1.0)


func clear_points():
	super.clear_points()
	ribbon_lengths.clear()


func remove_point(idx: int):
	super.remove_point(idx)
	ribbon_lengths.remove_at(idx)
