extends StaticBody2D

@onready var hit_box = $HitBox

@export var damage_value: int = 20

var health_max: float = 100
var health_value: float = 100 

# Called when the node enters the scene tree for the first time.
func _ready():
	hit_box.damage = damage_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if check_death():
		queue_free()

func take_damage(damage):
	health_value -= damage

func check_death():
	if (health_value <= 0):
		return true
