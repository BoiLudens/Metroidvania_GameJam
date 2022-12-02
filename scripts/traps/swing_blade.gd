extends Area2D
@onready var hurt_box = $"HitBox"

# Called when the node enters the scene tree for the first time.
func _ready():
	hurt_box.set_damage(50)
