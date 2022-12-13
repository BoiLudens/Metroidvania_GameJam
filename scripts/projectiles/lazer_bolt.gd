extends RigidBody2D

@export var damage: int = 20

@onready var hit_box: HitBox = $HitBox

func _ready():
	hit_box.damage = damage
	hit_box.monitorable = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_timer_timeout():
	hit_box.monitorable = true
