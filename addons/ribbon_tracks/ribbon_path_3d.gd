@tool
## Creates a ribbon based on a curve. Since a widening of a Bezier curve is
## not a Bezier curve, this method instead uses the default curve to calculate
## tilts. The left and right paths have their positions determined by the base
## curve, but their in/out vectors are independently calculated.
class_name RibbonPath3D extends Path3D

# The distance along the track for a cylinder slice.
@export var offset_change: float = 2.0:
	set(val):
		offset_change = abs(val)
		_update_ribbon_positions()
		ribbon_changed.emit()
		update_gizmos()

# The distance maintained from the point in either direction for the road.
@export var _widths: Array[float] = []:
	set(val):
		_widths=val
		_update_ribbon_positions()
		ribbon_changed.emit()

# Track the old points of the curve to detect when the count changes.
var _old_points: Array[Vector3] = []

# The cached points contained on the ribbon's positive edges
var _ribbon_points_pos: Array[Vector3] = []

# The cahced points contained on the ribbon's negative edge
var _ribbon_points_neg: Array[Vector3] = []

# Called when the ribbon or the curve changes
signal ribbon_changed

func _init():
	curve_changed.connect(_on_curve_change)

func _ready():
	_old_points = []
	for i in curve.point_count:
		_old_points.append(curve.get_point_position(i))

	if _widths.size() == 0 and _old_points.size() > 0:
		for _x in _old_points:
			_widths.append(1.0)

	_on_curve_change()


func _on_curve_change():
	_synchronize_width_changes()
	_update_ribbon_positions()
	
	# Recache the old points
	_old_points = []
	for i in curve.point_count:
		_old_points.append(curve.get_point_position(i))


func _update_ribbon_positions():
	_ribbon_points_pos.clear()
	_ribbon_points_neg.clear()

	var offset_list: Array[float] = []
	var widths_list := _widths.duplicate()
	
	for i in curve.point_count:
		offset_list.push_back(curve.get_closest_offset(curve.get_point_position(i)))

	if curve.closed:
		offset_list.push_back(curve.get_baked_length())
		widths_list.push_back(widths_list[0])

	# Iterate over the intervals between points. We include the first point in
	# the list and use the second point to interpolate for all but the last
	# interval.
	for i in offset_list.size() - 1:
		var offset_a := offset_list[i]
		var offset_b := offset_list[i+1]

		var width_a = widths_list[i]
		var width_b = widths_list[i+1]
		
		var interval_count := int(ceilf(offset_b-offset_a)/offset_change)
		
		if interval_count < 1:
			interval_count = 1
		
		for j in interval_count:
			var progress := float(j) / interval_count
			var offset := lerpf(offset_a, offset_b, progress)
			var width := lerpf(width_a, width_b, progress)
			var world := curve.sample_baked_with_rotation(offset, true, true)

			_ribbon_points_pos.push_back(
				world.translated_local(Vector3.RIGHT*width).origin
			)
			_ribbon_points_neg.push_back(
				world.translated_local(Vector3.LEFT*width).origin
			)

	# If the curve is not closed, manually add the last point.
	if not curve.closed:
		var world := curve.sample_baked_with_rotation(curve.get_baked_length())
		_ribbon_points_pos.push_back(
			world.translated_local(Vector3.RIGHT*_widths[-1]).origin
		)
		_ribbon_points_neg.push_back(
			world.translated_local(Vector3.LEFT*_widths[-1]).origin
		)

	ribbon_changed.emit()


# When the point counts change, we need to either add or remove a width to
# match.
func _synchronize_width_changes():
	if curve.point_count == _old_points.size():
		return

	# Find the mismatched point of overlapping indices
	var changed_idx := -1
	
	for i in min(curve.point_count, _old_points.size()):
		var p := curve.get_point_position(i)
		if p.distance_squared_to(_old_points[i]) > 0.001:
			changed_idx = i
			break

	var widths := _widths.duplicate()

	#print("Change detected at index ", changed_idx)
	
	# Inserting new width
	if curve.point_count > _old_points.size():
		# Starting widths of 1
		if _old_points.size() == 0 and curve.point_count == 1:
			#print("Adding first width.")
			widths.push_back(1)
		# If no changes, then the last one was added
		elif changed_idx == -1:
			#print("Duplicating last width")
			widths.push_back(_widths[-1])
		# Otherwise, interpolate width
		else:
			#print("Interpolating width at ", changed_idx)
			var i := changed_idx
			var old_pts := _old_points.size()
			var pts := curve.point_count
			var new_pt_progress := inverse_lerp(
				curve.get_closest_offset(curve.get_point_position((i-1)%pts)),
				curve.get_closest_offset(curve.get_point_position((i+1)%pts)),
				curve.get_closest_offset(curve.get_point_position(i))
			)

			widths.insert(i, lerp(
				widths[i],
				widths[(i-1) % old_pts],
				new_pt_progress
				)
			)
	# Delete some width
	else:
		# Deleting last width
		if changed_idx == -1:
			#print("Removing last width")
			widths.pop_back()
		# Delete the different one.
		else:
			#print("Removing width at ", changed_idx)
			widths.pop_at(changed_idx)

	_widths = widths


# Get the translated ribbon point by index. Assumes you want the positive point.
func get_ribbon_edge(idx: int, positive: bool=true) -> Vector3:
	var offset := curve.get_closest_offset(curve.get_point_position(idx))
	var world := curve.sample_baked_with_rotation(offset)
	return world.translated_local(Vector3.RIGHT*_widths[idx]).origin
