extends Area2D
@onready var hit_box: HitBox = $"HitBox"

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_box.set_damage(50)
