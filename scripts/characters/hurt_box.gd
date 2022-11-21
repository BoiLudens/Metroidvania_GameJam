class_name HurtBox
extends Area2D

func _ready() -> void:
	area_entered.connect(self._on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
