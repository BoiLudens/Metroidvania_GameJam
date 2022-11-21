class_name HitBox
extends Area2D

var damage

func _init() -> void:
	collision_mask = 0
	# This turns off collision mask bit 1 and turns on bit 2. It's the physics layer we reserve to hurtboxes in this demo.
	collision_layer = 2
# Called when the node enters the scene tree for the first time.

func set_damage(new_damage):
	damage = new_damage
	

