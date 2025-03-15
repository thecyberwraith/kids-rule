class_name PlayerVisuals
extends Node

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var skeleton: Skeleton2D = $Skeleton2D
@onready var sprites: Node2D = $Visuals

signal animation_key(animation_name: String, data: Object)

## Maps a string key to [mounted node, remote transform]
var mounts: Dictionary

func play(anim: String = ""):
	animation.play(anim, 0.2)

func mount(key: String, sprite: Node2D, bone_name: String, behind: String = ""):
	if key in mounts:
		unmount(key)
	
	var bone := skeleton.find_child(bone_name)
	var rt := RemoteTransform2D.new()

	bone.add_child(rt)
	
	if behind.length() != 0:
		var other_node := find_child(behind)
		other_node.add_sibling(sprite)
		other_node.get_parent().move_child(sprite, other_node.get_index())
	else:
		sprites.add_child(sprite)
	
	rt.remote_path = sprite.get_path()

	mounts[key] = [sprite, rt]

# This removes AND FREES the associated remote transform as well as the passed node.
func unmount(key: String):
	for item in mounts[key]:
		item.queue_free()
	
	mounts.erase(key)

func animation_keyed(data: Object):
	animation_key.emit(animation.current_animation, data)
