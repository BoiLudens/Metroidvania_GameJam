class_name HitBox extends Area2D
@icon("res://nodes/HitBox.svg")

var damage

func _init() -> void:
	collision_mask = 0
	# This turns off collision mask bit 1 and turns on bit 2. It's the physics layer we reserve to hurtboxes in this demo.
	collision_layer = 2
	
func set_damage(new_damage):
	damage = new_damage
	
