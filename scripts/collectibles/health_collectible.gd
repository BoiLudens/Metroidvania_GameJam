extends Area2D

@export var health = -20

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("take_damage"):
		body.take_damage(health)
		queue_free()
