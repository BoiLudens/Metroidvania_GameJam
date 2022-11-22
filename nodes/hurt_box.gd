class_name HurtBox extends Area2D
@icon("res://nodes/HurtBox.svg")


func _init() -> void:
	# The hurtbox should detect hits but not deal them. This variable does that.
	monitorable = false
	# This turns off collision layer bit 1 and turns on bit 2. It's the physics layer we reserve to hurtboxes in this demo.
	collision_mask = 2


func _ready() -> void:
	area_entered.connect(self._on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if (hitbox.owner == owner):
		pass
	elif owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
