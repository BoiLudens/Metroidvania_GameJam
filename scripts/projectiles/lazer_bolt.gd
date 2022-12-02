extends RigidBody2D

@export var damage = 20

@onready var hit_box = $HitBox

var bullet_speed = 100

func _ready():
	hit_box.damage = damage

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
