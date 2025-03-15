extends Equipment
class_name RepairHammer

static var sprite2D_template := preload("res://levels/wreck_it/hammer/repair_hammer_2d.tscn")
static var node3D_template := preload("res://levels/wreck_it/hammer/repair_hammer_3d.tscn")

var sprite2D: Node2D
var node3D: Node3D
var audio: AudioStreamPlayer

func _init():
	key = "hammer"

func on_equip(player: Player):
	sprite2D = sprite2D_template.instantiate()
	node3D = node3D_template.instantiate()
	audio = sprite2D.get_node("AudioStreamPlayer")
	
	player.visuals.mount("hammer", sprite2D, "front-hand-mount", "Hand")
	player.add_child(node3D)
	var remote := Remote2DTo3DTransform.new()
	sprite2D.get_node("Mount").add_child(remote)
	remote.remote = node3D
	remote.root_3d = player.sprite_3d

	player.visuals.animation_key.connect(swing)

func swing(_anim_name, _data):
	var area: Area3D = node3D.get_node("Area3D")
	for object in area.get_overlapping_bodies():
		if is_instance_of(object, RalphCrate):
			var crate: RalphCrate = object as RalphCrate
			crate.get_fixed()
			var emitter: CPUParticles3D = node3D.get_node("HammerParticles")
			emitter.emitting = true
			audio.play()

func on_unequip(player: Player):
	player.visuals.unmount("hammer")
	sprite2D.queue_free()
	node3D.queue_free()
	player.animation_key.disconnect(swing)
