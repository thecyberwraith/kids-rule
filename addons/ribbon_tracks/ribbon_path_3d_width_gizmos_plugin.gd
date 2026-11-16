extends EditorNode3DGizmoPlugin

const HANDLES_MAT = "handles"
const POS_MAT = "pos_line"
const NEG_MAT = "neg_line"

func _get_gizmo_name():
	return "RibbonPath3DWidthGizmo"


func _has_gizmo(node: Node3D):
	return node is RibbonPath3D

func _init():
	create_material(POS_MAT, Color(0, 1, 0))
	create_material(NEG_MAT, Color(1, 0, 0))
	create_handle_material(HANDLES_MAT)


func _redraw(gizmo):
	gizmo.clear()

	var ribbon: RibbonPath3D = gizmo.get_node_3d()

	_redraw_ribbon_lines(ribbon, gizmo)
	_redraw_ribbon_width_handles(ribbon, gizmo)


func _redraw_ribbon_lines(ribbon: RibbonPath3D, gizmo: EditorNode3DGizmo):
	var line_data = [ #[mat name, array of points]
		[POS_MAT, ribbon._ribbon_points_pos],
		[NEG_MAT, ribbon._ribbon_points_neg],
	]

	for dat in line_data:
		var lines = PackedVector3Array()
		var arr = dat[1]
			
		for i in range(1, arr.size()):
			lines.append_array([
				arr[i-1],
				arr[i]
			])
		
		if ribbon.curve.closed and arr.size()>0:
			lines.append_array([
				arr[-1],
				arr[0]
				])

		gizmo.add_lines(lines, get_material(dat[0], gizmo), false)


func _redraw_ribbon_width_handles(ribbon: RibbonPath3D, gizmo: EditorNode3DGizmo):
	var handles = PackedVector3Array()

	for i in ribbon.curve.point_count:
		var pt := ribbon.curve.get_point_position(i)
		handles.push_back(
			ribbon.curve.sample_baked_with_rotation(
				ribbon.curve.get_closest_offset(pt), true, true
			).translated_local(Vector3.RIGHT*ribbon._widths[i]).origin
		)

	gizmo.add_handles(handles, get_material(HANDLES_MAT, gizmo), [], false, false)


func _begin_handle_action(gizmo, handle_id, secondary):
	pass


func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2):
	var ribbon: RibbonPath3D = gizmo.get_node_3d()
	var local_pt := ribbon.curve.get_point_position(handle_id)
	
	var curve_pt := ribbon.to_global(local_pt)
	var curve_dir := ribbon.get_ribbon_edge(handle_id) - local_pt
	
	var cursor_pt := camera.project_ray_origin(screen_pos)
	var cursor_dir := camera.project_ray_normal(screen_pos)
	
	var a := cursor_pt - curve_pt

	var d11 := curve_dir.dot(curve_dir)
	var d22 := cursor_dir.dot(cursor_dir)
	var d12 := curve_dir.dot(cursor_dir)
	var ad1 := a.dot(curve_dir)
	var ad2 := a.dot(cursor_dir)
	
	var denom := d12*d12 - d11*d22

	#print("Handling")
	#print(denom)
	if is_zero_approx(denom):
		return

	var t := (d12*ad2 - ad1*d22)/denom
	var width := t * curve_dir.length()
	var widths := ribbon._widths.duplicate()
	widths[handle_id] = abs(width)
	ribbon._widths = widths
	ribbon.update_gizmos()


func _commit_handle(gizmo, handle_id, secondary, restore, cancel):
	pass


func _get_handle_name(gizmo, handle_id, secondary):
	return "Ribbon Width %s" % handle_id


func _get_handle_value(gizmo, handle_id, secondary):
	return (gizmo.get_node_3d() as RibbonPath3D)._widths[handle_id]
