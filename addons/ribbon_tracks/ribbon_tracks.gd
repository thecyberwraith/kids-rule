@tool
extends EditorPlugin

const Ribbon3DPathWidthGizmo = preload("res://addons/ribbon_tracks/ribbon_path_3d_width_gizmos_plugin.gd")

var gizmo_plugin = Ribbon3DPathWidthGizmo.new()

func _enter_tree():
	add_custom_type("RibbonPath3D", "Path3D",
		preload("res://addons/ribbon_tracks/ribbon_path_3d.gd"),
		preload("res://addons/ribbon_tracks/ribbon_3d.svg")
	)
	add_node_3d_gizmo_plugin(gizmo_plugin)


func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
	remove_custom_type("RibbonPath3D")
